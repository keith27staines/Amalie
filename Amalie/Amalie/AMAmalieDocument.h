//
//  AMAmalieDocument.h
//  Amalie
//
//  Created by Keith Staines on 02/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMPersistentDocumentSettings;
@class AMWorksheetView;
@class AMAppController;
@class KSMWorksheet;
@class AMKeyboardsAreaView;

@class AMKeyboardsViewController;
@class AMDocumentView;
@class AMLibraryViewController;
@class AMPersistedObjectNameProvider;
@class AMPersistedObjectWithArgumentsNameProvider;
@class AMDArgumentList;

#import <Cocoa/Cocoa.h>
#import "AMWorksheetViewDelegate.h"
#import "AMLibraryDataSource.h"
#import "AMInsertableViewDelegate.h"
#import "AMInsertableViewDataSource.h"
#import "AMNameProviderDelegate.h"

@interface AMAmalieDocument : NSPersistentDocument <
AMWorksheetViewDelegate,
AMInsertableViewDelegate,
AMNameProviderDelegate,
NSSplitViewDelegate,
NSPopoverDelegate>


#pragma mark -Toolbar outlets and actions-
@property (weak) IBOutlet NSToolbarItem * toolbarLeftSidePanelButton;
@property (weak) IBOutlet NSToolbarItem * toolbarRightSidePanelButton;
@property (weak) IBOutlet NSToolbarItem * toolbarKeyboardButton;

- (IBAction)toolbarLeftSidePanelButtonClicked:(NSToolbarItem*)sender;
- (IBAction)toolbarRightSidePanelButtonClicked:(NSToolbarItem*)sender;
- (IBAction)toolbarKeyboardButtonClicked:(NSToolbarItem*)sender;
- (IBAction)toolbarPageSetupButtonClicked:(NSButton*)sender;
- (IBAction)toolbarFontSetupButtonClicked:(NSButton *)sender;

- (IBAction)toolbarColorSetupButtonClicked:(NSButton *)sender;
- (IBAction)toolbarSetupMathematicalStyleButtonClicked:(NSButton *)sender;

#pragma mark - Outlets for main subviews of document window -

@property (weak) IBOutlet NSSplitView *enclosingSplitView;

@property (weak) IBOutlet NSSplitView *leftSplitView;

@property (weak) IBOutlet NSSplitView *middleSplitView;

@property (weak) IBOutlet NSSplitView *rightSplitView;

@property (weak) IBOutlet NSScrollView *worksheetScrollView;

@property (weak) IBOutlet NSView * libraryContainerView;

@property (weak) IBOutlet NSView * inspectorContainerView;

@property (weak) IBOutlet AMDocumentView *documentBackgroundView;

@property (weak) IBOutlet AMWorksheetView * worksheetView;

@property (weak) IBOutlet AMLibraryViewController * library;

@property (weak) AMInsertableView * selectedView;

@property (weak) IBOutlet NSToolbarItem * scaleSliderItem;

- (IBAction)scaleSliderMoved:(NSSlider *)scaleSlider;

# pragma mark - View Controllers for subviews -
@property (strong) IBOutlet AMKeyboardsViewController *keyboardsViewController;

@property (weak) IBOutlet NSPopover *pageSetupPopover;

@property (weak) IBOutlet NSPopover *fontSetupPopover;

@property (weak) IBOutlet NSPopover * colorSetupPopover;

@property (weak) IBOutlet NSPopover * mathStylePopover;

# pragma mark - Uncatagorized -
/*!
 mathSheet performs math operations for this worksheet controller
 */
@property (strong, readonly) KSMWorksheet * mathSheet;

/*!
 appController is required by various members of the receiver
 */
@property (weak) IBOutlet AMAppController * appController;

-(AMPersistedObjectNameProvider*)persistentNameProvider;
-(AMPersistedObjectWithArgumentsNameProvider*)argumentsNameProviderWithArguments:(AMDArgumentList*)argumentList;

@property (readonly) AMPersistentDocumentSettings * documentSettings;

@end
