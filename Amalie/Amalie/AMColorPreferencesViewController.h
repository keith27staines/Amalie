//
//  AMColorPreferencesViewController.h
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMColorSettings;

#import <Cocoa/Cocoa.h>
#import "AMPreferencesBaseViewController.h"

@interface AMColorPreferencesViewController : AMPreferencesBaseViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSButton *resetToDocumentDefaultsButton;
@property (weak) IBOutlet NSButton *resetToFactoryDefaultsButton;

@property (weak) IBOutlet NSTableView *colorPreferencesTable;

@property (readonly) AMColorSettings * colorSettings;


@end
