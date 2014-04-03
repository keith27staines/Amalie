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
//    // Mathematical typography style
//    [defaults setObject:@(kAMFactorySettingMinFontSize) forKey:kAMMinFontSizeKey];
//    [defaults setObject:@(kAMFactorySettingSuperscriptingFraction) forKey:kAMSuperscriptingFractionKey];
//    [defaults setObject:@(kAMFactorySettingSuperscriptOffset) forKey:kAMSuperscriptOffsetKey];
//    [defaults setObject:@(kAMFactorySettingSubscriptOffset) forKey:kAMSubscriptOffsetKey];
//    [defaults setObject:@(YES) forKey:kAMAllowFontSynthesisKey];
    [NSException raise:@"Missing implemetation" format:@"Derived classes must override this method"];
    return nil;
}
-(AMSettingsSectionType)section
{
    [NSException raise:@"Missing implementation" format:@"Derived classes must override this method"];
    return 0;
}
-(id)copyWithZone:(NSZone *)zone
{
    [NSException raise:@"Missing implementation" format:@"Derived classes must override this method"];
    return nil;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    [NSException raise:@"Missing implementation" format:@"Derived classes must override this method"];
    return nil;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [NSException raise:@"Missing implementation" format:@"Derived classes must override this method"];
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
