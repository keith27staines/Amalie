//
//  AMLibraryViewController.h
//  Amalie
//
//  Created by Keith Staines on 31/01/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMAppController, AMColorSettings;

#import <Cocoa/Cocoa.h>
#import "AMLibraryDatasource.h"

@interface AMLibraryViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, AMLibraryDataSource>

@property (copy) NSMutableArray* insertableDefinitions;

/*!
 * We use this outlet to programmatically configure the table that is acting as
 * our insertable object library.
 */
@property (weak) IBOutlet NSTableView *tableView;

@property AMColorSettings * colorSettings;

@end
