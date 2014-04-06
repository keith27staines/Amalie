//
//  AMAmalieDocument.m
//  Amalie
//
//  Created by Keith Staines on 02/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "QuartzCore/QuartzCore.h"
#import "AMAmalieDocument.h"
#import "AMConstants.h"
#import "AMWorksheetView.h"
#import "AMInsertableView.h"
#import "AMKeyboardsAreaView.h"
#import "KSMWorksheet.h"
#import "KSMMathValue.h"
#import "AMContentView.h"
#import "AMGroupedView.h"
#import "KSMExpression.h"
#import "AMDataStore.h"
#import "AMDInsertedObject.h"
#import "AMToolboxView.h"
#import "AMKeyboardContainerView.h"
#import "AMUserPreferences.h"
#import "AMDataStore.h"
#import "AMDInsertedObject+Methods.h"
#import "AMDocumentSettings.h"
#import "AMDName+Methods.h"
#import "AMDFunctionDef+Methods.h"
#import "AMNameProviderBase.h"
#import "AMArgumentsNameProvider.h"
#import "AMDocumentView.h"
#import "AMFontAttributes.h"
#import "AMPageSetupViewController.h"
#import "AMFontSetupViewController.h"
#import "AMColorSetupViewController.h"
#import "AMMathStyleViewController.h"
#import "AMMeasurement.h"
#import "AMColorSettings.h"
#import "AMFontSettings.h"
#import "AMPageSettings.h"
#import "AMMathStyleSettings.h"

// View controllers for dynamically loaded views
#import "AMInsertableViewController.h"
#import "AMKeyboardsViewController.h"
#import "AMLibraryViewController.h"
#import "BitmaskHelpers.h"

@interface AMAmalieDocument()
{
    __weak NSSplitView          * _enclosingSplitView;
    __weak NSSplitView          * _leftSplitView;
    __weak NSSplitView          * _middleSplitView;
    __weak NSSplitView          * _rightSplitView;
    __weak NSScrollView         * _worksheetScrollView;
    __weak AMDocumentView       * _documentBackgroundView;
    __weak AMWorksheetView      * _worksheetView;
    __weak AMInsertableView     * _selectedView;
    
