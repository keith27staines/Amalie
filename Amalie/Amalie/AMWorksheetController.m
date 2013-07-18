//
//  AMWorksheetController.m
//  Amalie
//
//  Created by Keith Staines on 02/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@import QuartzCore;

#import "AMWorksheetController.h"
#import "AMWorksheetView.h"
#import "AMInsertables.h"

NSUInteger const kAMDefaultLineSpace = 20;
NSUInteger const kAMDefaultLeftMargin = 36;
NSUInteger const kAMDefaultTopMargin = 36;


@interface AMWorksheetController()
{
    NSMutableArray * _insertsArray;
    NSMutableDictionary * _insertsDictionary;
}

@end

@implementation AMWorksheetController

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        _insertsArray = [NSMutableArray array];
        _insertsDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)awakeFromNib
{
    ;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"AMWorksheetController";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

#pragma mark - AMInsertableObjectViewDelegate -

-(void)addInsertableObject:(AMInsertableObjectView*)view atPosition:(NSPoint)frameOrigin
{
    
    if (!view) return;
    
    view.uuid = [NSUUID UUID];
    
    // Add the object to our list of inserted objects
    [_insertsArray addObject:view];
    [_insertsDictionary setObject:view forKey:view.uuid];
    view.insertableObjectDelegate = self;
    [self.worksheetView addSubview:view];
    [view setFrameOrigin:frameOrigin];
    
    // The following line causes a compiler warning. It would be easy to cast the problem away using (id<AMTrayDatasource>) but I haven't done so because I want to fix it more fundamentally. Ideally, the appController outlet should be replaced with an id<AMTrayDatasource> outlet, but when I do this, IB doesn't let me connect the outlet to the app controller, even though the appcontroller does implement the required AMTrayDatasource protocol.
    view.trayDataSource = self.appController;
    [self scheduleLayout];

}

-(void)scheduleLayout
{
    [NSTimer scheduledTimerWithTimeInterval:0.001
                                     target:self
                                   selector:NSSelectorFromString(@"layoutInsertsAfterTimer:")
                                   userInfo:nil
                                    repeats:NO];
}

-(AMInsertableObjectView*)insertableObjectForKey:(NSString*)uuid
{
    return _insertsDictionary[uuid];
}

/*!
 * Determines whether the layout has changed and repositions views if required.
 * @Returns Returns YES if layout changes have been made, otherwise NO.
 */
-(BOOL)layoutInsertsAfterTimer:(NSTimer*)timer
{
    BOOL layoutChanged = YES;  // !!!!!! this wasn't working so good
    
    // Make a copy of the old array so we can check for differences
    NSArray * old = [_insertsArray copy];
    
    // Sort the array
    [self sortInserts];
    
    NSInteger layoutRequiredFromIndex = -1;
    for (NSUInteger i = 0; i < [_insertsArray count]; i++) {
        if (old[i] != _insertsArray[i]) {
            // mismatch - this is where the insert starts to affect layout;
            layoutRequiredFromIndex = i;
            layoutChanged = YES;
        }
    }
    
    // layout the affected objects
//    if (layoutRequiredFromIndex >= 0)
    layoutRequiredFromIndex = 0;
    [self layoutInsertsFromIndex:layoutRequiredFromIndex];
    
    return layoutChanged;
}

-(void)layoutInsertsFromIndex:(NSUInteger)index
{
    [CATransaction begin];
    float firstTop = self.worksheetView.frame.size.height - kAMDefaultTopMargin;
    NSPoint newTopLeft = NSMakePoint(kAMDefaultLeftMargin, firstTop);
 
    for (AMInsertableConstantView * view in _insertsArray) {
        [view setFrameTopLeft:newTopLeft animate:YES];
        newTopLeft = NSMakePoint(newTopLeft.x, newTopLeft.y - view.frameHeight - kAMDefaultLineSpace);
    }
    [CATransaction commit];
}

-(void)sortInserts
{
    [_insertsArray sortUsingComparator: ^(id obj1, id obj2) {
        
        AMInsertableObjectView * ami1 = obj1;
        AMInsertableObjectView * ami2 = obj2;
        
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
}

-(void)removeInsertableObject:(AMInsertableObjectView*)object
{
    [_insertsArray removeObject:object];
    [_insertsDictionary removeObjectForKey:object.uuid];
    object.insertableObjectDelegate = nil;
    [object removeFromSuperview];
    [self scheduleLayout];

}

-(void)moveInsertableObject:(AMInsertableObjectView*)object toPosition:(NSPoint)newTopLeft
{
    // object might just be a "shadow" object, a temporary copy created by a drag operation, so we make sure we move the real one by obtaining it from the store
    AMInsertableObjectView * actualObject = [self actualFromPossibleShadow:object];
    
    // Move it
    [actualObject setFrameTopLeft:newTopLeft animate:NO];
    [self scheduleLayout];
}

-(AMInsertableObjectView*)actualFromPossibleShadow:(AMInsertableObjectView*)shadow
{
    AMInsertableObjectView * actual = [self insertableObjectForKey:shadow.uuid];
    
    if (actual != shadow) {
        NSLog(@"Warning - a shadow view object was passed to AMWorksheetController");
    }

    return actual;
}

-(void)draggingDidStart
{
    [self.worksheetView pushCursor:([NSCursor closedHandCursor])];
}
-(void)draggingDidEnd;
{
    [self.worksheetView popCursor];
}
@end

