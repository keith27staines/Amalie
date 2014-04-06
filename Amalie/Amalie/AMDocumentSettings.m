//
//  AMDocumentSettings.m
//  Amalie
//
//  Created by Keith Staines on 07/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMDocumentSettings.h"
#import "AMDDocumentSettings+Methods.h"
#import "AMUserPreferences.h"

#import "AMColorSettings.h"
#import "AMFontSettings.h"
#import "AMMathStyleSettings.h"
#import "AMPageSettings.h"

@interface AMDocumentSettings()
{
    AMDDocumentSettings * _dataObject;
}
@property (readonly) AMDDocumentSettings * dataObject;
@end


@implementation AMDocumentSettings

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createDataObject];
    }
    return self;
}
-(AMDDocumentSettings *)dataObject
{
    if (!_dataObject) {
        [self createDataObject];
        return _dataObject;
    }
    return _dataObject;
}
-(void)createDataObject
{
    _dataObject = [AMDDocumentSettings fetchDocumentSettings];
    if (!_dataObject) {
        _dataObject = [AMDDocumentSettings makeDocumentSettings];
        [self resetToUserDefaults];
    }
}
-(AMSettingsSection*)settingsForSection:(AMSettingsSectionType)section
{
    switch (section) {
        case AMSettingsSectionFonts:
            return self.fontSettings;
        case AMSettingsSectionColors:
            return self.colorSettings;
        case AMSettingsSectionPage:
            return self.pageSettings;
        case AMSettingsSectionMathsStyle:
            return self.mathStyleSettings;
    }
}
-(void)setSettings:(AMSettingsSection *)settings
{
    switch (settings.section) {
        case AMSettingsSectionFonts:
            self.fontSettings = (AMFontSettings*)settings;
        case AMSettingsSectionColors:
            self.colorSettings = (AMColorSettings*)settings;
        case AMSettingsSectionPage:
            self.pageSettings = (AMPageSettings*)settings;
        case AMSettingsSectionMathsStyle:
            self.mathStyleSettings = (AMMathStyleSettings*)settings;
    }
}
-(AMPageSettings *)pageSettings
{
    AMPageSettings * pageSettings;
    NSData * data = _dataObject.pageSettings;
    if (data) {
        pageSettings = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        pageSettings = [AMPageSettings settingsWithUserDefaults];
        [self setPageSettings:pageSettings];
    }
    return pageSettings;
}
-(void)setPageSettings:(AMPageSettings *)pageSettings
{
    _dataObject.pageSettings = [pageSettings data];
}
-(AMColorSettings *)colorSettings
{
    AMColorSettings * colorSettings;
    NSData * colorsData = _dataObject.colorSettings;
    if (colorsData) {
        colorSettings = [NSKeyedUnarchiver unarchiveObjectWithData:colorsData];
    } else {
        colorSettings = [AMColorSettings settingsWithUserDefaults];
        [self setColorSettings:colorSettings];
    }
    return colorSettings;
}
-(void)setColorSettings:(AMColorSettings*)colorSettings
{
    _dataObject.colorSettings = [colorSettings data];
}
-(AMFontSettings *)fontSettings
{
    AMFontSettings * fontSettings;
    NSData * fontData = _dataObject.fontSettings;
    if (fontData) {
        fontSettings = [NSKeyedUnarchiver unarchiveObjectWithData:fontData];
    } else {
        fontSettings = [AMFontSettings settingsWithUserDefaults];
        [self setFontSettings:fontSettings];
    }
    return fontSettings;
}
-(void)setFontSettings:(AMFontSettings*)fontSettings
{
    _dataObject.fontSettings = [fontSettings data];
}
-(AMMathStyleSettings *)mathStyleSettings
{
    AMMathStyleSettings * mathStyleSettings;
    NSData * data = _dataObject.fontSettings;
    if (data) {
        mathStyleSettings = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        mathStyleSettings = [AMMathStyleSettings settingsWithUserDefaults];
        [self setMathStyleSettings:mathStyleSettings];
    }
    return mathStyleSettings;
}
-(void)setMathStyleSettings:(AMMathStyleSettings*)mathStyleSettings
{
    _dataObject.mathStyleSettings = [mathStyleSettings data];
}
-(void)resetToUserDefaults
{
    self.pageSettings = [AMPageSettings settingsWithUserDefaults];
    self.fontSettings = [AMFontSettings settingsWithUserDefaults];
    self.colorSettings = [AMColorSettings settingsWithUserDefaults];
    self.mathStyleSettings = [AMMathStyleSettings settingsWithUserDefaults];
}



@end
