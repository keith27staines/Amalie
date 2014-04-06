//
//  AMUserPreferences.m
//  Amalie
//
//  Created by Keith Staines on 10/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMUserPreferences.h"
#import "AMAppController.h"
#import "AMSettingsSection.h"
#import "AMFontSettings.h"
#import "AMColorSettings.h"
#import "AMPageSettings.h"
#import "AMMathStyleSettings.h"

static NSMutableDictionary * AMFonts;

@interface AMUserPreferences()

@end

@implementation AMUserPreferences
#pragma mark - Getters and setters for sections objects

#pragma mark - Getters and setters for settings section data -
+(NSData*)dataForSettingsSection:(AMSettingsSectionType)section
{
    NSData * data;
    switch (section) {
        case AMSettingsSectionFonts:
            data = [[NSUserDefaults standardUserDefaults] objectForKey:kAMAllFontSettingsKey];
            break;
        case AMSettingsSectionColors:
            data = [[NSUserDefaults standardUserDefaults] objectForKey:kAMAllColorSettingsKey];
            break;
        case AMSettingsSectionPage:
            data = [[NSUserDefaults standardUserDefaults] objectForKey:kAMAllPageSettingsKey];
            break;
        case AMSettingsSectionMathsStyle:
            data = [[NSUserDefaults standardUserDefaults] objectForKey:KAMAllMathsStyleSettingsKey];
            break;
    }
    return data;
}
+(void)setData:(NSData*)data forSettingsSection:(AMSettingsSectionType)section
{
    switch (section) {
        case AMSettingsSectionFonts:
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:kAMAllFontSettingsKey];
            break;
        case AMSettingsSectionColors:
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:kAMAllColorSettingsKey];
            break;
        case AMSettingsSectionPage:
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:kAMAllPageSettingsKey];
            break;
        case AMSettingsSectionMathsStyle:
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:KAMAllMathsStyleSettingsKey];
            break;
    }
}
+(void)resetSettingsForSection:(AMSettingsSectionType)section
{
    switch (section) {
        case AMSettingsSectionFonts:
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAMAllFontSettingsKey];
            break;
        case AMSettingsSectionColors:
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAMAllColorSettingsKey];
            break;
        case AMSettingsSectionPage:
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAMAllPageSettingsKey];
            break;
        case AMSettingsSectionMathsStyle:
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:KAMAllMathsStyleSettingsKey];
            break;
    }
}

#pragma mark - Register factory default settings -
+(void)registerDefaultPreferences
{
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    AMSettingsSection * settings = nil;
    
    // Font settings
    settings = [AMFontSettings settingsWithFactoryDefaults];
    [defaults setObject:[settings data] forKey:kAMAllFontSettingsKey];
    
    // Color settings
    settings = [AMColorSettings settingsWithFactoryDefaults];
    [defaults setObject:[settings data] forKey:kAMAllColorSettingsKey];

    // Math style settings
    settings = [AMMathStyleSettings settingsWithFactoryDefaults];
    [defaults setObject:[settings data] forKey:KAMAllMathsStyleSettingsKey];
    
    // Page settings
    settings = [AMPageSettings settingsWithFactoryDefaults];
    [defaults setObject:[settings data] forKey:kAMAllPageSettingsKey];

    // register everything
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    
}

#pragma mark - Helper functions -



-(NSUserDefaults *)standardDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

@end
