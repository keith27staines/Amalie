//
//  AMUserPreferences.m
//  Amalie
//
//  Created by Keith Staines on 10/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMUserPreferences.h"
#import "AMAppController.h"
#import "AMColorSettings.h"
#import "AMFontSettings.h"

static NSMutableDictionary * AMFonts;

@interface AMUserPreferences()

@end

@implementation AMUserPreferences

+(NSUserDefaults*)defaults
{
    return [NSUserDefaults standardUserDefaults];
}

+(id)objectForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma mark - Page setup -
+(AMPaperType)paperType
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kAMPaperSizeKey];
}
+(void)setPaperType:(AMPaperType)paperType
{
    [[NSUserDefaults standardUserDefaults] setInteger:paperType forKey:kAMPaperSizeKey];
}
+(AMPaperOrientation)paperOrientation
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kAMPageOrientationKey];
}
+(void)setPaperOrientation:(AMPaperOrientation)paperOrientation
{
    [[NSUserDefaults standardUserDefaults] setInteger:paperOrientation forKey:kAMPageOrientationKey];
}
+(NSSize)pageSize
{
    // Portrait orientation
    AMPaperType paperType = [[NSUserDefaults standardUserDefaults] integerForKey:kAMPaperSizeKey];
    
    switch (paperType) {
        case AMPaperTypeA6:
            return NSMakeSize(kAMPageWidthA6, kAMPageHeightA6);
        case AMPaperTypeA5:
            return NSMakeSize(kAMPageWidthA5, kAMPageHeightA5);
        case AMPaperTypeA4:
            return NSMakeSize(kAMPageWidthA4, kAMPageHeightA4);
        case AMPaperTypeA3:
            return NSMakeSize(kAMPageWidthA3, kAMPageHeightA3);
        case AMPaperTypeA2:
            return NSMakeSize(kAMPageWidthA2, kAMPageHeightA2);
        case AMPaperTypeA1:
            return NSMakeSize(kAMPageWidthA1, kAMPageHeightA1);
        case AMPaperTypeA0:
            return NSMakeSize(kAMPageWidthA0, kAMPageHeightA0);
        case AMPaperTypeB5:
            return NSMakeSize(kAMPageWidthB5, kAMPageHeightB5);
        case AMPaperTypeB4:
            return NSMakeSize(kAMPageWidthB4, kAMPageHeightB4);
        case AMPaperTypeUSLetter:
            return NSMakeSize(kAMPageWidthUSLetter, kAMPageHeightUSLetter);
        case AMPaperTypeUSLegal:
            return NSMakeSize(kAMPageWidthUSLegal, kAMPageHeightUSLegal);
        case AMPaperTypeCustom:
        {
            NSSize customSize;
            customSize.width = [[NSUserDefaults standardUserDefaults] integerForKey:@"kAMCustomPaperSizeWidthKey"];
            customSize.height = [[NSUserDefaults standardUserDefaults] integerForKey:@"kAMCustomPaperSizeHeightKey"];
            return customSize;
        }
    }
}
+(void)setPageSize:(NSSize)size
{
    [[NSUserDefaults standardUserDefaults] setInteger:AMPaperTypeCustom forKey:kAMPaperSizeKey];
    [[NSUserDefaults standardUserDefaults] setInteger:size.width forKey:kAMPageWidthCustomKey];
    [[NSUserDefaults standardUserDefaults] setInteger:size.height forKey:kAMPageHeightCustomKey];
}
+(AMMargins)pageMargins
{
    NSString * marginsString = [[NSUserDefaults standardUserDefaults] objectForKey:kAMPageMarginsKey];
    return [self AMMarginsFromNSString:marginsString];
}
+(void)setPageMargins:(AMMargins)margins
{
    [[NSUserDefaults standardUserDefaults] setObject:[self NSStringFromAMMargins:margins] forKey:kAMPageMarginsKey];
}
+(AMMeasurementUnits)paperMeasurementUnits
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kAMPaperMeasurementUnitsKey];
}
+(void)setPaperMeasurementUnits:(AMMeasurementUnits)units
{
    [[NSUserDefaults standardUserDefaults] setInteger:units forKey:kAMPaperMeasurementUnitsKey];
}
AMMargins AMMarginsFromNSRect(NSRect rect)
{
    return AMMarginsMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

AMMargins AMMarginsMake(CGFloat left, CGFloat right, CGFloat top, CGFloat bottom)
{
    AMMargins margins;
    margins.left = left;
    margins.right = right;
    margins.top = top;
    margins.bottom = bottom;
    return margins;
}

+(AMMargins)AMMarginsFromNSString:(NSString*)string
{
    NSArray * components = [string componentsSeparatedByString:@" "];
    NSString * left   = components[0];
    NSString * right  = components[1];
    NSString * top    = components[2];
    NSString * bottom = components[3];
    return AMMarginsMake(left.doubleValue, right.doubleValue, top.doubleValue, bottom.doubleValue);
}

+(NSString*)NSStringFromAMMargins:(AMMargins)margins
{
    return [NSString stringWithFormat:@"%f %f %f %f", margins.left, margins.right, margins.top, margins.bottom];
}

#pragma mark - Fixed width font size -
+(void)setFixedWidthFontSize:(NSUInteger)size
{
    [[NSUserDefaults standardUserDefaults] setInteger:size forKey:kAMFixedWidthFontSizeKey];
}
+(NSUInteger)fixedWidthFontSize
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kAMFixedWidthFontSizeKey];
}

