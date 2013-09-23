//
//  AMWorksheetView.m
//  Amalie
//
//  Created by Keith Staines on 04/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//
#import "QuartzCore/QuartzCore.h"
#import "AMWorksheetView.h"
#import "AMConstants.h"
#import "AMInsertableView.h"
#import "AMWorksheetController.h"

static BOOL LOG_DRAG_OPS = NO;
static NSUInteger const kAMDefaultLineSpace   = 20;
static NSUInteger const kAMDefaultLeftMargin  = 36;
static NSUInteger const kAMDefaultTopMargin   = 36;

static CGFloat const MINWIDTH  = 600.0;
static CGFloat const MINHEIGHT = 600.0;

@implementation AMWorksheetView


# pragma mark - Initializers -
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)awakeFromNib
{
    // Determine the class name for draggable types
    NSMutableArray * allTypes = [NSMutableArray array];
    NSArray * typesArray;
    
    // Add pasteboard types for each type of insertable object

    // Insertable object
    typesArray = [AMInsertableView writableTypesForPasteboard:[NSPasteboard generalPasteboard]];
    [allTypes addObjectsFromArray:typesArray];
    
    // register them all in one hit...
    [self registerForDraggedTypes:allTypes];
}

# pragma mark - Dragging -

-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    if (LOG_DRAG_OPS) NSLog(@"%@ - draggingEntered" , self);
    
    // check type and see if we can accept, and if we can, what we will do with it
    NSDragOperation operation = NSDragOperationNone;
    id source = [sender draggingSource];
    
    if (source)
    {
        // dragging source is in this application
        if ( [[[sender draggingSource] identifier] isEqualToString:kAMTrayDictionaryKey] ) {
            // Object being dropped in from the tray
            operation = NSDragOperationCopy;
        } else {
            operation = NSDragOperationMove;
        }
    }
    
    return operation;
}

