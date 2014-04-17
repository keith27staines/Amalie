//
//  AMPreferencesBaseViewController.h
//  Amalie
//
//  Created by Keith Staines on 05/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//


@class AMDocumentSettingsBase, AMSettingsSection;

#import <Cocoa/Cocoa.h>
#import "AMConstants.h"

@interface AMPreferencesBaseViewController : NSViewController

@property IBOutlet NSButton * resetButton;
-(IBAction)resetButtonClicked:(NSButton*)sender;

/*! Subclasses must override (default implementation raises exception) */
-(AMSettingsSectionType)sectionType;

/*! Subclasses may override (default implementation does nothing) */
-(void)reloadData;


@property AMSettingsStorageLocationType settingsStorageLocationType;
@property AMDocumentSettingsBase * documentSettings;
@property (readonly) AMSettingsSection * settingsSection;
-(void)saveSettingsSection;
@end
