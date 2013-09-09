//
//  AMWorksheetView.h
//  Amalie
//
//  Created by Keith Staines on 04/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMWorksheetController;
@class AMAppController;

#import <Cocoa/Cocoa.h>
#import "AMTrayDatasource.h"
#import "AMWorksheetViewDelegate.h"


@interface AMWorksheetView : NSView <NSDraggingDestination>

/*!
 * A delegate from which we get all document structure and behaviour of items
 * contained within the document.
 */
@property (weak) IBOutlet id<AMWorksheetViewDelegate> delegate;

/*!
 * The trayDataSource is a delegate that allows us to load tray items into the 
 * tray table.
 */
@property (weak) IBOutlet AMAppController * trayDataSource;

/*!
 Layout all the top level inserts on the worksheet. The inserts are moved inside a CATransaction so that everything appears to smoothly flow into place
 */
-(void)layoutInsertsNow;

@end
