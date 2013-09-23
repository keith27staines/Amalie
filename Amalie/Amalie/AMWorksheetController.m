//
//  AMWorksheetController.m
//  Amalie
//
//  Created by Keith Staines on 02/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "QuartzCore/QuartzCore.h"
#import "AMWorksheetController.h"
#import "AMConstants.h"
#import "AMWorksheetView.h"
#import "AMInsertableView.h"
#import "KSMWorksheet.h"
#import "KSMMathValue.h"
#import "AMContentView.h"
#import "AMNameRules.h"
#import "AMInsertableRecord.h"
#import "AMGroupedView.h"
#import "KSMExpression.h"
#import "AMInsertableRecord.h"

@interface AMWorksheetController()
{
    NSMutableArray      * _insertableViewArray;
    NSMutableDictionary * _insertableViewDictionary;
    NSMutableDictionary * _insertedRecords;
    NSMutableDictionary * _contentControllers;
    KSMWorksheet        * _mathSheet;
    AMNameRules         * _nameRules;
}

/*!
 * A dictionary of the AMContentViewControllers. Each content controller manages the content view of an AMInsertedView.
 */
@property (strong) NSMutableDictionary    * contentControllers;

/*! insertsRecords is the array of all AMInsertableRecord objects the make up the document */
@property (readonly) NSMutableDictionary  * insertableRecords;

/*! insertableViewArray is the array of all AMInsertableView objects that are currently held in the document. The same data is also held in insertableViewDictionary */
@property (readonly) NSMutableArray * insertableViewArray;

/*! insertableViewDictionary is the dictionary of all AMInsertableView objects that are currently held in the document. The same data is also held in insertableViewArray */
@property (readonly) NSMutableDictionary * insertableViewDictionary;
@end

@implementation AMWorksheetController

#pragma mark - Initializers and setup -

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        _insertableViewArray        = [NSMutableArray array];
        _insertableRecords          = [NSMutableDictionary dictionary];
        _insertableViewDictionary   = [NSMutableDictionary dictionary];
        _contentControllers         = [NSMutableDictionary dictionary];
        _mathSheet                  = [[KSMWorksheet alloc] init];
    }
    return self;
}

-(void)awakeFromNib
{
    SEL selector = NSSelectorFromString(@"workheetScrollViewDidMagnify");
    NSNotificationCenter * notifier = [NSNotificationCenter defaultCenter];
    [notifier addObserver:self selector:selector
                     name:NSScrollViewDidEndLiveMagnifyNotification
                   object:self.worksheetScrollView];
    

    NSSlider * slider = (NSSlider*)(self.scaleSliderItem.view);
    [slider setMinValue:0.25];
    [slider setMaxValue:4];
    [slider setFloatValue:1];
    [slider setContinuous:YES];
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
    [self.insertableViewArray addObject:view];
    [self.insertableViewDictionary setObject:view forKey:view.groupID];
    view.delegate = self;
    view.trayDataSource = self.trayDataSource;
    
    [view setFrameOrigin:origin];
    [self.worksheetView addSubview:view];
    
    // we will need to layout the worksheet again, but doing so directly somehow blocks the animations so we schedule the layout to occur a short time later.
    [self scheduleLayout];
}

-(AMInsertableRecord*)insertableRecordForGroupView:(AMInsertableView*)view
{
    AMInsertableRecord * record = self.insertableRecords[view.groupID];
    if (!record) {
        record = [[AMInsertableRecord alloc] initWithName:nil
                                                nameRules:self.nameRules
                                                     uuid:view.groupID
                                                     type:view.insertableType];
        
        [self.insertableRecords setObject:record forKey:view.groupID];
    } else {
        NSLog(@"Called unexpectedly");
    }

    return record;
}

-(void)workheetView:(AMWorksheetView*)worksheet wantsViewRemoved:(AMInsertableView*)insertableView
{
    [self deleteInsertableView:insertableView];
}

