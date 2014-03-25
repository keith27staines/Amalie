//
//  AMLibraryViewController.h
//  Amalie
//
//  Created by Keith Staines on 31/01/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMAppController, AMColorSettings;

#import <Cocoa/Cocoa.h>
#import "AMTrayDatasource.h"

@interface AMLibraryViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, AMTrayDataSource>

@property (copy) NSMutableArray* insertableDefinitions;

/*!
 * We use this outlet to programmatically configure the table that is acting as
 * our insertable object library.
 */
@property (weak) IBOutlet NSTableView *tableView;

/*!
 * This outlet should be assigned in IB. We don't make explicit use of it
 * ourselves, but we need a reference to a tray datasource so that we can pass
 * it on to tray items that we construct for insertion into the view acting as
 * the insertable object library.
 */
@property (weak) IBOutlet AMAppController *appController;

@property AMColorSettings * colorSettings;

@end
