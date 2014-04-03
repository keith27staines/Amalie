//
//  AMSettingsSection.m
//  Amalie
//
//  Created by Keith Staines on 03/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMSettingsSection.h"
#import "AMUserPreferences.h"
#import "AMFontSettings.h"
#import "AMColorSettings.h"
#import "AMPageSettings.h"
#import "AMMathStyleSettings.h"

@implementation AMSettingsSection

#pragma mark - Abstract methods that must be overridden in subclasses
/*! Subclasses must override */
-(instancetype)initWithFactoryDefaults
{
    [NSException raise:@"Missing implemetation" format:@"Derived classes must override this method"];
    return nil;
}
/*! Subclasses must override */
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
#pragma mark - Default implementations that should not be overridden in subclasses
+(id)settingsWithFactoryDefaultsOfType:(AMSettingsSectionType)sectionType
{
    switch (sectionType) {
        case AMSettingsSectionFonts:
            return [AMFontSettings settingsWithFactoryDefaults];
        case AMSettingsSectionColors:
            return [AMColorSettings settingsWithFactoryDefaults];
        case AMSettingsSectionPaper:
            return [AMPageSettings settingsWithFactoryDefaults];
        case AMSettingsSectionMathsStyle:
            return [AMMathStyleSettings settingsWithFactoryDefaults];
    }
}
+(id)settingsWithUserDefaultsOfType:(AMSettingsSectionType)sectionType
{
    switch (sectionType) {
        case AMSettingsSectionFonts:
            return [AMFontSettings settingsWithUserDefaults];
        case AMSettingsSectionColors:
            return [AMColorSettings settingsWithUserDefaults];
        case AMSettingsSectionPaper:
            return [AMPageSettings settingsWithUserDefaults];
        case AMSettingsSectionMathsStyle:
            return [AMMathStyleSettings settingsWithUserDefaults];
    }
}
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
- (instancetype)initWithUserDefaults
{
    self = [super init];
    if (self) {
        NSData * data = [AMUserPreferences dataForSettingsSection:[self section]];
        self = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return self;
}

-(NSData*)data
{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self];
    return data;
}

@end
