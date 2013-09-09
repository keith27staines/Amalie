//
//  AMWorksheetView.m
//  Amalie
//
//  Created by Keith Staines on 04/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMWorksheetView.h"
#import "AMConstants.h"
#import "AMInsertableView.h"
#import "AMWorksheetController.h"

static BOOL LOG_DRAG_OPS = NO;

@implementation AMWorksheetView

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


-(void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
    
    for (NSView * view in self.subviews) {

        if (NSIntersectsRect(view.frame, dirtyRect)) {
            NSRect intersect = NSIntersectionRect(view.frame, dirtyRect);
            [view displayRect:intersect];
            NSLog(@"Displaying view %@",view);
        }
    }
}

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

-(void)resizeWithOldSuperviewSize:(NSSize)oldSize
{
    NSSize newSize = self.superview.frame.size;
    self.frame = NSMakeRect(0, 0, newSize.width, newSize.height);
    [super resizeWithOldSuperviewSize:oldSize];
}

-(void)resizeSubviewsWithOldSize:(NSSize)oldSize
{
    [super resizeSubviewsWithOldSize:oldSize];
}

-(NSSize)intrinsicContentSize
{
    return [self.delegate intrinsicSizeForWorksheet:self];
}

-(BOOL)isFlipped
{
    return NO;
}

-(void)concludeDragOperation:(id<NSDraggingInfo>)sender
{
    if (LOG_DRAG_OPS) NSLog(@"%@ - concludeDragOperation" , self);
}


@end
