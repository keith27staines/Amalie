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
#import "AMKeyboardsAreaView.h"
#import "AMInsertableViewController.h"
#import "KSMWorksheet.h"
#import "KSMMathValue.h"
#import "AMContentView.h"
#import "AMNameRules.h"
#import "AMGroupedView.h"
#import "KSMExpression.h"
#import "AMDataStore.h"
#import "AMDInsertedObject.h"
#import "AMToolboxView.h"
#import "AMKeyboardsViewController.h"
#import "AMKeyboardContainerView.h"
#import "AMPreferences.h"
#import "AMDataStore.h"
#import "AMDInsertedObject+Methods.h"
#import "AMDName+Methods.h"
#import "AMDFunctionDef+Methods.h"

@interface AMWorksheetController()
{
    BOOL                  _showKeyboardArea;
    BOOL                  _showObjectsPanel;
    BOOL                  _layoutIsScheduled;
    NSMutableArray      * _insertableViewArray;
    NSMutableDictionary * _insertableViewDictionary;
    NSMutableDictionary * _insertedRecords;
    NSMutableDictionary * _contentControllers;
    KSMWorksheet        * _mathSheet;
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

@property (readonly) AMDataStore * sharedDataStore;
@property (readonly) AMNameRules * sharedNameRules;

@property BOOL showKeyboardArea;
@property BOOL showObjectsPanel;
@end

@implementation AMWorksheetController

#pragma mark - Initializers and setup -

-(AMDataStore *)sharedDataStore
{
    return [AMDataStore sharedDataStore];
}

-(AMNameRules *)sharedNameRules
{
    return [AMNameRules sharedNameRules];
}

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
    [self.worksheetView.window setContentMinSize:NSMakeSize(1024,768)];
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
    self.showKeyboardArea = YES;
    self.showObjectsPanel = YES;
    AMKeyboardContainerView * keypadContainerView = (AMKeyboardContainerView *)[self.keyboardsViewController view];
    [self.keyboardsAreaView addSubview:keypadContainerView];
    [keypadContainerView setNeedsDisplay:YES];
    
