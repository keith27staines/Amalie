//
//  AMPreferencesViewControllerBase.h
//  Amalie
//
//  Created by Keith Staines on 05/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//


@class AMDocumentSettingsBase, AMSettingsSection;

#import <Cocoa/Cocoa.h>
#import "AMConstants.h"

@interface AMPreferencesViewControllerBase : NSViewController

@property IBOutlet NSButton * resetButton;
-(IBAction)resetButtonClicked:(NSButton*)sender;

/*! Subclasses must override (default implementation raises exception) */
-(AMSettingsSectionType)sectionType;

/*! Subclasses may override (default implementation does nothing) */
-(void)reloadData;


@property AMSettingsStorageLocationType settingsStorageLocationType;
@property AMDocumentSettingsBase * documentSettings;
@property (readonly) AMSettingsSection * controlledSettingsSection;
/*!
 *  Returns the default settings for the storage location type. Depending in context (as determined from the settingsStorageLocationType property, this can be (essentially hard-coded) factory defaults, user preferences, or the current document's own settings.
 *
 *  @return a settings section configured with the appropriate defaults.
 */
-(AMSettingsSection*)defaultSettings;
-(void)saveSettingsSection;
@end
