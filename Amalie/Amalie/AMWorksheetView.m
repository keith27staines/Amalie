//
//  AMWorksheetView.m
//  Amalie
//
//  Created by Keith Staines on 04/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMWorksheetView.h"
#import "AMInsertables.h"

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
    AMInsertableObjectView * ami;
    NSArray * typesArray;
    
    // Add pasteboard types for each type of insertable object
    
    // insertable object base class - for testing purposes only really
    ami = [[AMInsertableObjectView alloc] init];
    typesArray = [ami writableTypesForPasteboard:[NSPasteboard generalPasteboard]];
    [allTypes addObjectsFromArray:typesArray];

    // Insertable constants
    ami = [[AMInsertableConstantView alloc] init];
    typesArray = [ami writableTypesForPasteboard:[NSPasteboard generalPasteboard]];
    [allTypes addObjectsFromArray:typesArray];

    // Insertable variables
    ami = [[AMInsertableVariableView alloc] init];
    typesArray = [ami writableTypesForPasteboard:[NSPasteboard generalPasteboard]];
    [allTypes addObjectsFromArray:typesArray];
    
    // Insertable expressions
    ami = [[AMInsertableExpressionView alloc] init];
    typesArray = [ami writableTypesForPasteboard:[NSPasteboard generalPasteboard]];
    [allTypes addObjectsFromArray:typesArray];

    // Insertable Equations
    ami = [[AMInsertableEquationView alloc] init];
    typesArray = [ami writableTypesForPasteboard:[NSPasteboard generalPasteboard]];
    [allTypes addObjectsFromArray:typesArray];

    // Insertable Vectors
    ami = [[AMInsertableVectorView alloc] init];
    typesArray = [ami writableTypesForPasteboard:[NSPasteboard generalPasteboard]];
    [allTypes addObjectsFromArray:typesArray];

    // Insertable Matrix
    ami = [[AMInsertableMatrixView alloc] init];
    typesArray = [ami writableTypesForPasteboard:[NSPasteboard generalPasteboard]];
    [allTypes addObjectsFromArray:typesArray];

    // Insertable expressions
    ami = [[AMInsertableMathematicalSetView alloc] init];
    typesArray = [ami writableTypesForPasteboard:[NSPasteboard generalPasteboard]];
    [allTypes addObjectsFromArray:typesArray];

    // Insertable expressions
    ami = [[AMInsertableGraph2DView alloc] init];
    typesArray = [ami writableTypesForPasteboard:[NSPasteboard generalPasteboard]];
    [allTypes addObjectsFromArray:typesArray];
    
    // register them all in one hit...
    [self registerForDraggedTypes:allTypes];
}

-(void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}

-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    // check type and see if we can accept
    if (![sender draggingSource]) {
        // source of drag is external to application
        return NSDragOperationNone;
    } else {
        // dragging source is us
        return NSDragOperationCopy;
    }
    
    return NSDragOperationNone;
}

-(NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
{
    // modify mouse pointer according to destination, etc
    return NSDragOperationCopy;
}

-(void)draggingEnded:(id<NSDraggingInfo>)sender
{
    // item was dragged out of the view
}

-(void)draggingExited:(id<NSDraggingInfo>)sender
{
    // mouse released
}

-(BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender
{
    // We are always prepared. Maybe change this later if editing something for example.
    return YES;
}

-(BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    // Place dragged object into view hierarchy
    NSPasteboard * pb = [sender draggingPasteboard];
    NSArray * classes = @[ [AMInsertableObjectView class],
                           [AMInsertableConstantView class],
                           [AMInsertableVariableView class],
                           [AMInsertableExpressionView class],
                           [AMInsertableEquationView class],
                           [AMInsertableVectorView class],
                           [AMInsertableMatrixView class],
                           [AMInsertableGraph2DView class] ];
    NSArray * objects = [pb readObjectsForClasses:classes options:nil];
    
    AMInsertableObjectView * view = objects[0];
    
    if (view) {
        view.trayDataSource = self.trayDataSource;
        NSPoint windowPoint = [sender draggingLocation];
        NSPoint viewPoint = [self convertPoint:windowPoint fromView:nil];
        [view setFrameOrigin:viewPoint];
        [self addSubview:view];
        [self setNeedsDisplayInRect:view.frame];
        return YES;
    }
    
    return NO;
}

-(void)concludeDragOperation:(id<NSDraggingInfo>)sender
{

}

@end