    self.sharedDataStore.moc = self.managedObjectContext;
    self.sharedNameRules.moc = self.managedObjectContext;
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
    for (AMDInsertedObject * insertedObject in [AMDInsertedObject fetchInsertedObjectsInDisplayOrder]) {
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
    [self.keyboardsAreaView setNeedsDisplay:YES];
    [self.toolboxView setNeedsDisplay:YES];
    [self.managedObjectContext processPendingChanges];
    [self arrangeSubviews];
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

-(void)workheetView:(AMWorksheetView*)worksheet wantsViewInserted:(AMInsertableView*)insertableView withOrigin:(NSPoint)origin
{
    NSAssert(insertableView, @"Cannot insert a nill view.");
    if (!insertableView) return;
    
    [insertableView setFrameOrigin:origin];
    [self addInsertableView:insertableView];
    
}

-(void)workheetView:(AMWorksheetView*)worksheet wantsViewRemoved:(AMInsertableView*)insertableView
{
    [self deleteInsertableView:insertableView];
}

-(void)addInsertableView:(AMInsertableView*)insertableView
{
    [self.undoManager registerUndoWithTarget:self
                                    selector:NSSelectorFromString(@"deleteInsertableView:")
                                      object:insertableView];
    // Add the object to our list of inserted objects
    [self insertView:insertableView withOrigin:insertableView.frame.origin];
    
    // This will be the selected view now
    [self insertableViewReceivedClick:insertableView];
    
    // we will need to layout the worksheet again, but doing so directly somehow blocks the animations so we schedule the layout to occur a short time later.
    [self scheduleLayout];
}

/*!
 deleteInsertableView: first delete the data content (by calling deleteContentForGroupID) and then removes the frame view (which is just the gui container for the content) from the worksheet's subview collection.
 */
-(void)deleteInsertableView:(AMInsertableView*)insertableView
{
    [self.undoManager registerUndoWithTarget:self
                                    selector:NSSelectorFromString(@"addInsertableView:")
                                      object:insertableView];
    
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
    AMDInsertedObject * amdInsertedObject = [AMDInsertedObject amdInsertedObjectForInsertedView:view];
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

-(void)removeInsertableView:(AMInsertableView*)view
{
    AMWorksheetView * worksheetView = (AMWorksheetView *)view.superview;
    [self workheetView:worksheetView wantsViewRemoved:view];
}

-(void)insertableViewWantsRemoval:(AMInsertableView*)view
{
    NSAlert * alert = nil;
    NSString * name = @"???";
    NSString * title = nil;
    NSString * message = @"Do you really want to remove %@ from this document?";;
    NSString * messageDetail;
    switch (view.insertableType) {
        case AMInsertableTypeConstant:
            title = @"Remove definition?";
            messageDetail = [NSString stringWithFormat:@"the definition of the constant %@",name];
            break;
        case AMInsertableTypeVariable:
            title = @"Remove definition?";
            messageDetail = [NSString stringWithFormat:@"the definition of the variable %@",name];
            break;
        case AMInsertableTypeFunction:
            title = @"Remove definition?";
            messageDetail = [NSString stringWithFormat:@"the definition of the function %@",name];
            break;
        case AMInsertableTypeExpression:
            title = @"Remove expression?";
            messageDetail = [NSString stringWithFormat:@""];
            break;
        default:
            NSAssert(NO, @"Not implemented yet");
            break;
    }

    alert = [NSAlert alertWithMessageText:title
                            defaultButton:@"Remove"
                          alternateButton:@"Cancel"
                              otherButton:nil
                informativeTextWithFormat:message,messageDetail];
    
    [alert beginSheetModalForWindow:self.worksheetView.window
                      modalDelegate:self
                     didEndSelector:@selector(removeAlertEnded:code:context:)
                        contextInfo:(__bridge void *)(view)];
}

-(void)removeAlertEnded:(NSAlert * ) alert code:(NSInteger)choice context:(void*)v
{
    if (choice == NSAlertDefaultReturn) {
        AMInsertableView * view = (__bridge AMInsertableView*)v;
        if (view == self.selectedView) {
            self.selectedView = nil;
            [self.worksheetView.window makeFirstResponder:nil];
        }
        [self removeInsertableView:view];
    }
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
        AMDInsertedObject * amdObject = [AMDInsertedObject fetchInsertedObjectWithGroupID:groupID];
        
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

#pragma mark - AMNamedObjectInfoProvider -
-(NSFont *)baseFontForObjectWithName:(NSString *)name
{
    return [AMPreferences standardFont];
}

-(NSAttributedString *)attributedStringForObjectWithName:(NSString *)name
{
    return nil;
}

-(KSMValueType)mathTypeForForObjectWithName:(NSString *)name
{
    AMDInsertedObject * insertedObject = [[AMDataStore sharedDataStore] insertedObjectWithName:name];
    
    if (!insertedObject) {
        // everything not specifically defined is assumed to be of type double
        return KSMValueDouble;
    }
    
    switch ((AMInsertableType)insertedObject.insertType) {
        case AMInsertableTypeConstant:
        case AMInsertableTypeVariable:
        case AMInsertableTypeFunction:
        {
            AMDFunctionDef * fnDef = (AMDFunctionDef*)insertedObject;
            return (KSMValueType)fnDef.returnType.integerValue;
            break;
        }
        case AMInsertableTypeVector:
            return KSMValueVector;
        case AMInsertableTypeMatrix:
            return KSMValueMatrix;
        default:
            return KSMValueDouble;
    }
}

-(BOOL)isKnownObjectName:(NSString *)name
{
    return FALSE;
}

#pragma mark - Misc -

-(NSString *)defaultDraftName
{
    return @"Mathsheet";
}

-(AMInsertableView*)actualViewFromPossibleTemporaryCopy:(AMInsertableView*)shadow
{
    return [self insertableViewForKey:shadow.groupID];
}

-(void)toggleSymbolsPanel:(NSToolbarItem*)sender
{
    self.showKeyboardArea = !self.showKeyboardArea;
    if (_showKeyboardArea) {
        sender.label = @"Hide";
    } else {
        sender.label = @"Show";
    }
}

-(void)toggleObjectsPanel:(NSToolbarItem*)sender
{
    self.showObjectsPanel = !self.showObjectsPanel;
    if (_showObjectsPanel) {
        sender.label = @"Hide";
    } else {
        sender.label = @"Show";
    }
}

-(BOOL)showKeyboardArea
{
    return _showKeyboardArea;
}

-(void)setShowKeyboardArea:(BOOL)showSymbolsPanel
{
    if (showSymbolsPanel == _showKeyboardArea) return;
    _showKeyboardArea = showSymbolsPanel;
    if (_showKeyboardArea) {
        // Was invisible, now visible.
        [CATransaction begin];
        [[self.worksheetScrollView animator] setFrame:[self frameForWorksheetScrollView]];
        [[self.keyboardsAreaView animator] setFrameOrigin:NSMakePoint(0, 0)];
        [CATransaction commit];
    } else {
        // was visible, now to be invisible
        [CATransaction begin];
        [[self.worksheetScrollView animator] setFrame:[self frameForWorksheetScrollView]];
        [[self.keyboardsAreaView animator] setFrameOrigin:[self offWindowOriginForKeyboardAreaView]];
        [CATransaction commit];
    }
}

-(BOOL)showObjectsPanel
{
    return _showObjectsPanel;
}

-(void)setShowObjectsPanel:(BOOL)showObjectsPanel
{
    if (showObjectsPanel == _showObjectsPanel) return;
    _showObjectsPanel = showObjectsPanel;
    
    NSRect worksheetScrollViewRect = [self frameForWorksheetScrollView];
    NSRect toolboxRect = self.toolboxView.frame;
    NSRect symbolsRect = self.keyboardsAreaView.frame;
    
    if (_showObjectsPanel) {
        // Was invisible, now visible.
        [CATransaction begin];
        
        [[self.worksheetScrollView animator] setFrame:worksheetScrollViewRect];
        
        toolboxRect.origin.x = [self offWindowOriginForToolboxView].x - toolboxRect.size.width;
        toolboxRect.size.height = self.toolboxView.superview.frame.size.height;
        [[self.toolboxView animator] setFrame:toolboxRect];
        
        if (self.showObjectsPanel) {
            symbolsRect.size.width = self.keyboardsAreaView.superview.frame.size.width - toolboxRect.size.width;
        } else {
            symbolsRect.size.width = self.keyboardsAreaView.superview.frame.size.width;
        }
        [[self.keyboardsAreaView animator] setFrame:symbolsRect];
        
        [CATransaction commit];

    } else {
        // was visible, now to be invisible
        [CATransaction begin];
        [[self.worksheetScrollView animator] setFrame:[self frameForWorksheetScrollView]];
        [[self.toolboxView animator] setFrameOrigin:[self offWindowOriginForToolboxView]];
        symbolsRect.size.width = worksheetScrollViewRect.size.width;
        [[self.keyboardsAreaView animator] setFrame:symbolsRect];
        [CATransaction commit];
    }
}

-(void)windowDidResize:(NSNotification*)notification
{
    [self arrangeSubviews];
}

-(void)arrangeSubviews
{
    // First, calculate and set the frame for the worksheet scrollview, taking into account the visibility of both the toolbox and the symbols views...
    NSRect worksheetScrollRect = [self frameForWorksheetScrollView];
    [self.worksheetScrollView setFrame:worksheetScrollRect];
    
    // Position and size the symbols view. First, the size. The height is fixed, but the width must be adjusted to match the width of the worksheet scroll view...
    NSRect keyboardAreaRect = self.keyboardsAreaView.frame;
    keyboardAreaRect.size.width = self.worksheetScrollView.frame.size.width;
    
    // Now the position of the symbols view...
    if (self.showKeyboardArea) {
        // The symbols view is visible, and its origin is bottom left
        keyboardAreaRect.origin.y = 0.0;
    } else {
        // The symbols view is invisible, so we position it just offscreen, ready to slide back into place
        keyboardAreaRect.origin = [self offWindowOriginForKeyboardAreaView];
    }
    
    // size and position the toolbox. First the size. The width is fixed, but the height must be adjusted to match the height of the superview
    NSRect toolboxRect = self.toolboxView.frame;
    toolboxRect.size.height = self.toolboxView.superview.frame.size.height;
    
    // Now the position of the toolbox...
    if (self.showObjectsPanel) {
        // Toolbox is visible, its top right is coincident with the top right of its superview
        toolboxRect.origin.x = [self offWindowOriginForToolboxView].x - toolboxRect.size.width;
    } else {
        // Toolbox is invisible, so we place it just offscreen ready to slide back into place if made visible again.
        toolboxRect.origin.x = [self offWindowOriginForToolboxView].x;
    }
    [self.keyboardsAreaView setFrame:keyboardAreaRect];
    
    [self.toolboxView setFrame:toolboxRect];
    [self.keyboardsAreaView setNeedsDisplay:YES];
    [self.toolboxView setNeedsDisplay:YES];
}

-(NSPoint)offWindowOriginForToolboxView
{
    NSRect rect = self.toolboxView.superview.bounds;
    return NSMakePoint(rect.origin.x+rect.size.width, 0);
}

-(NSRect)frameForWorksheetScrollView
{
    NSSize size = self.worksheetScrollView.frame.size;
    NSPoint origin = self.worksheetScrollView.frame.origin;
    NSSize superSize = self.worksheetScrollView.superview.bounds.size;
    NSSize keyboardArea = self.keyboardsAreaView.frame.size;
    NSSize toolboxSize = self.toolboxView.frame.size;
    if (self.showKeyboardArea) {
        size.height = superSize.height - keyboardArea.height;
        origin.y = keyboardArea.height;
    } else {
        size.height = superSize.height;
        origin.y = 0.0;
    }
    if (self.showObjectsPanel) {
        size.width = superSize.width - toolboxSize.width;
    } else {
        size.width = superSize.width;
        
    }
    return NSMakeRect(origin.x, origin.y, size.width, size.height);
}

-(NSPoint)offWindowOriginForKeyboardAreaView
{
    NSRect superviewBounds = self.worksheetScrollView.superview.bounds;
    NSPoint origin = superviewBounds.origin;
    origin.y = origin.y - self.keyboardsAreaView.frame.size.height;
    return origin;
}

@end
























