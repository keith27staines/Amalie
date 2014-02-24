//
//  AMPreferences.m
//  Amalie
//
//  Created by Keith Staines on 10/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMPreferences.h"
#import "AMAppController.h"

static NSMutableDictionary * AMFonts;

@interface AMPreferences()

@end

@implementation AMPreferences

+(AMPreferences*)sharedPreferences
{
    static AMPreferences * _sharedPreferences;
    if (!_sharedPreferences) {
        _sharedPreferences = [[AMPreferences alloc] init];
    }
    return _sharedPreferences;
}

+(NSUserDefaults*)defaults
{
    return [NSUserDefaults standardUserDefaults];
}

+(id)objectForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma mark - Worksheet page size -
-(NSSize)worksheetPageSize
{
    return [AMPreferences worksheetPageSize];
}
-(void)setWorksheetPageSize:(NSSize)worksheetPageSize
{
    [AMPreferences setWorksheetPageSize:worksheetPageSize];
}
+(AMPaperType)worksheetPaperType
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kAMPaperSizeKey];
}
+(void)setWorksheetPaperType:(AMPaperType)paperType
{
    [[NSUserDefaults standardUserDefaults] setInteger:paperType forKey:kAMPaperSizeKey];
}
-(AMPaperType)worksheetPaperType
{
    return [AMPreferences worksheetPaperType];
}
-(void)setWorksheetPaperType:(AMPaperType)worksheetPaperType
{
    [AMPreferences setWorksheetPaperType:worksheetPaperType];
}
+(NSSize)worksheetPageSize
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
+(void)setWorksheetPageSize:(NSSize)size
{
    [[NSUserDefaults standardUserDefaults] setInteger:AMPaperTypeCustom forKey:kAMPaperSizeKey];
    [[NSUserDefaults standardUserDefaults] setInteger:size.width forKey:kAMPageWidthCustomKey];
    [[NSUserDefaults standardUserDefaults] setInteger:size.height forKey:kAMPageHeightCustomKey];
}
-(AMMargins)pageMargins
{
    return [AMPreferences pageMargins];
}
-(void)setPageMargins:(AMMargins)pageMargins
{
    [AMPreferences setPageMargins:pageMargins];
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
    NSString * left = components[0];
    NSString * right = components[1];
    NSString * top = components[2];
    NSString * bottom = components[3];
    return AMMarginsMake(left.doubleValue, right.doubleValue, top.doubleValue, bottom.doubleValue);
}

+(NSString*)NSStringFromAMMargins:(AMMargins)margins
{
    return [NSString stringWithFormat:@"%f %f %f %f", margins.left, margins.right, margins.top, margins.bottom];
}

#pragma mark - Worksheet fixed width font size -
+(void)setWorksheetFixedWidthFontSize:(NSUInteger)size
{
    [[NSUserDefaults standardUserDefaults] setInteger:size forKey:kAMFixedWidthFontSizeKey];
}
+(NSUInteger)worksheetFixedWidthFontSize
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kAMFixedWidthFontSizeKey];
}

#pragma mark - Worksheet standard font size -
-(NSUInteger)worksheetFontSize
{
    return [AMPreferences worksheetFontSize];
}
-(void)setWorksheetFontSize:(NSUInteger)size
{
    [AMPreferences setWorksheetFontSize:size];
}
+(void)setWorksheetFontSize:(NSUInteger)size
{
    [[NSUserDefaults standardUserDefaults] setInteger:size forKey:kAMFontSizeKey];
}
+(NSUInteger)worksheetFontSize
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kAMFontSizeKey];
}

#pragma mark - Scripting fraction -
+(void)setSuperscriptingFraction:(CGFloat)superscriptingFraction
{
    [[NSUserDefaults standardUserDefaults] setFloat:superscriptingFraction forKey:kAMSuperscriptingFraction];
}
+(CGFloat)superscriptingFraction
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:kAMSuperscriptingFraction];
}

