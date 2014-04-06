//
//  AMDocumentSettings.h
//  Amalie
//
//  Created by Keith Staines on 07/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMPaper, AMFontAttributes, AMColorSettings, AMFontSettings, AMMathStyleSettings, AMPageSettings, AMSettingsSection;


#import <Foundation/Foundation.h>
#import "AMConstants.h"

@interface AMDocumentSettings : NSObject

#pragma mark - Getters and setters for user preference sections
-(AMSettingsSection*)settingsForSection:(AMSettingsSectionType)section;
-(void)setSettings:(AMSettingsSection*)settings;

#pragma mark - Settings for paper, fonts and colors
@property (copy) AMFontSettings * fontSettings;
@property (copy) AMColorSettings * colorSettings;
@property (copy) AMPageSettings * pageSettings;
@property (copy) AMMathStyleSettings * mathStyleSettings;

#pragma mark - reset
-(void)resetToUserDefaults;

@end
