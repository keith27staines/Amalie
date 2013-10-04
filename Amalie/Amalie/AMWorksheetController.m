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
#import "AMInsertableViewController.h"
#import "KSMWorksheet.h"
#import "KSMMathValue.h"
#import "AMContentView.h"
#import "AMNameRules.h"
#import "AMDInsertedObject.h"
#import "AMGroupedView.h"
#import "KSMExpression.h"
#import "AMDataStore.h"
#import "AMDInsertedObject.h"

@interface AMWorksheetController()
{
    BOOL                  _layoutIsScheduled;
    NSMutableArray      * _insertableViewArray;
    NSMutableDictionary * _insertableViewDictionary;
    NSMutableDictionary * _insertedRecords;
    NSMutableDictionary * _contentControllers;
    KSMWorksheet        * _mathSheet;
    AMNameRules         * _nameRules;
    AMDataStore         * _dataStore;
    NSEntityDescription * _amdInsertedObjectsEntity;
    AMInsertableView    * _selectedView;
}

/*!
 * A dictionary of the AMContentViewControllers. Each content controller manages the content view of an AMInsertedView.
 */
@property (strong) NSMutableDictionary    * contentControllers;

/*! insertableViewArray is the array of all AMInsertableView objects that are currently held in the document. The same data is also held in insertableViewDictionary */
@property (readonly) NSMutableArray * insertableViewArray;

/*! insertableViewDictionary is the dictionary of all AMInsertableView objects that are currently held in the document. The same data is also held in insertableViewArray */
@property (readonly) NSMutableDictionary * insertableViewDictionary;

@property (readonly) AMDataStore * dataStore;
@end

@implementation AMWorksheetController

#pragma mark - Initializers and setup -

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        [self setupDataStructures];
    }
    return self;
}

-(void)awakeFromNib
{
    
    [self.worksheetScrollView setPostsFrameChangedNotifications:YES];
    
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
    [self setupGUI];
}

-(BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError *__autoreleasing *)error
{
    if ( ![super readFromURL:absoluteURL ofType:typeName error:error] ) return NO;
    
    // Load the document's object model from the datastore
    [self setupDataStructures];
    
    return YES;
}