+(void)setWorksheetFontDelta:(NSUInteger)delta
{
    [[NSUserDefaults standardUserDefaults] setInteger:delta forKey:kAMFontSizeDeltaKey];
}

+(NSUInteger)worksheetFontDelta
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kAMFontSizeDeltaKey];
}

+(void)setWorksheetSmallestFontSize:(NSUInteger)size
{
    [[NSUserDefaults standardUserDefaults] setInteger:size forKey:kAMMinFontSizeKey];
}

+(NSUInteger)worksheetSmallestFontSize
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kAMMinFontSizeKey];
}

+(void)setWorksheetFixedWidthFontName:(NSString *)fontName
{
    [[NSUserDefaults standardUserDefaults] setObject:fontName forKey:kAMFixedWidthFontNameKey];
}

+(NSString*)worksheetFixedWidthFontName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAMFixedWidthFontNameKey];
}

+(void)setWorksheetFontName:(NSString *)fontName
{
    [[NSUserDefaults standardUserDefaults] setObject:fontName forKey:kAMFontNameKey];
}

+(NSString*)worksheetFontName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAMFontNameKey];
}

+(NSDictionary*)fonts
{
    NSFont * fixedWidthFont = [NSFont fontWithName:[AMPreferences worksheetFixedWidthFontName]
                                              size:[AMPreferences worksheetFixedWidthFontSize]];

    NSFont * standardFont = [NSFont fontWithName:[AMPreferences worksheetFontName]
                                            size:[AMPreferences worksheetFontSize]];
    
    return @{kAMFixedWidthFontNameKey: fixedWidthFont, kAMFontNameKey:standardFont};
}

+(NSFont*)standardFont
{
    return self.fonts[kAMFontNameKey];
}

+(NSFont*)fixedWidthFont
{
    return self.fonts[kAMFixedWidthFontNameKey];
}
+(void)registerDefaultPreferences
{
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    
    // Main window configuration

    
    // Paper size and margins
    [defaults setObject:@(AMPaperTypeA4) forKey:kAMPaperSizeKey];
    [defaults setObject:@(kAMPageWidthA4) forKey:kAMPageWidthCustomKey];
    [defaults setObject:@(kAMPageHeightA4) forKey:kAMPageHeightCustomKey];
    AMMargins margins = AMMarginsMake(72, 72, 72, 72);
    [defaults setObject:[self NSStringFromAMMargins:margins] forKey:kAMPageMarginsKey];
    
    // Font names
    [defaults setObject:kAMDefaultFontName forKey:kAMFontNameKey];
    [defaults setObject:kAMDefaultFixedWidthFontName forKey:kAMFixedWidthFontNameKey];
    
    // Font sizes
    [defaults setObject:@(kAMDefaultFontSize)    forKey:kAMFontSizeKey];
    [defaults setObject:@(kAMDefaultFixedWidthFontSize) forKey:kAMFixedWidthFontSizeKey];
    [defaults setObject:@(kAMDefaultFontDelta)   forKey:kAMFontSizeDeltaKey];
    [defaults setObject:@(kAMDefaultMinFontSize) forKey:kAMMinFontSizeKey];
    [defaults setObject:@(kAMDefaultSuperscriptingFraction) forKey:kAMSuperscriptingFraction];
    
    // Add the dictionaries for the tray objects
    NSMutableDictionary * trayDictionary = [self trayFactorySettingsDictionary];
    [defaults setObject:trayDictionary forKey:kAMTrayDictionaryKey];
    
    // register everything
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    
}

