//
//  AMMathStyleSettings.m
//  Amalie
//
//  Created by Keith Staines on 02/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMMathStyleSettings.h"

@implementation AMMathStyleSettings

#pragma mark - AMSettingsSection essential overrides -
-(instancetype)initWithFactoryDefaults
{
    self = [super initWithFactoryDefaults];
    if (!self) {
        return nil;
    }
//    // Mathematical typography style
//    [defaults setObject:@(kAMFactorySettingMinFontSize) forKey:kAMMinFontSizeKey];
//    [defaults setObject:@(kAMFactorySettingSuperscriptingFraction) forKey:kAMSuperscriptingFractionKey];
//    [defaults setObject:@(kAMFactorySettingSuperscriptOffset) forKey:kAMSuperscriptOffsetKey];
//    [defaults setObject:@(kAMFactorySettingSubscriptOffset) forKey:kAMSubscriptOffsetKey];
//    [defaults setObject:@(YES) forKey:kAMAllowFontSynthesisKey];
    return self;
}
-(AMSettingsSectionType)section
{
    return AMSettingsSectionMathsStyle;
}
-(id)copyWithZone:(NSZone *)zone
{
    AMMathStyleSettings * copy = [super copyWithZone:zone];
    return copy;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // TODO: extend
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    // TODO: extend
}

#pragma mark - Added behaviour -
-(CGFloat)superscriptingFraction
{
    // TODO
    return 0;
}
-(CGFloat)superscriptOffset
{
    // TODO
    return 0;
}
-(CGFloat)subscriptOffset
{
    // TODO
    return 0;
}
-(CGFloat)smallestFontSize
{
    // TODO
    return 0;
}

@end