    NSMutableArray              * _insertableViewArray;
    NSMutableDictionary         * _insertableViewDictionary;
    NSMutableDictionary         * _insertedRecords;
    NSMutableDictionary         * _contentControllers;
    KSMWorksheet                * _mathSheet;
    NSEntityDescription         * _amdInsertedObjectsEntity;
    AMDocumentSettings          * _documentSettings;
    AMPaper                     * _paper;
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

@property AMSidepanelVisibility sidepanelVisibility;

@end

@implementation AMAmalieDocument

#pragma mark - Initializers and setup -

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        self.sharedDataStore.moc = self.managedObjectContext;
        [self setupDataStructures];
    }
    return self;
}
-(void)awakeFromNib
{
    [self notificationCenterRegistrations];

    NSSlider * slider = (NSSlider*)(self.scaleSliderItem.view);
    [slider setMinValue:0.25];
    [slider setMaxValue:4];
    [slider setFloatValue:1];
    [slider setContinuous:YES];
    
    // load major subiews into their containers
    [self addLibraryView];
    [self addInspectorView];
    [self configureToolbar];
    [self loadDocumentIntoView];
}
- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"AMAmalieDocument";
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
-(AMDataStore *)sharedDataStore
{
    return [AMDataStore sharedDataStore];
}
-(void)notificationCenterRegistrations
{
    [self.worksheetScrollView setPostsFrameChangedNotifications:YES];
    
    SEL selector = NSSelectorFromString(@"workheetScrollViewDidMagnify");
    NSNotificationCenter * notifier = [NSNotificationCenter defaultCenter];
    [notifier addObserver:self selector:selector
                     name:NSScrollViewDidEndLiveMagnifyNotification
                   object:self.worksheetScrollView];
    
    [notifier addObserver:self selector:@selector(panelDidChangeHiddenState:) name:kAMNotificationViewDidHide object:self.leftSplitView];
    [notifier addObserver:self selector:@selector(panelDidChangeHiddenState:) name:kAMNotificationViewDidHide object:self.rightSplitView];
    [notifier addObserver:self selector:@selector(panelDidChangeHiddenState:) name:kAMNotificationViewDidUnhide object:self.leftSplitView];
    [notifier addObserver:self selector:@selector(panelDidChangeHiddenState:) name:kAMNotificationViewDidUnhide object:self.rightSplitView];
}
/*! Returns the minimum width of the left sidepane in its uncollapsed state */
-(CGFloat)minimumLeftPaneWidth
{
    return kAMMinWidthLeftSidepanelView;
}
-(CGFloat)nominalLeftPaneWidth
{
    return kAMNominalWidthLeftSidepanelView;
}
/*! Returns the minimum width of the right sidepane in its uncollapsed state */
-(CGFloat)minimumRightPaneWidth
{
    return kAMMinWidthRightSidepanelView;
}
-(CGFloat)nominalRightPaneWidth
{
    return kAMNominalWidthRightSidepanelView;
}
-(CGFloat)minimumWindowFrameWidth
{
    CGFloat minWidth = kAMMinWidthDocumentContainerView;
    if ( !self.leftSplitView.isHidden ) {
        minWidth += 1 + [self minimumLeftPaneWidth];
    }
    if ( !self.rightSplitView.isHidden ) {
        minWidth += 1 + [self minimumRightPaneWidth];
    }
    return minWidth;
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
-(void)loadDocumentIntoView
{
    [self.worksheetView prepareForReload];
    
    [self.undoManager disableUndoRegistration];
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
    [self.managedObjectContext processPendingChanges];
    [self.undoManager enableUndoRegistration];
    [self.worksheetView setNeedsUpdateConstraints:YES];
    [self.worksheetView setNeedsDisplay:YES];
}
-(AMDocumentSettings*)documentSettings
{
    if (!_documentSettings) {
        _documentSettings = [[AMDocumentSettings alloc] init];
    }
    return _documentSettings;
}

#pragma mark - Side panel configuration -
-(void)addLibraryView
{
    // Load the library into its container
    NSView * container = self.libraryContainerView;
    self.library.colorSettings = self.documentSettings.colorSettings;
    NSView * library = self.library.view;
    library.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:library];
    
    // Apply constraints to position the library in its container
    NSDictionary * views = NSDictionaryOfVariableBindings(container, library);
    NSArray * constraints;
    NSDictionary * metrics = @{@"libraryWidth": @(kAMNominalWidthLeftSidepanelView)};
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[library(libraryWidth)]|"
                                                          options:0
                                                          metrics:metrics
                                                            views:views];
    [container addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[library]|"
                                                          options:0
                                                          metrics:metrics
                                                            views:views];
    [container addConstraints:constraints];
    
}
-(void)addInspectorView
{
    NSView * container = self.inspectorContainerView;
    NSDictionary * views = NSDictionaryOfVariableBindings(container);
    NSArray * constraints;
    NSDictionary * metrics = @{@"inspectorWidth": @(kAMNominalWidthRightSidepanelView)};
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[container(inspectorWidth)]|"
                                                          options:0
                                                          metrics:metrics
                                                            views:views];
    // TODO: change this constraint to act on the container's contents and add the constraint to the container. The code here so far is just a placeholder that enforces the right width
    [container.superview addConstraints:constraints];
}
-(void)panelDidChangeHiddenState:(NSNotification*)notification
{
    [self configureToolbar];
}
-(void)configureToolbar
{
    [self setLeftSidepanelToolbarButtonOn:!self.leftSplitView.isHidden];
    [self setRightSidepanelToolbarButtonOn:!self.rightSplitView.isHidden];
}
-(void)showLeftSidePanel:(BOOL)flag
{
    NSWindow * window = self.enclosingSplitView.window;
    NSRect windowFrame = window.frame;
    NSView * leftPane = self.enclosingSplitView.subviews[0];
    NSRect leftFrame = leftPane.frame;
    CGFloat nominalWidth = [self nominalLeftPaneWidth];
    [self setLeftSidepanelToolbarButtonOn:flag];
    if ( flag ) {
        // Resize window and shift origin to accomodate the left pane, taking care not to extend the window to the left or right of the screen boundary
        if (windowFrame.origin.x - nominalWidth > 0) {
            // Room to the left so shift origin left full amount thus leaving the document in its original position
            windowFrame.origin.x -= nominalWidth;
        } else {
            // insufficient room to the left, so we can't make enough room for the sidebar and so the document will move
            windowFrame.origin.x = 0;
        }
        if (windowFrame.size.width + nominalWidth < [NSScreen mainScreen].frame.size.width) {
            // Enough room to the right to maintain the document view's width
            windowFrame.size.width += nominalWidth;
        } else {
            // insufficent room, so prevent the width going larger than the screen, thus forcing the document view to compress a little
            windowFrame.size.width = [NSScreen mainScreen].frame.size.width;
        }
        [self.enclosingSplitView setPosition:nominalWidth ofDividerAtIndex:0];
    } else {
        // Resize window and shift origin to accomodate absent left pane
        windowFrame.origin.x += leftFrame.size.width;
        windowFrame.size.width -= leftFrame.size.width;
        [self.enclosingSplitView setPosition:0 ofDividerAtIndex:0];
    }
    leftPane.hidden = !flag;
    //[self.enclosingSplitView adjustSubviews];
    [window setFrame:windowFrame display:YES];
}
-(void)showRightSidePanel:(BOOL)flag
{
    NSWindow * window = self.enclosingSplitView.window;
    NSRect windowFrame = window.frame;
    NSView * rightPane = self.enclosingSplitView.subviews[2];
    NSRect rightFrame = rightPane.frame;
    CGFloat nominalWidth = [self nominalRightPaneWidth];
    [self setRightSidepanelToolbarButtonOn:flag];
    if ( flag ) {
        // Resize to accomodate the right pane
        if ( NSMaxX(windowFrame) + nominalWidth < [NSScreen mainScreen].frame.size.width) {
            windowFrame.size.width += nominalWidth;
        } else {
            windowFrame.size.width = [NSScreen mainScreen].frame.size.width - windowFrame.origin.x;
        }
        [self.enclosingSplitView setPosition:self.enclosingSplitView.frame.size.width - nominalWidth ofDividerAtIndex:1];
    } else {
        // Resize to accomodate absent right pane
        windowFrame.size.width -= rightFrame.size.width;
        [self.enclosingSplitView setPosition:self.enclosingSplitView.frame.size.width ofDividerAtIndex:1];
    }
    rightPane.hidden = !flag;
    [self.enclosingSplitView adjustSubviews];
    [window setFrame:windowFrame display:YES];
}
-(void)setLeftSidepanelToolbarButtonOn:(BOOL)onState
{
    NSToolbarItem * leftPaneButton = self.toolbarLeftSidePanelButton;
    if (onState) {
        leftPaneButton.image = [[NSBundle mainBundle] imageForResource:kAMImageToolbarLeftSidePanelOpenKey];
        leftPaneButton.toolTip = NSLocalizedString(@"Hide the left sidebar", @"Hide the left sidebar");
    } else {
        leftPaneButton.image = [[NSBundle mainBundle] imageForResource:kAMImageToolbarLeftSidePanelClosedKey];
        leftPaneButton.toolTip = NSLocalizedString(@"Show the left sidebar", @"Show the left sidebar");
    }
}
-(void)setRightSidepanelToolbarButtonOn:(BOOL)onState
{
    NSToolbarItem * rightPaneButton = self.toolbarRightSidePanelButton;
    if (onState) {
        rightPaneButton.image = [[NSBundle mainBundle] imageForResource:kAMImageToolbarRightSidePanelOpenKey];
        rightPaneButton.toolTip = NSLocalizedString(@"Hide the right sidebar", @"Hide the right sidebar");
    } else {
        rightPaneButton.image = [[NSBundle mainBundle] imageForResource:kAMImageToolbarRightSidePanelClosedKey];
        rightPaneButton.toolTip = NSLocalizedString(@"Show the right sidebar", @"Show the right sidebar");
    }
}
- (IBAction)toolbarLeftSidePanelButtonClicked:(NSToolbarItem*)sender {
    [self showLeftSidePanel:self.leftSplitView.isHidden];
}
- (IBAction)toolbarRightSidePanelButtonClicked:(NSToolbarItem*)sender {
    [self showRightSidePanel:self.rightSplitView.isHidden];
}

