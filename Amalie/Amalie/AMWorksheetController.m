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
@property (strong) NSMutableDictionary    * contentControllers;
@property (strong, readonly) KSMWorksheet * mathSheet;
@property (readonly) NSMutableDictionary  * insertedRecords;
@end

@implementation AMWorksheetController

#pragma mark - Initializers and setup -

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
    [_insertsArray addObject:view];
    [_insertsDictionary setObject:view forKey:view.groupID];
    view.delegate = self;
    view.trayDataSource = self.trayDataSource;
    
    [view setFrameOrigin:origin];
    [self.worksheetView addSubview:view];
    
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
    NSString * groupID = view.groupID;
    // AMInsertableRecord * record = self.insertedRecords[groupID];

    [_insertsArray removeObject:view];
    [_insertsDictionary removeObjectForKey:groupID];
    [_contentControllers removeObjectForKey:groupID];
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
 Use the worksheet view's implementation
 */
-(void)layoutInsertsNow
{
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