-(NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
{
    NSDragOperation operation = NSDragOperationNone;
    id source = [sender draggingSource];
    
    if ( [[source identifier] isEqualToString:kAMTrayDictionaryKey] ) {
        // Object being dropped in from the tray
        operation = NSDragOperationCopy;
    } else {
        operation = NSDragOperationMove;
    }
    
    return operation;
    
}

-(void)draggingEnded:(id<NSDraggingInfo>)sender
{
    if (LOG_DRAG_OPS) NSLog(@"%@ - draggingEnded" , self);
}

-(void)draggingExited:(id<NSDraggingInfo>)sender
{
    if (LOG_DRAG_OPS) NSLog(@"%@ - draggingExited" , self);
}

-(BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender
{
    // We are always prepared. Maybe change this later if doing something that can't be interrupted (editing something for example?).
    if (LOG_DRAG_OPS) NSLog(@"%@ - prepareForDragOperation" , self);

    return YES;
}

-(BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    if (LOG_DRAG_OPS) NSLog(@"%@ - performDragOperation" , self);
    static NSArray * classes;
    
    if (!classes) {
        classes = @[ [AMInsertableView class] ];
    }

    // Place dragged object into view hierarchy
    NSPasteboard * pb = [sender draggingPasteboard];
    NSArray * objects = [pb readObjectsForClasses:classes options:nil];
    AMInsertableView * view = objects[0];
    
    if (view) {
        
        NSPoint draggingLocation = [sender draggingLocation];
        draggingLocation = [self convertPoint:draggingLocation fromView:nil];
        
        // Deal with items coming from the tray (library of insertable objects)
        if ( [[[sender draggingSource] identifier] isEqualToString:kAMTrayDictionaryKey] ) {
            [self.delegate workheetView:self wantsViewInserted:view withOrigin:draggingLocation];
            return YES;
        }
        
        // Dragging source is the view itself, which is being repositioned in the worksheet
        NSPoint mouseDownWindowPoint = view.mouseDownWindowPoint;
        NSPoint mouseDownViewPoint = [self convertPoint:mouseDownWindowPoint fromView:nil];
        float deltaX = draggingLocation.x - mouseDownViewPoint.x;
        float deltaY = draggingLocation.y - mouseDownViewPoint.y;
        NSPoint newTopLeft = NSMakePoint(view.frameLeft + deltaX, view.frameTop + deltaY);
        [self.delegate workheetView:self wantsViewMoved:view newTopLeft:newTopLeft];
        return YES;
    }
    return NO;
}

-(void)concludeDragOperation:(id<NSDraggingInfo>)sender
{
    if (LOG_DRAG_OPS) NSLog(@"%@ - concludeDragOperation" , self);
}

# pragma mark - Drawing -

-(void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
    
    for (NSView * view in self.subviews) {
        if (NSIntersectsRect(view.frame, dirtyRect)) {
            NSRect intersect = NSIntersectionRect(view.frame, dirtyRect);
            [view displayRect:intersect];
        }
    }
}

# pragma mark - Layout -

-(void)layoutInsertsNow
{
    NSArray * insertsArray = [self sortInserts];
    NSSize size = [self intrinsicContentSize];
    [CATransaction begin];
    NSSize scrollViewSize = self.superview.frame.size;
    size.width = fmaxf(size.width,   scrollViewSize.width);
    size.height = fmaxf(size.height, scrollViewSize.height);
    [self setFrameSize:size];
    
    float firstTop = size.height - kAMDefaultTopMargin;
    NSPoint newTopLeft = NSMakePoint(kAMDefaultLeftMargin, firstTop);
    for (AMInsertableView * view in insertsArray) {
        [view setFrameTopLeft:newTopLeft animate:YES];
        newTopLeft = NSMakePoint(newTopLeft.x, newTopLeft.y - view.frameHeight - kAMDefaultLineSpace);
    }
    [CATransaction commit];
}

-(NSArray*)sortInserts
{
    NSMutableArray * insertsArray = [self.subviews mutableCopy];
    [insertsArray sortUsingComparator: ^(id obj1, id obj2) {
        
        AMInsertableView * ami1 = obj1;
        AMInsertableView * ami2 = obj2;
        
        // Deal with both objects at same horizontal level
        if (ami1.frameTop == ami2.frameTop) {
            
            if (ami1.frameLeft == ami2.frameLeft) {
                // obj1 has same left position as obj2
                return (NSComparisonResult)NSOrderedSame;
            }
            if (ami1.frameLeft < ami2.frameLeft) {
                // obj 1 is to the left of obj2
                return (NSComparisonResult)NSOrderedAscending;
            } else {
                // obj 2 is to the left of obj 1
                return (NSComparisonResult)NSOrderedDescending;
            }
        }
        
        // Not at same level, so just need to worry about their y-ordering
        if (ami1.frameTop > ami2.frameTop) {
            // obj 1 is above obj 2
            return (NSComparisonResult)NSOrderedAscending;
        }
        // since we dealt with the possibility of both being at the same height earlier, the only possibility left is that obj 2 is above obj 1
        return (NSComparisonResult)NSOrderedDescending;
    }];
    
    return insertsArray;
}

-(NSSize)intrinsicContentSize
{
    CGFloat height = 0.0;
    CGFloat width  = 0.0;
    for (NSView * view in self.subviews) {
        height += (view.frame.size.height + kAMDefaultLineSpace);
        width = fmaxf(view.frame.size.width,width);
    }
    width += (2 * kAMDefaultLeftMargin);
    width  = fmaxf(width, MINWIDTH);
    if (height >= kAMDefaultLineSpace) height -= kAMDefaultLineSpace;
    height += (2 * kAMDefaultTopMargin);
    height = fmaxf(height,MINHEIGHT);
    return NSMakeSize(width, height);
}

# pragma mark - Overrides -

-(BOOL)isFlipped
{
    return NO;
}



@end