#pragma mark - AMWorksheetViewDelegate -
-(NSSize)pageSizeInPoints
{
    AMDocumentSettings * documentSettings = self.documentSettings;
    AMPaper * paper = documentSettings.paper;
    NSSize size = documentSettings.paper.paperSize;
    if (paper.paperOrientation == AMPaperOrientationLandscape) {
        size = NSMakeSize(size.height, size.width);
    }
    size = [AMMeasurement convertSize:size fromUnits:paper.paperMeasurementUnits toUnits:AMMeasurementUnitsPoints];
    return size;
}
-(AMMargins)pageMargins
{
    return [self.documentSettings.paper marginsInUnits:AMMeasurementUnitsPoints];
}
-(CGFloat)verticalSpacing
{
    AMFontAttributes * fontAttributes = [self fontAttributesForType:AMFontTypeAlgebra];
    NSFont * font = fontAttributes.font;
    CGFloat lineSpacing = font.ascender - font.descender + font.leading;
    return lineSpacing;
}
-(void)workheetView:(AMWorksheetView*)worksheet wantsViewInserted:(AMInsertableView*)insertableView withOrigin:(NSPoint)origin
{
    self.worksheetView= worksheet;
    NSAssert(insertableView, @"Cannot insert a nill view.");
    if (!insertableView) return;
    
    [insertableView setFrameOrigin:origin];
    [self addInsertableView:insertableView];
    
}
-(void)workheetView:(AMWorksheetView*)worksheet wantsViewRemoved:(AMInsertableView*)insertableView
{
    self.worksheetView = worksheet;
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
    [self.worksheetView setNeedsUpdateConstraints:YES];
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
    [self.worksheetView setNeedsUpdateConstraints:YES];
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
    self.worksheetView = worksheet;
    
    // view will be a "shadow" object, an incomplete copy created by a drag operation, so we make sure we move the real one by obtaining it from the store
    AMInsertableView * actualView = [self actualViewFromPossibleTemporaryCopy:view];
    
    // Move it
    [actualView setFrameTopLeft:topLeft animate:NO];
    [self.worksheetView setNeedsUpdateConstraints:YES];
}

