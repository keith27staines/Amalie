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

+(id)documentSettingsFromDocument
{
    AMPersistentDocumentSettings * documentSettings = [[self.class alloc] init];
    return documentSettings;
}
-(AMDDocumentSettings *)dataObject
{
    if (!_dataObject) {
        _dataObject = [AMDDocumentSettings fetchDocumentSettings];
        if (!_dataObject) {
            _dataObject = [AMDDocumentSettings makeDocumentSettings];
            [self resetToUserDefaults];
        }
        return _dataObject;
    }
    return _dataObject;
}
-(AMPageSettings *)pageSettings
{
    AMPageSettings * pageSettings;
    NSData * data = self.dataObject.pageSettingsData;
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
    self.dataObject.pageSettingsData = [pageSettings data];
}
-(AMColorSettings *)colorSettings
{
    AMColorSettings * colorSettings;
    NSData * colorsData = self.dataObject.colorSettingsData;
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
    self.dataObject.colorSettingsData = [colorSettings data];
}
-(AMFontSettings *)fontSettings
{
    AMFontSettings * fontSettings;
    NSData * fontData = self.dataObject.fontSettingsData;
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
    self.dataObject.fontSettingsData = [fontSettings data];
}
-(AMMathStyleSettings *)mathStyleSettings
{
    AMMathStyleSettings * mathStyleSettings;
    NSData * data = self.dataObject.mathStyleSettingsData;
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
    self.dataObject.mathStyleSettingsData = [mathStyleSettings data];
}



@end
