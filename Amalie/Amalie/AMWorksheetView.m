//
//  AMWorksheetView.m
//  Amalie
//
//  Created by Keith Staines on 04/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMWorksheetView.h"
#import "AMInsertableObjectView.h"

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
    AMInsertableObjectView * ami = [[AMInsertableObjectView alloc] init];
    NSArray * utArray = [ami writableTypesForPasteboard:[NSPasteboard generalPasteboard]];
    [self registerForDraggedTypes:utArray];
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
    NSArray * classes = @[ [AMInsertableObjectView class] ];
    NSArray * objects = [pb readObjectsForClasses:classes options:nil];
    
    AMInsertableObjectView * view = objects[0];
    
    if (view) {
        NSPoint windowPoint = [sender draggingLocation];
        NSPoint viewPoint = [self convertPoint:windowPoint fromView:nil];
        [view setFrameOrigin:viewPoint];
        [self addSubview:view];
        [self setNeedsDisplay:YES];
        return YES;
    }
    
    return NO;
}

-(void)concludeDragOperation:(id<NSDraggingInfo>)sender
{
    // Could improve this by working out the dirty rectangle and calling setNeedsDisplayInRect instead, but this will do for now.
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

@end
