//
//  AMWorksheetController.m
//  Amalie
//
//  Created by Keith Staines on 02/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@import QuartzCore;

#import "AMWorksheetController.h"
#import "AMConstants.h"
#import "AMWorksheetView.h"
#import "AMInsertableView.h"
#import "KSMWorksheet.h"
#import "AMContentView.h"
#import "AMNameRules.h"
#import "AMInsertableRecord.h"
#import "AMGroupedView.h"

static NSUInteger const kAMDefaultLineSpace   = 20;
static NSUInteger const kAMDefaultLeftMargin  = 36;
static NSUInteger const kAMDefaultTopMargin   = 36;

@interface AMWorksheetController()
{
    NSMutableArray      * _insertsArray;
    NSMutableDictionary * _insertedRecords;
    NSMutableDictionary * _insertsDictionary;
    NSMutableDictionary * _contentControllers;
    KSMWorksheet        * _mathSheet;
    AMNameRules         * _nameRules;
}

/*!
 * view controllers to manage the loading of views for insertable objects
 */
@property (strong) NSMutableDictionary * contentControllers;
@property (strong, readonly) KSMWorksheet * mathSheet;
@property (readonly) NSMutableDictionary * insertedRecords;
@end

@implementation AMWorksheetController

#pragma - Initializers -

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        _insertsArray       = [NSMutableArray array];
        _insertedRecords    = [NSMutableDictionary dictionary];
        _insertsDictionary  = [NSMutableDictionary dictionary];
        _contentControllers = [NSMutableDictionary dictionary];
        _mathSheet          = [[KSMWorksheet alloc] init];
    }
    return self;
}

-(void)awakeFromNib
{
    ;
}

-(AMNameRules*)nameRules
{
    if (!_nameRules) {
        _nameRules = [[AMNameRules alloc] init];
    }
    return _nameRules;
}


- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"AMWorksheet";
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

#pragma mark - AMWorksheetViewDelegate -

-(void)workheetView:(AMWorksheetView*)worksheet wantsViewInserted:(AMInsertableView*)view withOrigin:(NSPoint)origin
{
    if (!view) return;
    
    // Add the object to our list of inserted objects
    [_insertsArray addObject:view];
    [_insertsDictionary setObject:view forKey:view.groupID];
    view.delegate = self;
    view.trayDataSource = self.trayDataSource;
    
    [self.worksheetView addSubview:view];
    [view setFrameOrigin:origin];
    
    // we will need to layout the worksheet again, but doing so directly somehow blocks the animations so we schedule the layout to occur a short time later.
    [self scheduleLayout];
}

-(AMInsertableRecord*)insertableRecordForGroupView:(AMInsertableView*)view
{
    AMInsertableRecord * record;
    record = [[AMInsertableRecord alloc] initWithName:nil
                                            nameRules:self.nameRules
                                                 uuid:view.groupID
                                                 type:view.insertableType
                                            mathSheet:self.mathSheet];

    [self.insertedRecords setObject:record forKey:view.groupID];
    return record;
}

-(void)workheetView:(AMWorksheetView*)worksheet wantsViewRemoved:(AMInsertableView*)view
{
    [_insertsArray removeObject:view];
    [_insertsDictionary removeObjectForKey:view.groupID];
    [_contentControllers removeObjectForKey:view.groupID];
    view.delegate = nil;
    [view removeFromSuperview];
    [self scheduleLayout];
}

-(void)workheetView:(AMWorksheetView*)worksheet wantsViewMoved:(AMInsertableView*)view newTopLeft:(NSPoint)topLeft
{
    // view will be a "shadow" object, an incomplete copy created by a drag operation, so we make sure we move the real one by obtaining it from the store
    AMInsertableView * actualView = [self actualViewFromPossibleTemporaryCopy:view];
    
    // Move it
    [actualView setFrameTopLeft:topLeft animate:NO];
    [self scheduleLayout];
}

#pragma mark - AMInsertableViewDelegate -
-(AMContentView *)insertableView:(AMInsertableView *)view requiresContentViewOfType:(AMInsertableType)type
{
    AMInsertableRecord * record = [self insertableRecordForGroupView:view];

    AMContentViewController * vc;
    vc = [AMContentViewController contentViewControllerWithWorksheet:self
                                                          content:type groupParentView:view
                                                           record:record];
    
    [self.contentControllers setObject:vc forKey:vc.groupID];
    return (AMContentView*)vc.view;
}

#pragma - Layout -

/*!
 Use this method to layout. Performing the layout synchronously somehow blocks the animations, but this method works fine because the layout is scheduled to occur only after a timer fires (very short delay).
 */
-(void)scheduleLayout
{
    
    // single-shot timer, will self-invalidate (and remove from runloop) after first fire.
    [NSTimer scheduledTimerWithTimeInterval:0.001
                                     target:self
                                   selector:NSSelectorFromString(@"layoutInsertsAfterTimer:")
                                   userInfo:nil
                                    repeats:NO];
}

-(AMInsertableView*)insertableViewForKey:(NSString*)uuid
{
    return _insertsDictionary[uuid];
}

/*!
 On receipt of the timer event, this method calls layoutNow:.
 */
-(void)layoutInsertsAfterTimer:(NSTimer*)timer
{
    [self layoutInsertsNow];
}

/*!
 Layout all the top level inserts on the worksheet. The inserts are moved inside a CATransaction so that everything appears to smoothly flow into place
 */
-(void)layoutInsertsNow
{
    [self sortInserts];
    [CATransaction begin];
    float firstTop = self.worksheetView.frame.size.height - kAMDefaultTopMargin;
    NSPoint newTopLeft = NSMakePoint(kAMDefaultLeftMargin, firstTop);
    
    for (AMInsertableView * view in _insertsArray) {
        [view setFrameTopLeft:newTopLeft animate:YES];
        newTopLeft = NSMakePoint(newTopLeft.x, newTopLeft.y - view.frameHeight - kAMDefaultLineSpace);
    }
    [CATransaction commit];
}

-(void)sortInserts
{
    [_insertsArray sortUsingComparator: ^(id obj1, id obj2) {
        
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
}

#pragma - KSM maths library -

-(KSMWorksheet*)mathSheet
{
    if (!_mathSheet) {
        _mathSheet = [[KSMWorksheet alloc] init];
    }
    return _mathSheet;
}


#pragma - Misc -

-(AMInsertableView*)actualViewFromPossibleTemporaryCopy:(AMInsertableView*)shadow
{
    return [self insertableViewForKey:shadow.groupID];
}

@end

