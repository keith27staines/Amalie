//
//  AMPreferencesBaseViewController.m
//  Amalie
//
//  Created by Keith Staines on 05/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMPreferencesBaseViewController.h"
#import "AMDocumentSettings.h"

@interface AMPreferencesBaseViewController ()
{
    AMSettingsType _settingsType;
    AMDocumentSettings * _documentSettings;
}
@end

@implementation AMPreferencesBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)reloadData
{
    // Base implementation is do nothing
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
        [self saveSettings];
    }
    _documentSettings = documentSettings;
}

-(AMSettingsType)settingsType
{
    return _settingsType;
}
-(void)setSettingsType:(AMSettingsType)settingsType
{
    [self saveSettings];
    _settingsType = settingsType;
}

-(void)saveSettings
{
    [NSException raise:@"saveSettings method must be overridden" format:@"This method must be overriden to save settings in appropriate format"];
}
@end
