//
//  AMColorPreferencesViewController.h
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMDocumentSettings, AMColorSettings;

#import <Cocoa/Cocoa.h>
#import "AMUserPreferencesBaseViewController.h"

typedef NS_ENUM(NSUInteger, AMColorPreferencesType) {
    AMColorPreferencesTypeFactorySettings,
    AMColorPreferencesTypeUserDefaults,
    AMColorPreferencesTypeDocumentSettings,
};

@interface AMColorPreferencesViewController : AMUserPreferencesBaseViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSButton *resetToDocumentDefaultsButton;
@property (weak) IBOutlet NSButton *resetToFactoryDefaultsButton;

@property (weak) IBOutlet NSTableView *colorPreferencesTable;


@property AMColorPreferencesType colorPreferencesType;

@property (readonly) AMColorSettings * colorSettings;
@property AMDocumentSettings * documentSettings;

@end