/*!
 deleteInsertableView: first delete the data content (by calling deleteContentForGroupID) and then removes the frame view (which is just the gui container for the content) from the worksheet's subview collection.
 */
-(void)deleteInsertableView:(AMInsertableView*)insertableView
{
    // First we delete the content, then the frame around the content
    NSString * groupID = insertableView.groupID;
    [self deleteContentForGroupID:groupID];
    [self.insertableViewArray removeObject:insertableView];
    [self.insertableViewDictionary removeObjectForKey:groupID];
    insertableView.delegate = nil;
    [insertableView removeFromSuperview];
    [self scheduleLayout];
}

/*!
 deleteContentForGroupID: deletes the data content in two steps: first, the content controller is told to delete the in-memory data, then the AMInsertableRecord is told to delete the corresponding data from the permanent store.  
 */
-(void)deleteContentForGroupID:(NSString*)groupID
{
    // Pass through to the view controller to delete the content
    AMContentViewController * vc = self.contentControllers[groupID];
    [vc deleteContent];
    [self.contentControllers removeObjectForKey:groupID];
    
    AMInsertableRecord * record = self.insertableRecords[groupID];
    [record deleteFromStore];
    [self.insertableRecords removeObjectForKey:groupID];
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
    vc = [AMContentViewController contentViewControllerWithAppController:self.appController
                                                     worksheetController:self
                                                                 content:type
                                                         groupParentView:view
                                                                  record:record];
    
    [self.contentControllers setObject:vc forKey:vc.groupID];
    return (AMContentView*)vc.view;
}

-(void)insertableViewWantsRemoval:(AMInsertableView*)view
{
    AMWorksheetView * worksheetView = (AMWorksheetView *)view.superview;
    [self workheetView:worksheetView wantsViewRemoved:view];
}

#pragma mark - Layout -

/*!
 Use this method to layout. Performing the layout synchronously somehow blocks the animations, but this method works fine because the layout is scheduled to occur only after a timer fires (very short delay).
 */
-(void)scheduleLayout
{
    
    // single-shot timer, will self-invalidate (and remove itself from runloop) after first fire.
    [NSTimer scheduledTimerWithTimeInterval:0.001
                                     target:self
                                   selector:NSSelectorFromString(@"layoutInsertsNow")
                                   userInfo:nil
                                    repeats:NO];
}

-(AMInsertableView*)insertableViewForKey:(NSString*)uuid
{
    return self.insertableViewDictionary[uuid];
}

/*!
 Lay out the inserts now
 */
-(void)layoutInsertsNow
{
    // Just pass through to the worksheet view's implementation
    [self.worksheetView layoutInsertsNow];
}

-(void)contentViewController:(AMContentViewController*)cvController isResizingContentTo:(NSSize)targetSize usingAnimationTransaction:(BOOL)usingTransaction
{
    [self layoutInsertsNow];
}

#pragma - KSM maths library -

-(KSMWorksheet*)mathSheet
{
    if (!_mathSheet) {
        _mathSheet = [[KSMWorksheet alloc] init];
    }
    return _mathSheet;
}

#pragma mark - Magnification -

-(void)workheetScrollViewDidMagnify
{
    NSSlider * slider = (NSSlider*)(self.scaleSliderItem.view);
    slider.floatValue = self.worksheetScrollView.magnification;
}

- (IBAction)scaleSliderMoved:(NSSlider *)slider {
    CGFloat requiredMagnification = slider.floatValue;
    [self.worksheetScrollView setMagnification:requiredMagnification];
}

#pragma mark - Misc -

-(AMNameRules*)nameRules
{
    if (!_nameRules) {
        _nameRules = [[AMNameRules alloc] init];
    }
    return _nameRules;
}

-(AMInsertableView*)actualViewFromPossibleTemporaryCopy:(AMInsertableView*)shadow
{
    return [self insertableViewForKey:shadow.groupID];
}


@end

