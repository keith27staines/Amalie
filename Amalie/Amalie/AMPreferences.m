//
//  AMPreferences.m
//  Amalie
//
//  Created by Keith Staines on 10/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMPreferences.h"
#import "AMAppController.h"
#import "AMFontAttributes.h"

static NSMutableDictionary * AMFonts;

@interface AMPreferences()

@end

@implementation AMPreferences

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


//

+(NSFont *)fontForFontType:(AMFontType)fontType
{
    AMFontAttributes * atts = [self fontAttributesForFontType:fontType];
    return [atts font];
}

#pragma mark - Font size -
+(void)setFontSize:(NSUInteger)size
{
    [[NSUserDefaults standardUserDefaults] setInteger:size forKey:kAMFontSizeKey];
}
+(NSUInteger)fontSize
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kAMFontSizeKey];
}
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

#pragma mark - Other font properties -
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

#pragma mark - Font management -
+(AMFontAttributes*)fontAttributesForFontType:(AMFontType)fontType
{
    NSString * key = [self fontAttributesKeyForFontType:fontType];
    NSData * data = [[NSUserDefaults standardUserDefaults] dataForKey:key];
    NSAssert(data, @"No data from which to unarchive object");
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}
+(void)setFontAttributes:(NSDictionary *)attributes forFontType:(AMFontType)fontType
{
    NSString * key = [self fontAttributesKeyForFontType:fontType];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:attributes] forKey:key];
}
+(NSString*)fontAttributesKeyForFontType:(AMFontType)fontType
{
    switch (fontType) {
        case AMFontTypeLiteral:
        {
            return kAMFontAttributesForLiteralsKey;
        }
        case AMFontTypeAlgebra:
        {
            return kAMFontAttributesForAlgebraKey;
        }
        case AMFontTypeVector:
        {
            return kAMFontAttributesForVectorsKey;
        }
        case AMFontTypeMatrix:
        {
            return kAMFontAttributesForMatricesKey;
        }
        case AMFontTypeSymbol:
        {
            return kAMFontAttributesForSymbolsKey;
        }
        case AMFontTypeText:
        {
            return kAMFontAttributesForTextKey;
        }
        case AMFontTypeFixedWidth:
        {
            return kAMFontAttributesForFixedWidthTextKey;
        }
    }
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
+ (void)resetFontAttributesForFontType:(AMFontType)fontType {
    switch (fontType) {
        case AMFontTypeLiteral:
        {
            [[self defaults] removeObjectForKey:kAMFontAttributesForLiteralsKey];
            break;
        }
        case AMFontTypeAlgebra:
        {
            [[self defaults] removeObjectForKey:kAMFontAttributesForAlgebraKey];
            break;
        }
        case AMFontTypeVector:
        {
            [[self defaults] removeObjectForKey:kAMFontAttributesForVectorsKey];
            break;
        }
        case AMFontTypeMatrix:
        {
            [[self defaults] removeObjectForKey:kAMFontAttributesForMatricesKey];
            break;
        }
        case AMFontTypeSymbol:
        {
            [[self defaults] removeObjectForKey:kAMFontAttributesForSymbolsKey];
            break;
        }
        case AMFontTypeText:
        {
            [[self defaults] removeObjectForKey:kAMFontAttributesForTextKey];
            break;
        }
        case AMFontTypeFixedWidth:
        {
            [[self defaults] removeObjectForKey:kAMFontAttributesForFixedWidthTextKey];
            break;
        }
    }
}
+ (void)resetFontSize {
    [[self defaults] removeObjectForKey:kAMFontSizeKey];
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
+ (void)resetAllowFontSynthesis {
    [[self defaults] removeObjectForKey:kAMAllowFontSynthesisKey];
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
    
    // Font names
    AMFontAttributes * literalsAtts   = [AMFontAttributes fontAttributesWithName:kAMFactorySettingFontNameForLiterals       size:kAMFactorySettingFontSize bold:NO  italic:NO  allowSynthesis:kAMFactorySettingAllowFontSynthesis];
    AMFontAttributes * algebraAtts    = [AMFontAttributes fontAttributesWithName:kAMFactorySettingFontNameForAlgebra        size:kAMFactorySettingFontSize bold:NO  italic:YES allowSynthesis:kAMFactorySettingAllowFontSynthesis];
    AMFontAttributes * vectorAtts     = [AMFontAttributes fontAttributesWithName:kAMFactorySettingFontNameForVectors        size:kAMFactorySettingFontSize bold:YES italic:NO  allowSynthesis:kAMFactorySettingAllowFontSynthesis];
    AMFontAttributes * matricesAtts   = [AMFontAttributes fontAttributesWithName:kAMFactorySettingFontNameForMatrices       size:kAMFactorySettingFontSize bold:YES italic:NO  allowSynthesis:kAMFactorySettingAllowFontSynthesis];
    AMFontAttributes * symbolsAtts    = [AMFontAttributes fontAttributesWithName:kAMFactorySettingFontNameForSymbols        size:kAMFactorySettingFontSize bold:NO  italic:NO  allowSynthesis:kAMFactorySettingAllowFontSynthesis];
    AMFontAttributes * textAtts       = [AMFontAttributes fontAttributesWithName:kAMFactorySettingFontNameForText           size:kAMFactorySettingFontSize bold:NO  italic:NO  allowSynthesis:kAMFactorySettingAllowFontSynthesis];
    AMFontAttributes * fixedWidthAtts = [AMFontAttributes fontAttributesWithName:kAMFactorySettingFontNameForFixedWidthText size:kAMFactorySettingFixedWidthFontSize bold:NO italic:NO allowSynthesis:kAMFactorySettingAllowFontSynthesis];
    
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:literalsAtts]   forKey:kAMFontAttributesForLiteralsKey];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:algebraAtts]    forKey:kAMFontAttributesForAlgebraKey];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:vectorAtts]     forKey:kAMFontAttributesForVectorsKey];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:matricesAtts]   forKey:kAMFontAttributesForMatricesKey];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:symbolsAtts]    forKey:kAMFontAttributesForSymbolsKey];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:textAtts]       forKey:kAMFontAttributesForTextKey];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:fixedWidthAtts] forKey:kAMFontAttributesForFixedWidthTextKey];
    
    // Font sizes
    [defaults setObject:@(kAMFactorySettingFontSize)    forKey:kAMFontSizeKey];
    [defaults setObject:@(kAMFactorySettingFixedWidthFontSize) forKey:kAMFixedWidthFontSizeKey];
    [defaults setObject:@(kAMFactorySettingMinFontSize) forKey:kAMMinFontSizeKey];
    
    // Mathematical typography style
    [defaults setObject:@(kAMFactorySettingSuperscriptingFraction) forKey:kAMSuperscriptingFractionKey];
    [defaults setObject:@(kAMFactorySettingSuperscriptOffset) forKey:kAMSuperscriptOffsetKey];
    [defaults setObject:@(kAMFactorySettingSubscriptOffset) forKey:kAMSubscriptOffsetKey];
    [defaults setObject:@(YES) forKey:kAMAllowFontSynthesisKey];
    
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

-(NSUserDefaults *)standardDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

@end
