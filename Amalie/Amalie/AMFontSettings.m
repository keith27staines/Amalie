//
//  AMFontSettings.m
//  Amalie
//
//  Created by Keith Staines on 02/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMFontSettings.h"
#import "AMFontAttributes.h"
#import "AMUserPreferences.h"

@interface AMFontSettings()
{
    BOOL    _allowFontSynthesis;
    CGFloat _fontSize;
    CGFloat _fixedWidthFontSize;
    NSMutableDictionary * _fontAttributesDictionary;
}
@property NSMutableDictionary * fontAttributesDictionary;
@end

@implementation AMFontSettings

#pragma mark - Overrides -
-(AMSettingsSectionType)section
{
    return AMSettingsSectionFonts;
}

- (instancetype)initWithFactoryDefaults
{
    self = [super initWithFactoryDefaults];
    if (!self) {
        return nil;
    }
        
    AMFontAttributes * literalsAtts   = [AMFontAttributes fontAttributesWithName:kAMFactorySettingFontNameForLiterals       size:kAMFactorySettingFontSize bold:NO  italic:NO  allowSynthesis:kAMFactorySettingAllowFontSynthesis];
    AMFontAttributes * algebraAtts    = [AMFontAttributes fontAttributesWithName:kAMFactorySettingFontNameForAlgebra        size:kAMFactorySettingFontSize bold:NO  italic:YES allowSynthesis:kAMFactorySettingAllowFontSynthesis];
    AMFontAttributes * vectorAtts     = [AMFontAttributes fontAttributesWithName:kAMFactorySettingFontNameForVectors        size:kAMFactorySettingFontSize bold:YES italic:NO  allowSynthesis:kAMFactorySettingAllowFontSynthesis];
    AMFontAttributes * matricesAtts   = [AMFontAttributes fontAttributesWithName:kAMFactorySettingFontNameForMatrices       size:kAMFactorySettingFontSize bold:YES italic:NO  allowSynthesis:kAMFactorySettingAllowFontSynthesis];
    AMFontAttributes * symbolsAtts    = [AMFontAttributes fontAttributesWithName:kAMFactorySettingFontNameForSymbols        size:kAMFactorySettingFontSize bold:NO  italic:NO  allowSynthesis:kAMFactorySettingAllowFontSynthesis];
    AMFontAttributes * textAtts       = [AMFontAttributes fontAttributesWithName:kAMFactorySettingFontNameForText           size:kAMFactorySettingFontSize bold:NO  italic:NO  allowSynthesis:kAMFactorySettingAllowFontSynthesis];
    AMFontAttributes * fixedWidthAtts = [AMFontAttributes fontAttributesWithName:kAMFactorySettingFontNameForFixedWidthText size:kAMFactorySettingFixedWidthFontSize bold:NO italic:NO allowSynthesis:kAMFactorySettingAllowFontSynthesis];
    
    NSMutableDictionary * dictionary = self.fontAttributesDictionary;
    
    [dictionary setObject:literalsAtts   forKey:kAMFontAttributesForLiteralsKey];
    [dictionary setObject:algebraAtts    forKey:kAMFontAttributesForAlgebraKey];
    [dictionary setObject:vectorAtts     forKey:kAMFontAttributesForVectorsKey];
    [dictionary setObject:matricesAtts   forKey:kAMFontAttributesForMatricesKey];
    [dictionary setObject:symbolsAtts    forKey:kAMFontAttributesForSymbolsKey];
    [dictionary setObject:textAtts       forKey:kAMFontAttributesForTextKey];
    [dictionary setObject:fixedWidthAtts forKey:kAMFontAttributesForFixedWidthTextKey];
    
    // Non-AMFontAttributes properties
    self.fontSize = kAMFactorySettingFontSize;
    self.fixedWidthFontSize = kAMFactorySettingFixedWidthFontSize;
    self.allowFontSynthesis = kAMFactorySettingAllowFontSynthesis;
    
    return self;
}

#pragma mark - NSCopying -
-(id)copyWithZone:(NSZone *)zone
{
    AMFontSettings * copy = [super copyWithZone:zone];
    copy.fixedWidthFontSize = self.fixedWidthFontSize;
    copy.fontSize = self.fontSize;
    copy.fontAttributesDictionary = [self.fontAttributesDictionary copy];
    return copy;
}

