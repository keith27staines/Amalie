//
//  AMWorksheetView.h
//  Amalie
//
//  Created by Keith Staines on 04/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMAmalieDocument;
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

@property (readonly) NSSize pageSize;

@end
