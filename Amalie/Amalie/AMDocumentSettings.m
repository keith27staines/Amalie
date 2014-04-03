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

#import "AMPaper.h"
#import "AMColorSettings.h"
#import "AMFontSettings.h"
#import "AMMathStyleSettings.h"

@interface AMDocumentSettings()
{
    AMDDocumentSettings * _dataObject;
    AMPaper * _paper;
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
-(AMPaper*)paper
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.dataObject.pageSetup];
}
-(void)setPaper:(AMPaper *)paper
{
    _dataObject.pageSetup = [NSKeyedArchiver archivedDataWithRootObject:paper];
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
    _dataObject.colorSettings = [NSKeyedArchiver archivedDataWithRootObject:colorSettings];
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
    _dataObject.fontSettings = [NSKeyedArchiver archivedDataWithRootObject:fontSettings];
}
-(AMMathStyleSettings *)mathsStyleSettings
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
    _dataObject.mathStyleSettings = [NSKeyedArchiver archivedDataWithRootObject:mathStyleSettings];
}
-(void)resetToUserDefaults
{
    self.fontSettings = [AMFontSettings settingsWithUserDefaults];
    self.colorSettings = [AMColorSettings settingsWithUserDefaults];
    self.mathsStyleSettings = [AMMathStyleSettings settingsWithUserDefaults];
}

-(CGFloat)smallestFontSize
{
    return self.dataObject.smallestFontSize.floatValue;
}
-(void)setSmallestFontSize:(CGFloat)smallestFontSize
{
    self.dataObject.smallestFontSize = @(smallestFontSize);
}
-(CGFloat)superscriptingFraction
{
    return self.dataObject.superscriptingFraction.floatValue;
}
-(void)setSuperscriptingFraction:(CGFloat)superscriptingFraction
{
    self.dataObject.superscriptingFraction = @(superscriptingFraction);
}
-(CGFloat)superscriptOffset
{
    return self.dataObject.superscriptOffset.floatValue;
}
-(void)setSuperscriptOffset:(CGFloat)superscriptOffset
{
    self.dataObject.superscriptOffset = @(superscriptOffset);
}
-(CGFloat)subscriptOffset
{
    return self.dataObject.subscriptOffset.floatValue;
}
-(void)setSubscriptOffset:(CGFloat)subscriptOffset
{
    self.dataObject.subscriptOffset = @(subscriptOffset);
}




@end