#pragma mark - NSCoding -
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFloat:self.fixedWidthFontSize forKey:kAMFixedWidthFontSizeKey];
    [aCoder encodeFloat:self.fontSize forKey:kAMFontSizeKey];
    [aCoder encodeObject:self.fontAttributesDictionary forKey:@"kAMFontAttributesKey"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.fixedWidthFontSize = [aDecoder decodeFloatForKey:kAMFixedWidthFontSizeKey];
        self.fontSize = [aDecoder decodeFloatForKey:kAMFontSizeKey];
        self.fontAttributesDictionary = [aDecoder decodeObjectForKey:@"kAMFontAttributesKey"];
    }
    return self;
}

#pragma mark - getters and setters -
-(void)setFontAttributesDictionary:(NSMutableDictionary *)fontAttributesDictionary
{
    _fontAttributesDictionary = fontAttributesDictionary;
}
-(NSMutableDictionary *)fontAttributesDictionary
{
    if (!_fontAttributesDictionary) {
        _fontAttributesDictionary = [NSMutableDictionary dictionary];
        for ( NSString * key in [self.class arrayOfFontTypeKeys] ) {
            _fontAttributesDictionary[key] = [[AMFontAttributes alloc] init];
        }
    }
    return _fontAttributesDictionary;
}
-(AMFontAttributes*)fontAttributesForFontType:(AMFontType)fontType
{
    AMFontAttributes * attrs = self.fontAttributesDictionary[[self keyForFontType:fontType]];
    return attrs;
}
-(void)setFontAttributes:(AMFontAttributes*)attributes forFontType:(AMFontType)fontType
{
    self.fontAttributesDictionary[[self keyForFontType:fontType]] = attributes;
}

#pragma mark - Keys for types and types for keys -
-(NSString*)keyForFontType:(AMFontType)fontType
{
    return [self.class keyForFontType:fontType];
}
+(NSString*)keyForFontType:(AMFontType)fontType
{
    switch (fontType) {
        case AMFontTypeAlgebra:
            return kAMFontAttributesForAlgebraKey;
        case AMFontTypeFixedWidth:
            return kAMFontAttributesForFixedWidthTextKey;
        case AMFontTypeLiteral:
            return kAMFontAttributesForLiteralsKey;
        case AMFontTypeMatrix:
            return kAMFontAttributesForMatricesKey;
        case AMFontTypeSymbol:
            return kAMFontAttributesForSymbolsKey;
        case AMFontTypeText:
            return kAMFontAttributesForTextKey;
        case AMFontTypeVector:
            return kAMFontAttributesForVectorsKey;
    }
}
-(AMFontType)fontTypeForKey:(NSString*)key
{
    return [self.class fontTypeForKey:key];
}
+(AMFontType)fontTypeForKey:(NSString*)key
{
    if ([key isEqualToString:kAMFontAttributesForAlgebraKey]) {
        return AMFontTypeAlgebra;
    }
    if ([key isEqualToString:kAMFontAttributesForFixedWidthTextKey]) {
        return AMFontTypeFixedWidth;
    }
    if ([key isEqualToString:kAMFontAttributesForLiteralsKey]) {
        return AMFontTypeLiteral;
    }
    if ([key isEqualToString:kAMFontAttributesForMatricesKey]) {
        return AMFontTypeMatrix;
    }
    if ([key isEqualToString:kAMFontAttributesForSymbolsKey]) {
        return AMFontTypeSymbol;
    }
    if ([key isEqualToString:kAMFontAttributesForTextKey]) {
        return AMFontTypeText;
    }
    if ([key isEqualToString:kAMFontAttributesForVectorsKey]) {
        return AMFontTypeVector;
    }
    NSAssert(NO, @"Unknown key: %@",key);
    return AMFontTypeAlgebra;
}

static NSArray * _arrayOfFontTypes;
-(NSArray *)arrayOfFontTypes
{
    return [self.class arrayOfFontTypes];
}
+(NSArray *)arrayOfFontTypes
{
    if (!_arrayOfFontTypes) {
        _arrayOfFontTypes = @[
                              @(AMFontTypeLiteral),
                              @(AMFontTypeAlgebra),
                              @(AMFontTypeVector),
                              @(AMFontTypeMatrix),
                              @(AMFontTypeSymbol),
                              @(AMFontTypeText),
                              @(AMFontTypeFixedWidth),
                              ];
    }
    return _arrayOfFontTypes;
}
+(NSArray*)arrayOfFontTypeKeys
{
    return @[kAMFontAttributesForAlgebraKey,
             kAMFontAttributesForFixedWidthTextKey,
             kAMFontAttributesForLiteralsKey,
             kAMFontAttributesForMatricesKey,
             kAMFontAttributesForSymbolsKey,
             kAMFontAttributesForTextKey,
             kAMFontAttributesForVectorsKey];
}












@end