-(void)revertDocumentToSaved:(id)sender
{
    [super revertDocumentToSaved:sender];
    [self setupDataStructures];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

-(void)setupDataStructures
{
    _dataStore                  = [[AMDataStore alloc] initWithManagedObjectContext:self.managedObjectContext];
    _insertableViewArray        = [NSMutableArray array];
    _insertableViewDictionary   = [NSMutableDictionary dictionary];
    _contentControllers         = [NSMutableDictionary dictionary];
    _mathSheet                  = [[KSMWorksheet alloc] init];
}

-(void)setupGUI
{
    while (self.worksheetView.subviews.count > 0) {
        NSView * view = self.worksheetView.subviews[0];
        [view removeFromSuperviewWithoutNeedingDisplay];
    }
    
    [self.undoManager disableUndoRegistration];
    _layoutIsScheduled = YES; // prevent layout while we are setting up...
    for (AMDInsertedObject * insertedObject in [self.dataStore fetchInsertedObjectsInDisplayOrder]) {
        NSRect frame = NSMakeRect(insertedObject.xPosition.floatValue,
                                  insertedObject.yPosition.floatValue,
                                  insertedObject.width.floatValue,
                                  insertedObject.height.floatValue);
        AMInsertableViewController * vc = [[AMInsertableViewController alloc] init];
        AMInsertableView * insertableView;
        insertableView = (AMInsertableView*)[vc view];
        insertableView.frame = frame;
        insertableView.groupID = insertedObject.groupID;
        insertableView.insertableType = insertedObject.insertType.integerValue;
        
        [self insertView:insertableView withOrigin:insertableView.frame.origin];
    }
    _layoutIsScheduled = NO; // re-enable layout
    [self scheduleLayout];
    [self.worksheetView setNeedsDisplay:YES];
    [self.managedObjectContext processPendingChanges];
    [self.undoManager removeAllActions];
}

-(void)insertView:(AMInsertableView*)view withOrigin:(NSPoint)origin
{
    NSAssert(view, @"Cannot insert a nill view.");
    if (!view) return;
    
    // Add the object to our list of inserted objects
    [self.insertableViewArray addObject:view];
    [self.insertableViewDictionary setObject:view forKey:view.groupID];
    view.delegate = self;
    view.trayDataSource = self.trayDataSource;
    
    [view setFrameOrigin:origin];
    [self.worksheetView addSubview:view];
}

#pragma mark - AMWorksheetViewDelegate -

-(void)workheetView:(AMWorksheetView*)worksheet wantsViewInserted:(AMInsertableView*)view withOrigin:(NSPoint)origin
{
    NSAssert(view, @"Cannot insert a nill view.");
    if (!view) return;
    
    // Add the object to our list of inserted objects
    [self insertView:view withOrigin:origin];
    
    // This will be the selected view now
    [self insertableViewReceivedClick:view];
    
    // we will need to layout the worksheet again, but doing so directly somehow blocks the animations so we schedule the layout to occur a short time later.
    [self scheduleLayout];
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
 deleteContentForGroupID: deletes the data content .
 */
-(void)deleteContentForGroupID:(NSString*)groupID
{
    // Pass through to the view controller to delete the content
    AMContentViewController * vc = self.contentControllers[groupID];
    [vc deleteContent];
    [self.contentControllers removeObjectForKey:groupID];
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
    
    AMDInsertedObject * amdInsertedObject = [self.dataStore amdInsertedObjectForInsertedView:view];
    AMContentViewController * vc;
    vc = [AMContentViewController contentViewControllerWithAppController:self.appController
                                                     worksheetController:self
                                                                 content:type
                                                         groupParentView:view
                                                                  moc:self.managedObjectContext
                                                    amdInsertedObject:amdInsertedObject];
    [self.contentControllers setObject:vc forKey:vc.groupID];
    return (AMContentView*)vc.view;
}

-(void)insertableViewWantsRemoval:(AMInsertableView*)view
{
    AMWorksheetView * worksheetView = (AMWorksheetView *)view.superview;
    [self workheetView:worksheetView wantsViewRemoved:view];
}

-(void)insertableViewReceivedClick:(AMInsertableView*)view
{
    self.selectedView = view;
}

#pragma mark - Layout -

/*!
 Use this method to layout. Performing the layout synchronously somehow blocks the animations, but this method works fine because the layout is scheduled to occur only after a timer fires (very short delay).
 */
-(void)scheduleLayout
{
    if (_layoutIsScheduled) return;
    _layoutIsScheduled = YES;
    // single-shot timer, will self-invalidate (and remove itself from runloop) after first fire.
    [NSTimer scheduledTimerWithTimeInterval:0.001
                                     target:self
                                   selector:NSSelectorFromString(@"layoutInsertsNow")
                                   userInfo:nil
                                    repeats:NO];
}

-(AMInsertableView*)insertableViewForKey:(NSString*)key
{
    return self.insertableViewDictionary[key];
}

/*!
 Lay out the inserts now
 */
-(void)layoutInsertsNow
{
    // Just pass through to the worksheet view's implementation to do the actual move
    [self.worksheetView layoutInsertsNow];
    
    // Need to update the positions in core data too, but care is needed - any assignment to the position and size properties of the inserted object will result in the document being marked as dirty, so to prevent this happening unneccessarily, first test whether the values have in fact changed.
    for (AMInsertableView * view in self.worksheetView.subviews) {
        
        NSString * groupID = view.groupID;
        AMDInsertedObject * amdObject = [self.dataStore fetchInsertedObjectWithGroupID:groupID];
        
        // Assign new values only if values have genuinely changed
        if (![amdObject.xPosition  isEqual: @(view.frame.origin.x)]) {
            amdObject.xPosition = @(view.frame.origin.x);
        }
        
        if (![amdObject.yPosition  isEqual: @(view.frame.origin.y)]) {
            amdObject.yPosition = @(view.frame.origin.y);
        }
        
        if (![amdObject.width  isEqual: @(view.frame.size.width)]) {
            amdObject.width     = @(view.frame.size.width);
        }
        
        if (![amdObject.height  isEqual: @(view.frame.size.height)]) {
            amdObject.height    = @(view.frame.size.height);
        }
    }
    _layoutIsScheduled = NO;
}

-(void)contentViewController:(AMContentViewController*)cvController isResizingContentTo:(NSSize)targetSize usingAnimationTransaction:(BOOL)usingTransaction
{
    [self layoutInsertsNow];
}

- (IBAction)checkEditStatus:(id)sender {
    NSLog(@"Is edited? %d", self.hasUnautosavedChanges);
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

#pragma mark - State management -

-(AMInsertableView *)selectedView
{
    return _selectedView;
}

-(void)setSelectedView:(AMInsertableView *)view
{
    if (_selectedView == view) return;
    _selectedView.viewState = AMInsertViewStateNormal;
    _selectedView = view;
    _selectedView.viewState = AMInsertViewStateSelected;
}

#pragma mark - Misc -

-(NSString *)defaultDraftName
{
    return @"Mathsheet";
}

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

