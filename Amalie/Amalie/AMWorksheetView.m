//
//  AMWorksheetView.m
//  Amalie
//
//  Created by Keith Staines on 04/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMWorksheetView.h"
#import "AMInsertables.h"
#import "AMWorksheetController.h"


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

    // Insertable 2D graphs
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
    
    NSLog(@"%@ - draggingEntered" , [self.class description]);
    
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
    NSLog(@"%@ - draggingEnded" , [self.class description]);

}

-(void)draggingExited:(id<NSDraggingInfo>)sender
{
    NSLog(@"%@ - draggingExited" , [self.class description]);

}

-(BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender
{
    // We are always prepared. Maybe change this later if doing something that can't be interrupted (editing something for example?).
    NSLog(@"%@ - prepareForDragOperation" , [self.class description]);

    return YES;
}

-(BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSLog(@"%@ - performDragOperation" , [self.class description]);
    static NSArray * classes;
    
    if (!classes) {
        classes = @[ [AMInsertableConstantView class],
                     [AMInsertableVariableView class],
                     [AMInsertableExpressionView class],
                     [AMInsertableEquationView class],
                     [AMInsertableVectorView class],
                     [AMInsertableMatrixView class],
                     [AMInsertableGraph2DView class]
                   ];
    }

    // Place dragged object into view hierarchy
    NSPasteboard * pb = [sender draggingPasteboard];
    NSArray * objects = [pb readObjectsForClasses:classes options:nil];
    AMInsertableObjectView * view = objects[0];
    
    if (view) {

        NSPoint draggingLocation = [sender draggingLocation];
        draggingLocation = [self convertPoint:draggingLocation fromView:nil];
        
        // Deal with items coming from the tray (library of insertable objects)
        if ( [[[sender draggingSource] identifier] isEqualToString:kAMTrayDictionaryKey] ) {
            [view setFrameOrigin:draggingLocation];
            [self.delegate addInsertableObject:view atPosition:draggingLocation];
            [self.delegate moveInsertableObject:view toPosition:draggingLocation];
            return YES;
        }
        
        // Dragging source is the view itself, which is being repositioned in the worksheet
        [self.delegate moveInsertableObject:view toPosition:draggingLocation];
        return YES;

    }
    
    return NO;
}

-(void)concludeDragOperation:(id<NSDraggingInfo>)sender
{
    NSLog(@"%@ - prepareForDragOperation" , [self.class description]);
}

-(void)pushCursor:(NSCursor*)cursor
{
    [cursor push];
}
-(void)popCursor
{
    [NSCursor pop];
    [[self window] invalidateCursorRectsForView:self];
}

@end
