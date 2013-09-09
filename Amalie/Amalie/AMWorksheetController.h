//
//  AMWorksheetController.h
//  Amalie
//
//  Created by Keith Staines on 02/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMWorksheetView;
@class AMNameRules;
@class AMAppController;

#import <Cocoa/Cocoa.h>
#import "AMWorksheetViewDelegate.h"
#import "AMTrayDatasource.h"
#import "AMInsertableViewDelegate.h"
#import "AMInsertableViewDataSource.h"

@interface AMWorksheetController : NSPersistentDocument
<AMWorksheetViewDelegate,
 AMInsertableViewDelegate>


@property (weak) IBOutlet NSToolbarItem * scaleSliderItem;

- (IBAction)scaleSliderMoved:(NSSlider *)scaleSlider;

@property (weak) IBOutlet NSScrollView *worksheetScrollView;

/*!
 Our worksheet view IS the document view we are controlling.
 */
@property (weak) IBOutlet AMWorksheetView * worksheetView;

/*!
 WARNING! We need this trayDataSource reference to pass on to subviews that we programmatically introduce onto the worksheet. Make sure this IBOutlet is connected in IB. Usually, the appController will be the primary tray datasource, so in IB, connect the appController to it.
 */
@property (weak) IBOutlet id<AMTrayDatasource> trayDataSource;

/*!
 appController is required by various members of the receiver
 */
@property (weak) IBOutlet AMAppController * appController;

/*!
 nameRules is required by various members of the receiver
 */
@property (strong, readonly) AMNameRules * nameRules;

-(void)contentViewController:(AMContentViewController*)cvController isResizingContentTo:(NSSize)targetSize usingAnimationTransaction:(BOOL)usingTransaction;

@end
