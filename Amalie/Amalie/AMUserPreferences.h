//
//  AMUserPreferences.h
//  Amalie
//
//  Created by Keith Staines on 10/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMFontSettings, AMPageSettings, AMColorSettings, AMMathStyleSettings;

#import <Foundation/Foundation.h>
#import "AMConstants.h"

@interface AMUserPreferences : NSObject

#pragma mark - Register factory default settings -
+(void)registerDefaultPreferences;

#pragma mark - Reset settings to factory defaults -

#pragma mark - Getters and setters for entre settings section data objects
+(NSData*)dataForSettingsSection:(AMSettingsSectionType)section;
+(void)setData:(NSData*)data forSettingsSection:(AMSettingsSectionType)section;
+(void)resetSettingsForSection:(AMSettingsSectionType)section;

@end