#pragma mark - Math Style -

+(void)setSmallestFontSize:(NSUInteger)size
{
    [[NSUserDefaults standardUserDefaults] setFloat:size forKey:kAMMinFontSizeKey];
}
+(NSUInteger)smallestFontSize
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kAMMinFontSizeKey];
}
+(BOOL)allowFontSynthesis
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kAMAllowFontSynthesisKey];
}
+(void)setAllowFontSynthesis:(BOOL)yn
{
    [[NSUserDefaults standardUserDefaults] setInteger:yn forKey:kAMAllowFontSynthesisKey];
}
+(void)setSuperscriptingFraction:(CGFloat)superscriptingFraction
{
    [[NSUserDefaults standardUserDefaults] setFloat:superscriptingFraction forKey:kAMSuperscriptingFractionKey];
}
+(CGFloat)superscriptingFraction
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:kAMSuperscriptingFractionKey];
}
+(void)setSuperscriptOffset:(CGFloat)offset
{
    [[NSUserDefaults standardUserDefaults] setFloat:offset forKey:kAMSuperscriptOffsetKey];
}
+(CGFloat)superscriptOffset
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:kAMSuperscriptOffsetKey];
}
+(void)setSubscriptOffset:(CGFloat)offset
{
    [[NSUserDefaults standardUserDefaults] setFloat:offset forKey:kAMSubscriptOffsetKey];
}
+(CGFloat)subscriptOffset
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:kAMSubscriptOffsetKey];
}

#pragma mark - Reset settings to factory defaults -
+ (void)resetAll {
    NSDictionary *defaultsDict = [[self defaults] dictionaryRepresentation];
    
    for (NSString *key in [defaultsDict allKeys])
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}
+ (void)resetPageMargins {
    [[self defaults] removeObjectForKey:kAMPageMarginsKey];
}
+ (void)resetPaperType {
    [[self defaults] removeObjectForKey:kAMPaperSizeKey];
}
+ (void)resetPaperOrientation {
    [[self defaults] removeObjectForKey:kAMPageOrientationKey];
}
+ (void)resetSmallestFontSize {
    [[self defaults] removeObjectForKey:kAMMinFontSizeKey];
}
+ (void)resetFixedWidthFontSize {
    [[self defaults] removeObjectForKey:kAMFixedWidthFontSizeKey];
}
+ (void)resetSuperscriptingFraction {
    [[self defaults] removeObjectForKey:kAMSuperscriptingFractionKey];
}
+(void)resetColorData
{
    [[self defaults] removeObjectForKey:kAMLibraryObjectsKey];
}

