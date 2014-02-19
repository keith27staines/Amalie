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
#import "AMPreferences.h"
#import "AMDataStore.h"
#import "AMDInsertedObject+Methods.h"
#import "AMDName+Methods.h"
#import "AMDFunctionDef+Methods.h"
#import "AMNameProviderBase.h"
#import "AMDocumentView.h"

// View controllers for dynamically loaded views
#import "AMInsertableViewController.h"
#import "AMKeyboardsViewController.h"
#import "AMLibraryViewController.h"

@interface AMAmalieDocument()
{
    __weak NSSplitView          * _enclosingSplitView;
    __weak NSSplitView          * _leftSplitView;
    __weak NSSplitView          * _middleSplitView;
    __weak NSSplitView          * _rightSplitView;
    __weak NSScrollView         * _worksheetScrollView;
    __weak AMDocumentView      * _documentBackgroundView;
    __weak AMWorksheetView      * _worksheetView;
    __weak AMInsertableView     * _selectedView;
    
    NSMutableArray              * _insertableViewArray;
    NSMutableDictionary         * _insertableViewDictionary;
    NSMutableDictionary         * _insertedRecords;
    NSMutableDictionary         * _contentControllers;
    KSMWorksheet                * _mathSheet;
    NSEntityDescription         * _amdInsertedObjectsEntity;
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

@property (readonly) AMNameProviderBase * nameProvider;

@property AMSidepanelVisibility sidepanelVisibility;

@end

@implementation AMAmalieDocument

#pragma mark - Initializers and setup -

-(AMDataStore *)sharedDataStore
{
    return [AMDataStore sharedDataStore];
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
    self.sharedDataStore.moc = self.managedObjectContext;
    
    // load major subiews into their containers
    
    [self addLibraryView];
    [self configureToolbar];
}
-(void)configureToolbar
{
    [self configureLeftPaneButton];
    [self configureRightPaneButton];
}
-(void)configureLeftPaneButton
{
    NSWindow * window = self.enclosingSplitView.window;
    NSRect windowFrame = self.enclosingSplitView.window.frame;
    NSView * leftPane = self.enclosingSplitView.subviews[0];
    NSRect leftFrame = leftPane.frame;
    CGFloat nominalWidth = self.libraryContainerView.frame.size.width;
    AMSidepanelVisibility sidePanelVisibility = [AMPreferences sidepanelVisibility];
    NSToolbarItem * leftPaneButton = self.toolbarLeftSidePanelButton;
    if (sidePanelVisibility & AMSidepanelsLeftVisible) {
        // Show left pane visible
        leftPaneButton.image = [[NSBundle mainBundle] imageForResource:kAMImageToolbarLeftSidePanelOpenKey];
        leftPaneButton.toolTip = NSLocalizedString(@"Hide the left sidebar", @"Hide the left sidebar");
        windowFrame.size.width += nominalWidth;
        windowFrame.origin.x -= nominalWidth;
        [self.enclosingSplitView setPosition:nominalWidth ofDividerAtIndex:0];
        [window setFrame:windowFrame display:YES];
    
    } else {
        // Hide left pane
        leftPaneButton.image = [[NSBundle mainBundle] imageForResource:kAMImageToolbarLeftSidePanelClosedKey];
                leftPaneButton.toolTip = NSLocalizedString(@"Show the left sidebar", @"Show the left sidebar");
        windowFrame.origin.x += leftFrame.size.width;
        windowFrame.size.width -= leftFrame.size.width;
        [self.enclosingSplitView setPosition:0 ofDividerAtIndex:0];
        [window setFrame:windowFrame display:YES];
    }
}
-(void)configureRightPaneButton
{
    AMSidepanelVisibility sidePanelVisibility = [AMPreferences sidepanelVisibility];
    NSToolbarItem * rightPaneButton = self.toolbarRightSidePanelButton;
    if (sidePanelVisibility & AMSidepanelsRightVisible) {
        rightPaneButton.image = [[NSBundle mainBundle] imageForResource:kAMImageToolbarRightSidePanelOpenKey];
        rightPaneButton.toolTip = NSLocalizedString(@"Hide the right sidebar", @"Hide the right sidebar");
        CGFloat p = self.enclosingSplitView.frame.size.width - 400;
        [self.enclosingSplitView setPosition:p ofDividerAtIndex:1];
    } else {
        rightPaneButton.image = [[NSBundle mainBundle] imageForResource:kAMImageToolbarRightSidePanelClosedKey];
        rightPaneButton.toolTip = NSLocalizedString(@"Show the right sidebar", @"Show the right sidebar");
        CGFloat p = self.enclosingSplitView.frame.size.width;
        [self.enclosingSplitView setPosition:p ofDividerAtIndex:1];
    }
}
- (IBAction)toolbarLeftSidePanelButtonClicked:(id)sender {
    AMSidepanelVisibility sidePanelVisibility = [AMPreferences sidepanelVisibility];
    sidePanelVisibility ^= 1 << AMPanelBitsLeftPaneBit; // Toggles the left pane bit
    [AMPreferences setSidepanelVisibility:sidePanelVisibility];
    [self configureLeftPaneButton];
}
- (IBAction)toolbarRightSidePanelButtonClicked:(id)sender {
    AMSidepanelVisibility sidePanelVisibility = [AMPreferences sidepanelVisibility];
    sidePanelVisibility ^= 1 << AMPanelBitsRightPaneBit;  // Toggles the right pane bit
    [AMPreferences setSidepanelVisibility:sidePanelVisibility];
    [self configureRightPaneButton];
}

-(AMSidepanelVisibility)sidepanelVisibility
{
    return [AMPreferences sidepanelVisibility];
}
-(void)setSidepanelVisibility:(AMSidepanelVisibility)sidepanelVisibility
{
    [AMPreferences setSidepanelVisibility:sidepanelVisibility];
}
-(void)addLibraryView
{
    // Load the library into its container
    NSView * container = self.libraryContainerView;
    NSView * library = self.library.view;
    library.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:library];
    
    // Apply constraints to position the library in its container
    NSDictionary * views = NSDictionaryOfVariableBindings(container, library);
    NSArray * constraints;
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[library]|"
                                                          options:0
                                                          metrics:nil
                                                            views:views];
    [container addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[library]|"
                                                          options:0
                                                          metrics:nil
                                                            views:views];
    [container addConstraints:constraints];

}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"AMAmalieDocument";
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
    [self.worksheetView setNeedsUpdateConstraints:YES];
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
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.worksheetView addSubview:view];
    
}

#pragma mark - AMWorksheetViewDelegate -

-(AMMargins)pageMargins
{
    return [AMPreferences pageMargins];
}
-(CGFloat)verticalSpacing
{
    
    NSFont * font = [AMPreferences standardFont];
    CGFloat lineSpacing = font.ascender - font.descender + font.leading;
    return lineSpacing;
}
-(NSSize)pageSize
{
    return [AMPreferences worksheetPageSize];
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
        _insertedObjectNameProvider = [[AMNameProviderBase alloc] init];
    }
    return _insertedObjectNameProvider;
}

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

#pragma mark - NSSplitViewDelegate -

-(BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview
{
    if (splitView == self.enclosingSplitView) {
        return subview == self.middleSplitView ? NO : YES;
    }
    return NO;
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

- (IBAction)toolbarKeyboardButton:(id)sender {
}

- (IBAction)toolbarKeyboardButtonClicked:(id)sender {
}

@end
























