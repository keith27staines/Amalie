//
//  AMMathStyleSettings.m
//  Amalie
//
//  Created by Keith Staines on 02/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMMathStyleSettings.h"

@interface AMMathStyleSettings()
{
    CGFloat _superscriptingFraction;
    CGFloat _superscriptOffset;
    CGFloat _subscriptOffset;
    CGFloat _smallestFontSize;
}

@end

@implementation AMMathStyleSettings

#pragma mark - AMSettingsSection essential overrides -
-(instancetype)initWithFactoryDefaults
{
    self = [super initWithFactoryDefaults];
    if (!self) {
        return nil;
    }
    self.smallestFontSize = kAMFactorySettingMinFontSize;
    self.superscriptingFraction = kAMFactorySettingSuperscriptingFraction;
    self.subscriptOffset = kAMFactorySettingSuperscriptOffset;
    self.superscriptOffset = kAMFactorySettingSuperscriptOffset;
    return self;
}
-(AMSettingsSectionType)section
{
    return AMSettingsSectionMathsStyle;
}
-(id)copyWithZone:(NSZone *)zone
{
    AMMathStyleSettings * copy  = [super copyWithZone:zone];
    copy.superscriptingFraction = self.superscriptingFraction;
    copy.smallestFontSize       = self.smallestFontSize;
    copy.superscriptOffset      = self.superscriptOffset;
    copy.subscriptOffset        = self.subscriptOffset;
    return copy;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.superscriptOffset = [aDecoder decodeFloatForKey:kAMSuperscriptOffsetKey];
        self.subscriptOffset   = [aDecoder decodeFloatForKey:kAMSubscriptOffsetKey];
        self.smallestFontSize  = [aDecoder decodeIntegerForKey:kAMMinFontSizeKey];
        self.superscriptingFraction = [aDecoder decodeFloatForKey:kAMSuperscriptingFractionKey];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFloat:self.superscriptOffset forKey:kAMSuperscriptOffsetKey];
    [aCoder encodeFloat:self.subscriptOffset forKey:kAMSubscriptOffsetKey];
    [aCoder encodeInteger:self.smallestFontSize forKey:kAMMinFontSizeKey];
    [aCoder encodeFloat:self.superscriptingFraction forKey:kAMSuperscriptingFractionKey];
}

#pragma mark - AMMathStyleSettings -


@end
