//
//  AMWorksheetController.m
//  Amalie
//
//  Created by Keith Staines on 02/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMWorksheetController.h"
#import "AMWorksheetView.h"
#import "AMInsertables.h"

NSUInteger const kAMDefaultLineSpace = 20;
NSUInteger const kAMDefaultLeftMargin = 36;


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

-(void)addInsertableObject:(AMInsertableObjectView*)object atPosition:(NSPoint)topLeft
{
    
    if (!object) return;
    
    object.uuid = [NSUUID UUID];
    
    // Add the object to our list of inserted objects
    [_insertsArray addObject:object];
    [_insertsDictionary setObject:object forKey:object.uuid];
    object.insertableObjectDelegate = self;
    [object setFrameOrigin:topLeft];
    [self.worksheetView addSubview:object];

    
    // The following line causes a compiler warning. It would be easy to cast the problem away using (id<AMTrayDatasource>) but I haven't done so because I want to fix it more fundamentally. Ideally, the appController outlet should be replaced with an id<AMTrayDatasource> outlet, but when I do this, IB doesn't let me connect the outlet to the app controller, even though the appcontroller does implement the required AMTrayDatasource protocol.
    object.trayDataSource = self.appController;


    // We've added an object, but this object is likely to disturb the placement of other objects, so we should check to see if they need to be repositioned.
    [self.worksheetView setNeedsDisplay:[self layoutInserts]];
    
    // Inserted the view so we need to display it
    [object setNeedsDisplay:YES];
}

-(AMInsertableObjectView*)insertableObjectForKey:(NSString*)uuid
{
    return _insertsDictionary[uuid];
}

/*!
 * Determines whether the layout has changed and repositions views if required.
 * @Returns Returns YES if layout changes have been made, otherwise NO.
 */
-(BOOL)layoutInserts
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
    // Make sure that the view at index is correctly positioned
    AMInsertableObjectView * previouseView = _insertsArray[index];
    previouseView.frameTopLeft = NSMakePoint(kAMDefaultLeftMargin, previouseView.frameTop);
    
    // Now iterate through array from this now correctly positioned view, using the most recently repositioned view as a baseline to establish the positioning of the next view.
    for (NSUInteger i = index + 1; i < [_insertsArray count]; i++) {
        AMInsertableObjectView * adjustedView = _insertsArray[i-1];
        AMInsertableObjectView * nextViewToAdjust = _insertsArray[i];
        NSPoint newTopLeft = NSMakePoint(kAMDefaultLeftMargin, adjustedView.frameBottom - kAMDefaultLineSpace);
        nextViewToAdjust.frameTopLeft = newTopLeft;
    }
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
    [self.worksheetView setNeedsDisplay:[self layoutInserts]];

}

-(void)moveInsertableObject:(AMInsertableObjectView*)object toPosition:(NSPoint)newTopLeft
{
    // object might just be a "shadow" object, a temporary copy created by a drag operation, so we make sure we move the real one by obtaining it from the store
    AMInsertableObjectView * actualObject = [self actualFromPossibleShadow:object];
    
    // Move it
    actualObject.frameLeft = newTopLeft.x;
    actualObject.frameTop = newTopLeft.y;
    [self.worksheetView setNeedsDisplay:[self layoutInserts]];

}

-(AMInsertableObjectView*)actualFromPossibleShadow:(AMInsertableObjectView*)shadow
{
    AMInsertableObjectView * actual = [self insertableObjectForKey:shadow.uuid];
    
    if (actual != shadow) {
        NSLog(@"Warning - a shadow view object was passed to AMWorksheetController");
    }

    return actual;
}

@end

