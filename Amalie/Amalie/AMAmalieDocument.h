//
//  AMAmalieDocument.h
//  Amalie
//
//  Created by Keith Staines on 02/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMWorksheetView;
@class AMAppController;
@class KSMWorksheet;
@class AMKeyboardsAreaView;

@class AMKeyboardsViewController;
@class AMDocumentView;
@class AMLibraryViewController;

#import <Cocoa/Cocoa.h>
#import "AMWorksheetViewDelegate.h"
#import "AMTrayDatasource.h"
#import "AMInsertableViewDelegate.h"
#import "AMInsertableViewDataSource.h"
#import "AMNameProviderBase.h"

@interface AMAmalieDocument : NSPersistentDocument
<AMWorksheetViewDelegate,
 AMInsertableViewDelegate, NSSplitViewDelegate>

@property (weak) IBOutlet NSToolbarItem * toolbarLeftSidePanelButton;
@property (weak) IBOutlet NSToolbarItem * toolbarRightSidePanelButton;
@property (weak) IBOutlet NSToolbarItem * toolbarKeyboardButton;

- (IBAction)toolbarLeftSidePanelButtonClicked:(id)sender;
- (IBAction)toolbarRightSidePanelButtonClicked:(id)sender;
- (IBAction)toolbarKeyboardButtonClicked:(id)sender;



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

@property (strong) IBOutlet AMKeyboardsViewController *keyboardsViewController;

/*!
 mathSheet performs math operations for this worksheet controller
 */
@property (strong, readonly) KSMWorksheet * mathSheet;

/*!
 WARNING! We need this trayDataSource reference to pass on to subviews that we programmatically introduce onto the worksheet. Make sure this IBOutlet is connected in IB. Usually, the appController will be the primary tray datasource, so in IB, connect the appController to it.
 */
@property (weak) IBOutlet id<AMTrayDataSource> trayDataSource;

/*!
 appController is required by various members of the receiver
 */
@property (weak) IBOutlet AMAppController * appController;

@end