#pragma mark - Getters and setters for settings section data -
+(NSData*)dataForSettingsSection:(AMSettingsSectionType)section
{
    NSData * data;
    switch (section) {
        case AMSettingsSectionColors:
            data = [[NSUserDefaults standardUserDefaults] objectForKey:kAMAllColorSettingsKey];
            break;
        case AMSettingsSectionFonts:
            data = [[NSUserDefaults standardUserDefaults] objectForKey:kAMFontAttributesKey];
            break;
        case AMSettingsSectionPaper:
            data = [[NSUserDefaults standardUserDefaults] objectForKey:kAMAllColorSettingsKey];
            break;
        case AMSettingsSectionMathsStyle:
            data = [[NSUserDefaults standardUserDefaults] objectForKey:kAMAllColorSettingsKey];
            break;
    }
    return data;
}
+(void)setDataForSettingsSection:(AMSettingsSectionType)section
{
    
}
+(void)resetSettingsForSection:(AMSettingsSectionType)section
{
    
}

#pragma mark - Color settings -
+(AMColorSettings*)colorSettings
{
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:kAMAllColorSettingsKey];
    AMColorSettings * colors = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return colors;
}
+(void)setColorSettings:(AMColorSettings *)colorSettings
{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:colorSettings];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kAMAllColorSettingsKey];
}
+(void)resetColorSettings
{
    [[self defaults] removeObjectForKey:kAMLibraryObjectsKey];
}

#pragma mark - Font settings -
+(AMFontSettings*)fontSettings
{
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:kAMFontAttributesKey];
    AMFontSettings * fontSettings = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return fontSettings;
}
+(void)setFontSettings:(AMFontSettings *)fontSettings
{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:fontSettings];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kAMFontAttributesKey];
}
+(void)resetFontSettings
{
    [[self defaults] removeObjectForKey:kAMFontAttributesKey];
}

#pragma mark - Register factory default settings -
+(void)registerDefaultPreferences
{
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    
    // Main window configuration

    
    // Paper size and margins
    [defaults setObject:@(AMPaperTypeA4) forKey:kAMPaperSizeKey];
    [defaults setObject:@(kAMPageWidthA4) forKey:kAMPageWidthCustomKey];
    [defaults setObject:@(kAMPageHeightA4) forKey:kAMPageHeightCustomKey];
    [defaults setObject:@(AMPaperOrientationPortrait) forKey:kAMPageOrientationKey];
    [defaults setObject:@(AMMeasurementUnitsPoints) forKey:kAMPaperMeasurementUnitsKey];
    
    AMMargins margins = AMMarginsMake(72, 72, 72, 72);
    [defaults setObject:[self NSStringFromAMMargins:margins] forKey:kAMPageMarginsKey];
    

    [defaults setObject:@(kAMFactorySettingMinFontSize) forKey:kAMMinFontSizeKey];
    
    // Mathematical typography style
    [defaults setObject:@(kAMFactorySettingSuperscriptingFraction) forKey:kAMSuperscriptingFractionKey];
    [defaults setObject:@(kAMFactorySettingSuperscriptOffset) forKey:kAMSuperscriptOffsetKey];
    [defaults setObject:@(kAMFactorySettingSubscriptOffset) forKey:kAMSubscriptOffsetKey];
    [defaults setObject:@(YES) forKey:kAMAllowFontSynthesisKey];
    
    // Add the dictionary for color settings
    NSMutableDictionary * colorSettings = [AMColorSettings settingsWithFactoryDefaults];
    NSData * colorData = [NSKeyedArchiver archivedDataWithRootObject:colorSettings];
    [defaults setObject:colorData forKey:kAMAllColorSettingsKey];

    // Add the dictionary for font settings
    NSMutableDictionary * fontSettings = [AMFontSettings settingsWithFactoryDefaults];
    NSData * fontData = [NSKeyedArchiver archivedDataWithRootObject:fontSettings];
    [defaults setObject:fontData forKey:kAMFontAttributesKey];

    // register everything
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    
}

#pragma mark - Helper functions -



-(NSUserDefaults *)standardDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

@end