+(NSMutableDictionary*)trayFactorySettingsDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    
    // Constant dictionary
    NSDictionary * constantDictionary   = @{kAMBackColorKey : colorDataFromName(AMColorPaleRed),
                                            kAMFontColorKey : colorDataFromName(AMColorBlack)};
    [dictionary setObject:constantDictionary forKey:kAMConstantKey];
    
    // Variable dictionary
    NSDictionary * variableDictionary   = @{kAMBackColorKey : colorDataFromName(AMColorPaleGreen),
                                            kAMFontColorKey : colorDataFromName(AMColorBlack)};
    [dictionary setObject:variableDictionary forKey:kAMVariableKey];
    
    // Expression dictionary
    NSDictionary * expressionDictionary = @{kAMBackColorKey : colorDataFromName(AMColorPaleBlue),
                                            kAMFontColorKey : colorDataFromName(AMColorBlack)};
    [dictionary setObject:expressionDictionary forKey:kAMExpressionKey];
    
    // Function dictionary
    NSDictionary * functionDictionary = @{kAMBackColorKey : colorDataFromName(AMColorPaleGreen),
                                          kAMFontColorKey: colorDataFromName(AMColorBlack)};
    [dictionary setObject:functionDictionary forKey:kAMFunctionKey];
    
    // Equation dictionary
    NSDictionary * equationDictionary   = @{kAMBackColorKey : colorDataFromName(AMColorPaleYellow),
                                            kAMFontColorKey : colorDataFromName(AMColorBlack)};
    [dictionary setObject:equationDictionary forKey:kAMEquationKey];
    
    // Vector dictionary
    NSDictionary * vectorDictionary     = @{kAMBackColorKey : colorDataFromName(AMColorPaleOrange),
                                            kAMFontColorKey : colorDataFromName(AMColorBlack)};
    [dictionary setObject:vectorDictionary forKey:kAMVectorKey];
    
    // Matrix dictionary
    NSDictionary * matrixDictionary     = @{kAMBackColorKey : colorDataFromName(AMColorBarleyWhite),
                                            kAMFontColorKey : colorDataFromName(AMColorBlack)};
    [dictionary setObject:matrixDictionary forKey:kAMMatrixKey];
    
    // Set dictionary
    NSDictionary * mSetDictionary       = @{kAMBackColorKey : colorDataFromName(AMColorPaleAzure),
                                            kAMFontColorKey : colorDataFromName(AMColorBlack)};
    [dictionary setObject:mSetDictionary forKey:kAMGraph2DKey];
    
    // Graph dictionary
    NSDictionary * graph2DDictionary    = @{kAMBackColorKey : colorDataFromName(AMColorPalePurple),
                                            kAMFontColorKey : colorDataFromName(AMColorBlack)};
    [dictionary setObject:graph2DDictionary forKey:kAMGraph2DKey];

    
    return dictionary;
}

#pragma mark - Helper functions -

NSData * colorDataFromName(AMColor color)
{
    return dataFromColor(colorFromName(color));
}

NSColor * colorFromName(AMColor color)
{
    switch (color) {
        case AMColorPaleRed:
            return [NSColor colorWithCalibratedRed:1.0 green:0.8 blue:0.8 alpha:1.0];
        case AMColorPaleGreen:
            return [NSColor colorWithCalibratedRed:0.8 green:1.0 blue:0.8 alpha:1.0];
        case AMColorPaleBlue:
            return [NSColor colorWithCalibratedRed:0.8 green:0.8 blue:1.0 alpha:1.0];
        case AMColorPaleYellow:
            return [NSColor colorWithCalibratedRed:1.0 green:1.0 blue:0.8 alpha:1.0];
        case AMColorPalePurple:
            return [NSColor colorWithCalibratedRed:1.0 green:0.8 blue:1.0 alpha:1.0];
        case AMColorPaleAzure:
            return [NSColor colorWithCalibratedRed:0.8 green:1.0 blue:1.0 alpha:1.0];
        case AMColorPaleOrange:
            return [NSColor colorWithCalibratedRed:1.0 green:0.8 blue:0.6 alpha:1.0];
        case AMColorBarleyWhite:
            return [NSColor colorWithCalibratedRed:1.0 green:0.9 blue:0.8 alpha:1.0];
        case AMColorWhite:
            return [NSColor colorWithCalibratedRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        case AMColorBlack:
            return [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:1.0];
            
        default:
            break;
    }
}


@end
