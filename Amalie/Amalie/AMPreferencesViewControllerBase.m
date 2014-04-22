//
//  AMPreferencesViewControllerBase.m
//  Amalie
//
//  Created by Keith Staines on 05/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMPreferencesViewControllerBase.h"
#import "AMDocumentSettingsBase.h"
#import "AMSettingsSection.h"
#import "AMUserPreferences.h"

@interface AMPreferencesViewControllerBase ()
{
    @private
    AMSettingsStorageLocationType _settingsStorageLocationType;
    AMDocumentSettingsBase * _documentSettings;
    @protected
    AMSettingsSection  * _settingsSection;
}

@property AMSettingsSection * controlledSettingsSection;

@end

@implementation AMPreferencesViewControllerBase

-(IBAction)resetButtonClicked:(NSButton *)sender
{
    _settingsSection = [self defaultSettings];
    [self reloadData];
}
-(AMSettingsSection*)defaultSettings
{
    switch (self.settingsStorageLocationType) {
        case AMSettingsStorageLocationTypeFactoryDefaults:
        {
            // We can't reset factory defaults to anything deeper than factory defaults
            return [AMSettingsSection settingsWithFactoryDefaultsOfType:self.sectionType];
        }
        case AMSettingsStorageLocationTypeUserDefaults:
        {
            // Default settings for "new document defaults" are the "factory settings"
            return [AMSettingsSection settingsWithFactoryDefaultsOfType:self.sectionType];
        }
        case AMSettingsStorageLocationTypeCurrentDocument:
        {
            // Default settings for a document are the "new document settings" which are stored in user defaults
            return [AMSettingsSection settingsWithUserDefaultsOfType:self.sectionType];
        }
    }
}
-(void)saveSettingsSection
{
    if (!_settingsSection) {
        // Nothing to save
        return;
    }
    if (self.settingsStorageLocationType == AMSettingsStorageLocationTypeFactoryDefaults) {
        // Can't save factory defaults so nothing to do here
    } else if (self.settingsStorageLocationType == AMSettingsStorageLocationTypeUserDefaults) {
        // Save to NSUserDefaults via AMPreferences
        [AMUserPreferences setData:self.controlledSettingsSection.data forSettingsSection:self.controlledSettingsSection.section];
    } else if (self.settingsStorageLocationType == AMSettingsStorageLocationTypeCurrentDocument) {
        if (self.documentSettings) {
            [self.documentSettings setSettings:self.controlledSettingsSection];
        } else {
            NSAssert(NO, @"No saving mechanism for settings of type %li",self.settingsStorageLocationType);
        }
    }
}
-(AMSettingsSectionType)sectionType
{
    [NSException raise:@"Missing implementation" format:@"Subclasses must override this method"];
    return AMSettingsSectionMathsStyle;
}
-(void)reloadData
{
    [self setResetButtonTitle];
}
-(void)setControlledSettingsSection:(AMSettingsSection *)settingsSection
{
    _settingsSection = settingsSection;
}
-(AMSettingsSection*)controlledSettingsSection
{
    if (_settingsSection) {
        return _settingsSection;
    }
    NSAssert(self.documentSettings, @"Document settings must exist");
    _settingsSection = [self.documentSettings settingsForSection:self.sectionType];
    return _settingsSection;
}
-(AMDocumentSettingsBase *)documentSettings
{
    if (!_documentSettings) {
        switch (self.settingsStorageLocationType) {
            case AMSettingsStorageLocationTypeFactoryDefaults:
                _documentSettings = [AMDocumentSettingsBase documentSettingsFromFactoryDefaults];
                break;
            case AMSettingsStorageLocationTypeUserDefaults:
                _documentSettings = [AMDocumentSettingsBase documentSettingsFromUserDefaults];
                break;
            case AMSettingsStorageLocationTypeCurrentDocument:
                NSAssert(self.documentSettings, @"Document settings must exist");
                break;
        }
    }
    return _documentSettings;
}
-(void)setDocumentSettings:(AMDocumentSettingsBase *)documentSettings
{
    _documentSettings = documentSettings;
}

-(AMSettingsStorageLocationType)settingsStorageLocationType
{
    return _settingsStorageLocationType;
}
-(void)setSettingsStorageLocationType:(AMSettingsStorageLocationType)settingsType
{
    _settingsStorageLocationType = settingsType;
}
-(void)setResetButtonTitle
{
    switch (self.settingsStorageLocationType) {
        case AMSettingsStorageLocationTypeFactoryDefaults:
        {
            [self.resetButton setHidden:YES];
            break;
        }
        case AMSettingsStorageLocationTypeUserDefaults:
        {
            [self.resetButton setHidden:NO];
            self.resetButton.title = NSLocalizedString(@"Reset to factory settings", @"The reset button has two possible titles, one for resetting to the defaults for new documents, the other for resetting to factory defaults. This option is for factory defaults");
            break;
        }
        case AMSettingsStorageLocationTypeCurrentDocument:
        {
            [self.resetButton setHidden:NO];
            self.resetButton.title = NSLocalizedString(@"Reset to defaults for new documents", @"The reset button has two possible titles, one for resetting to the defaults for new documents, the other for resetting to factory defaults. This option is for new document defaults");
            break;
        }
    }
}

@end

