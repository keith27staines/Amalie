//
//  AMPersistentDocumentSettings.m
//  Amalie
//
//  Created by Keith Staines on 07/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMPersistentDocumentSettings.h"
#import "AMDDocumentSettings+Methods.h"
#import "AMUserPreferences.h"

#import "AMSettingsSection.h"
#import "AMColorSettings.h"
#import "AMFontSettings.h"
#import "AMMathStyleSettings.h"
#import "AMPageSettings.h"

@interface AMPersistentDocumentSettings()
{
    AMDDocumentSettings * _dataObject;
}
@property (readonly) AMDDocumentSettings * dataObject;
@end


@implementation AMPersistentDocumentSettings

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
-(AMPageSettings *)pageSettings
{
    AMPageSettings * pageSettings;
    NSData * data = _dataObject.pageSettingsData;
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
    _dataObject.pageSettingsData = [pageSettings data];
}
-(AMColorSettings *)colorSettings
{
    AMColorSettings * colorSettings;
    NSData * colorsData = _dataObject.colorSettingsData;
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
    _dataObject.colorSettingsData = [colorSettings data];
}
-(AMFontSettings *)fontSettings
{
    AMFontSettings * fontSettings;
    NSData * fontData = _dataObject.fontSettingsData;
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
    _dataObject.fontSettingsData = [fontSettings data];
}
-(AMMathStyleSettings *)mathStyleSettings
{
    AMMathStyleSettings * mathStyleSettings;
    NSData * data = _dataObject.mathStyleSettingsData;
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
    _dataObject.mathStyleSettingsData = [mathStyleSettings data];
}



@end