#pragma mark - AMInsertableViewDelegate -

-(id<AMNameProviding>)insertedObjectNameProvider
{
    static id<AMNameProviding> _insertedObjectNameProvider;
    if (!_insertedObjectNameProvider) {
        _insertedObjectNameProvider = [self baseNameProvider];
    }
    return _insertedObjectNameProvider;
}
-(AMContentView *)insertableView:(AMInsertableView *)view requiresContentViewOfType:(AMInsertableType)type
{
    AMDInsertedObject * amdInsertedObject = [AMDInsertedObject amdInsertedObjectForInsertedView:view withNameProvider:self.baseNameProvider];
    AMContentViewController * vc;
    vc = [AMContentViewController contentViewControllerWithAppController:self.appController
                                                                document:self
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
    NSString * message = @"Do you really want to remove %@ from this document?";
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
-(void)insertView:(AMInsertableView*)view withOrigin:(NSPoint)origin
{
    NSAssert(view, @"Cannot insert a nill view.");
    if (!view) return;
    
    // Add the object to our list of inserted objects
    [self.insertableViewArray addObject:view];
    [self.insertableViewDictionary setObject:view forKey:view.groupID];
    view.delegate = self;
    view.libraryDataSource = self.library;
    
    [view setFrameOrigin:origin];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.worksheetView addSubview:view];
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

-(AMInsertableView*)insertableViewForKey:(NSString*)key
{
    return self.insertableViewDictionary[key];
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

#pragma mark - Selection management -

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

#pragma mark - Toolbar actions -
- (IBAction)toolbarPageSetupButtonClicked:(NSButton*)sender
{
    NSPopover * popover = self.pageSetupPopover;
    popover.behavior = NSPopoverBehaviorTransient;
    AMPageSetupViewController * vc = (AMPageSetupViewController*)self.pageSetupPopover.contentViewController;
    vc.paper = self.documentSettings.paper;
    [self.pageSetupPopover showRelativeToRect:sender.bounds ofView:sender preferredEdge:NSMaxYEdge];
    [[self.worksheetView window] makeFirstResponder:nil];
}
- (IBAction)toolbarFontSetupButtonClicked:(NSButton *)sender {
    NSPopover * popover = self.fontSetupPopover;
    popover.behavior = NSPopoverBehaviorTransient;
    AMFontSetupViewController * vc = (AMFontSetupViewController*)self.fontSetupPopover.contentViewController;
    [self.fontSetupPopover showRelativeToRect:sender.bounds ofView:sender preferredEdge:NSMaxYEdge];
    [[self.worksheetView window] makeFirstResponder:nil];
}
- (IBAction)toolbarColorSetupButtonClicked:(NSButton *)sender {
    NSPopover * popover = self.colorSetupPopover;
    popover.behavior = NSPopoverBehaviorTransient;
    AMColorSetupViewController * vc = (AMColorSetupViewController*)self.colorSetupPopover.contentViewController;
    vc.document = self;
    [self.colorSetupPopover showRelativeToRect:sender.bounds ofView:sender preferredEdge:NSMaxYEdge];
    [[self.worksheetView window] makeFirstResponder:nil];
}
- (IBAction)toolbarSetupMathematicalStyleButtonClicked:(NSButton *)sender {
    NSPopover * popover = self.mathStylePopover;
    popover.behavior = NSPopoverBehaviorTransient;
    AMMathStyleViewController * vc = (AMMathStyleViewController*)self.mathStylePopover.contentViewController;
    [self.mathStylePopover showRelativeToRect:sender.bounds ofView:sender preferredEdge:NSMaxYEdge];
    [[self.worksheetView window] makeFirstResponder:nil];
}
#pragma mark - Popover Delegate -
-(void)popoverDidClose:(NSNotification *)notification
{
    if (notification.object == self.pageSetupPopover) {
        AMPageSetupViewController * vc = (AMPageSetupViewController*)self.pageSetupPopover.contentViewController;
        [self savePaperToPersistentStore:vc.paper];
        [self loadDocumentIntoView];
        return;
    }
    if (notification.object == self.fontSetupPopover) {
        //
        return;
    }
    if (notification.object == self.colorSetupPopover) {
        //
        return;
    }
    if (notification.object == self.mathStylePopover) {
        //
        return;
    }
}
-(NSWindow *)detachableWindowForPopover:(NSPopover *)popover
{
    return nil;
}

#pragma mark - NSSplitViewDelegate -

-(BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview
{
    if (splitView == self.enclosingSplitView) {
        if (subview == self.leftSplitView) {
            return YES;
        }
        if (subview == self.middleSplitView) {
            return NO;
        }
        if (subview == self.rightSplitView) {
            return YES;
        }
    }
    return NO;
}
-(BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex
{
    if (splitView == self.enclosingSplitView) {
        return YES;
    }
    return NO;
}

#pragma mark - Misc -
-(void)savePaperToPersistentStore:(AMPaper*)paper
{
    self.documentSettings.paper = paper;
}
-(NSString *)defaultDraftName
{
    return @"Mathsheet";
}

-(AMInsertableView*)actualViewFromPossibleTemporaryCopy:(AMInsertableView*)shadow
{
    return [self insertableViewForKey:shadow.groupID];
}

- (IBAction)toolbarKeyboardButtonClicked:(NSToolbarItem*)sender {
}

-(AMNameProviderBase *)baseNameProvider
{
    AMNameProviderBase * baseProvider = [[AMNameProviderBase alloc] initWithDelegate:self];
    return baseProvider;
}

-(AMArgumentsNameProvider *)argumentsNameProviderWithArguments:(AMDArgumentList*)argumentList
{
    AMArgumentsNameProvider * provider = [AMArgumentsNameProvider nameProviderWithDummyVariables:argumentList delegate:self];
    return provider;
}

# pragma mark - AMNameProviderDelegate
-(AMFontAttributes *)fontAttributesForType:(AMFontType)fontType
{
    return [self.documentSettings.fontSettings fontAttributesForFontType:fontType];
}
-(CGFloat)superscriptingFraction
{
    return [self.documentSettings.mathStyleSettings superscriptingFraction];
}
-(CGFloat)superscriptOffset
{
    return [self.documentSettings.mathStyleSettings superscriptOffset];
}
-(CGFloat)subscriptOffset
{
    return [self.documentSettings.mathStyleSettings subscriptOffset];
}
-(CGFloat)smallestFontSize
{
    return [self.documentSettings.mathStyleSettings smallestFontSize];
}
-(CGFloat)baseFontSize
{
    return [self.documentSettings.fontSettings fontSize];
}
@end
























