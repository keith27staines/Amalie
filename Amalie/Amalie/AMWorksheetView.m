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
#import "AMAmalieDocument.h"

static BOOL LOG_DRAG_OPS = NO;

@implementation AMWorksheetView


# pragma mark - Initializers -
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setupAcceptsDragsAndInserts];
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
    
    [self setPostsFrameChangedNotifications:YES];
}

# pragma mark - Dragging -
-(void)setupAcceptsDragsAndInserts
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
-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    if (LOG_DRAG_OPS) NSLog(@"%@ - draggingEntered" , self);
    
    // check type and see if we can accept, and if we can, what we will do with it
    NSDragOperation operation = NSDragOperationNone;
    id source = [sender draggingSource];
    
    if (source)
    {
        // dragging source is in this application
        if ( [[[sender draggingSource] identifier] isEqualToString:kAMLibraryObjectsKey] ) {
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
    
    if ( [[source identifier] isEqualToString:kAMLibraryObjectsKey] ) {
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
        if ( [[[sender draggingSource] identifier] isEqualToString:kAMLibraryObjectsKey] ) {
            [self.delegate workheetView:self wantsViewInserted:view withOrigin:draggingLocation];
            return YES;
        }
        
        // Dragging source is the view itself, which is being repositioned in the worksheet
        float topLeftX = draggingLocation.x - view.mouseDownOffsetFromOrigin.x;
        float topLeftY = draggingLocation.y + view.frame.size.height - view.mouseDownOffsetFromOrigin.y;
        NSPoint newTopLeft = NSMakePoint(topLeftX, topLeftY);
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
}

# pragma mark - Layout -
-(void)prepareForReload
{
    while (self.subviews.count) {
        [self.subviews[0] removeFromSuperviewWithoutNeedingDisplay];
    }
}
-(void)updateConstraints
{
    [super updateConstraints];
    [self removeConstraints:self.constraints];
    [self addPageSizeConstraints];
    [self addConstraintsForInsertedItemSubViews];
}
-(void)addConstraintsForInsertedItemSubViews
{
    NSArray * insertedViews = [self sortInserts];
    if (!insertedViews || insertedViews.count == 0) {
        return;
    }
    NSView * firstView = insertedViews[0];
    AMMargins margins = [self.delegate pageMargins];
    CGFloat verticalSpacing = [self.delegate verticalSpacing];
    
    NSDictionary * viewsDictionary = NSDictionaryOfVariableBindings(firstView);
    NSDictionary * metrics = @{@"leftMargin": @(margins.left),
                               @"rightMargin": @(margins.right),
                               @"topMargin": @(margins.top),
                               @"bottomMargin": @(margins.bottom),
                               @"vSpacing": @(verticalSpacing) };
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-leftMargin-[firstView]-(>=rightMargin)-|"
                          options:0
                          metrics:metrics
                          views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-topMargin-[firstView]"
                          options:0
                          metrics:metrics
                          views:viewsDictionary]];
    
    NSView * previousView = firstView;
    for (NSView * currentView in insertedViews) {
        viewsDictionary = NSDictionaryOfVariableBindings(previousView, currentView);
        if (currentView == previousView) {
            // First view has already been positioned
            continue;
        }
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"H:|-leftMargin-[currentView]-(>=rightMargin)-|"
                              options:0
                              metrics:metrics
                              views:viewsDictionary]];
        
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"V:[previousView]-vSpacing-[currentView]"
                              options:0
                              metrics:metrics
                              views:viewsDictionary]];
        previousView = currentView;
    }
    
    // Finally, make the container vertically big enough
    viewsDictionary = NSDictionaryOfVariableBindings(previousView);
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:[previousView]-(>=bottomMargin)-|"
                          options:0
                          metrics:metrics
                          views:viewsDictionary]];

}


-(void)addPageSizeConstraints
{
    // Add minimum width and height constraints to make sure that the sheet is the size of the page
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.pageSize.width]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.pageSize.height]];
}

-(NSSize)pageSize
{
    return [self.delegate pageSizeInPoints];
}

-(NSArray*)sortInserts
{
    NSMutableArray * insertsArray = [self.subviews mutableCopy];
    [insertsArray sortUsingComparator: ^(id obj1, id obj2) {
        
        AMInsertableView * ami1 = obj1;
        AMInsertableView * ami2 = obj2;
        
        // Deal with both objects at same horizontal level
        if (ami1.frame.origin.y == ami2.frame.origin.y) {
            
            if (ami1.frame.origin.x == ami2.frame.origin.x) {
                // obj1 has same left position as obj2
                return (NSComparisonResult)NSOrderedSame;
            }
            if (ami1.frame.origin.x < ami2.frame.origin.x) {
                // obj 1 is to the left of obj2
                return (NSComparisonResult)NSOrderedAscending;
            } else {
                // obj 2 is to the left of obj 1
                return (NSComparisonResult)NSOrderedDescending;
            }
        }
        
        // Not at same level, so just need to worry about their y-ordering
        if (ami1.frame.origin.y < ami2.frame.origin.y) {
            // obj 1 is above obj 2
            return (NSComparisonResult)NSOrderedAscending;
        }
        // since we dealt with the possibility of both being at the same height earlier, the only possibility left is that obj 2 is above obj 1
        return (NSComparisonResult)NSOrderedDescending;
    }];
    
    return insertsArray;
}

# pragma mark - Overrides -

-(BOOL)isFlipped
{
    return YES;
}



@end
