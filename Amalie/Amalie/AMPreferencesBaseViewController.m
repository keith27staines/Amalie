//
//  AMPreferencesBaseViewController.m
//  Amalie
//
//  Created by Keith Staines on 05/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMPreferencesBaseViewController.h"
#import "AMDocumentSettings.h"
#import "AMSettingsSection.h"
#import "AMUserPreferences.h"

@interface AMPreferencesBaseViewController ()
{
    @private
    AMSettingsStorageLocationType _settingsStorageLocationType;
    AMDocumentSettings * _documentSettings;
    @protected
    AMSettingsSection  * _settingsSection;
}

@property AMSettingsSection * settingsSection;

@end

@implementation AMPreferencesBaseViewController


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
        [AMUserPreferences setData:self.settingsSection.data forSettingsSection:self.settingsSection.section];
    } else if (self.settingsStorageLocationType == AMSettingsStorageLocationTypeCurrentDocument) {
        if (self.documentSettings) {
            [self.documentSettings setSettings:self.settingsSection];
        } else {
            NSAssert(NO, @"No saving mechanism for settings of type %li",self.settingsStorageLocationType);
        }
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(AMSettingsSectionType)sectionType
{
    [NSException raise:@"Missing implementation" format:@"Subclasses must override this method"];
    return AMSettingsSectionMathsStyle;
}
-(void)reloadData
{
    // Base implementation is to do nothing
}

-(void)setSettingsSection:(AMSettingsSection *)settingsSection
{
    _settingsSection = settingsSection;
}
-(AMSettingsSection*)settingsSection
{
    if (_settingsSection) {
        return _settingsSection;
    }

    switch (self.settingsStorageLocationType) {
        case AMSettingsStorageLocationTypeFactoryDefaults:
            _settingsSection = [AMSettingsSection settingsWithFactoryDefaultsOfType:self.sectionType];
            break;
        case AMSettingsStorageLocationTypeUserDefaults:
            _settingsSection = [AMSettingsSection settingsWithUserDefaultsOfType:self.sectionType];
            break;
        case AMSettingsStorageLocationTypeCurrentDocument:
            NSAssert(self.documentSettings, @"Document settings must exist");
            _settingsSection = [self.documentSettings settingsForSection:self.sectionType];
            break;
    }
    return _settingsSection;
}

-(AMDocumentSettings *)documentSettings
{
    return _documentSettings;
}

-(void)setDocumentSettings:(AMDocumentSettings *)documentSettings
{
    if (documentSettings == _documentSettings) {
        return;
    }
    if (_documentSettings) {
        [self saveSettingsSection];
    }
    _documentSettings = documentSettings;
}

-(AMSettingsStorageLocationType)settingsStorageLocationType
{
    return _settingsStorageLocationType;
}
-(void)setSettingsStorageLocationType:(AMSettingsStorageLocationType)settingsType
{
    [self saveSettingsSection];
    _settingsStorageLocationType = settingsType;
}
    

@end

