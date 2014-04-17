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
    CGFloat _superscriptOffsetFraction;
    CGFloat _subscriptOffsetFraction;
    CGFloat _smallestFontSizeFraction;
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
    self.smallestFontSizeFraction  = kAMFactorySettingMinFontSizeFraction;
    self.superscriptingFraction    = kAMFactorySettingSuperscriptingFraction;
    self.subscriptOffsetFraction   = kAMFactorySettingSuperscriptOffsetFraction;
    self.superscriptOffsetFraction = kAMFactorySettingSuperscriptOffsetFraction;
    return self;
}
-(AMSettingsSectionType)section
{
    return AMSettingsSectionMathsStyle;
}
-(id)copyWithZone:(NSZone *)zone
{
    AMMathStyleSettings * copy          = [super copyWithZone:zone];
    copy.superscriptingFraction         = self.superscriptingFraction;
    copy.smallestFontSizeFraction       = self.smallestFontSizeFraction;
    copy.superscriptOffsetFraction      = self.superscriptOffsetFraction;
    copy.subscriptOffsetFraction        = self.subscriptOffsetFraction;
    return copy;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.superscriptOffsetFraction = [aDecoder decodeFloatForKey:kAMSuperscriptOffsetKey];
        self.subscriptOffsetFraction   = [aDecoder decodeFloatForKey:kAMSubscriptOffsetKey];
        self.smallestFontSizeFraction  = [aDecoder decodeFloatForKey:kAMMinFontSizeKey];
        self.superscriptingFraction    = [aDecoder decodeFloatForKey:kAMSuperscriptingFractionKey];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFloat:self.superscriptOffsetFraction forKey:kAMSuperscriptOffsetKey];
    [aCoder encodeFloat:self.subscriptOffsetFraction forKey:kAMSubscriptOffsetKey];
    [aCoder encodeFloat:self.smallestFontSizeFraction forKey:kAMMinFontSizeKey];
    [aCoder encodeFloat:self.superscriptingFraction forKey:kAMSuperscriptingFractionKey];
}

#pragma mark - AMMathStyleSettings -


@end
