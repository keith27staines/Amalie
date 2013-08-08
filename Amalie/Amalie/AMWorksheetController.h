//
//  AMWorksheetController.h
//  Amalie
//
//  Created by Keith Staines on 02/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMWorksheetView;
@class AMNameRules;

#import <Cocoa/Cocoa.h>
#import "AMWorksheetViewDelegate.h"
#import "AMTrayDatasource.h"
#import "AMInsertableViewDelegate.h"
#import "AMInsertableViewDataSource.h"

@interface AMWorksheetController : NSPersistentDocument
<AMWorksheetViewDelegate,
 AMInsertableViewDelegate> 

/*!
 Our worksheet view IS the document view we are controlling.
 */
@property (weak) IBOutlet AMWorksheetView * worksheetView;

/*!
 WARNING! We need this trayDataSource reference to pass on to subviews that we programmatically introduce onto the worksheet. Make sure this IBOutlet is connected in IB. Usually, the appController will be the primary tray datasource, so in IB, connect the appController to it.
 */
@property (weak) IBOutlet id<AMTrayDatasource> trayDataSource;


@property (strong, readonly) AMNameRules * nameRules;

@end
