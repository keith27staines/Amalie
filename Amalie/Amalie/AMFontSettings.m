//
//  AMFontSettings.m
//  Amalie
//
//  Created by Keith Staines on 02/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMFontSettings.h"
#import "AMFontAttributes.h"

@interface AMFontSettings()
{
    CGFloat _fontSize;
    CGFloat _fixedWidthFontSize;
    NSMutableDictionary * _fontAttributes;
}
@property (readonly) NSMutableDictionary * fontAttributes;
@end

@implementation AMFontSettings

+(id)settingsWithUserDefaults
{
    return [[self.class alloc] initWithUserDefaults];
}
+(id)settingsWithFactoryDefaults
{
    return [[self.class alloc] initWithFactoryDefaults];
}
-(id)init
{
    return [self initWithFactoryDefaults];
}
- (instancetype)initWithFactoryDefaults
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithUserDefaults
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - getters and setters -
-(NSMutableDictionary *)fontAttributes
{
    if (!_fontAttributes) {
        _fontAttributes = [NSMutableDictionary dictionary];
        for ( NSString * key in [self.class arrayOfFontTypeKeys] ) {
            _fontAttributes[key] = [[AMFontAttributes alloc] init];
        }
    }
    return _fontAttributes;
}
-(AMFontAttributes*)fontAttributesForFontType:(AMFontType)fontType
{
    return self.fontAttributes[[self keyForFontType:fontType]];
}
-(void)setFontAttributes:(AMFontAttributes*)attributes forFontType:(AMFontType)fontType
{
    self.fontAttributes[[self keyForFontType:fontType]] = attributes;
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
#pragma mark - NSCopying -
-(id)copyWithZone:(NSZone *)zone
{
    return [[self.class alloc] init];
}

#pragma mark - NSCoding -
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    return [[self.class alloc] init];
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
