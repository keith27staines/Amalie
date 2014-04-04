//
//  AMPageSettings.m
//  Amalie
//
//  Created by Keith Staines on 02/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMPageSettings.h"

@implementation AMPageSettings

/*! Subclasses must override */
-(instancetype)initWithFactoryDefaults
{
    self = [super initWithFactoryDefaults];
    if (!self) {
        return nil;
    }
//    // Paper size and margins
//    [defaults setObject:@(AMPaperTypeA4) forKey:kAMPaperSizeKey];
//    [defaults setObject:@(kAMPageWidthA4) forKey:kAMPageWidthCustomKey];
//    [defaults setObject:@(kAMPageHeightA4) forKey:kAMPageHeightCustomKey];
//    [defaults setObject:@(AMPaperOrientationPortrait) forKey:kAMPageOrientationKey];
//    [defaults setObject:@(AMMeasurementUnitsPoints) forKey:kAMPaperMeasurementUnitsKey];
//    
//    AMMargins margins = AMMarginsMake(72, 72, 72, 72);
//    [defaults setObject:[self NSStringFromAMMargins:margins] forKey:kAMPageMarginsKey];

    return self;
}
/*! Subclasses must override */
-(AMSettingsSectionType)section
{
    return AMSettingsSectionPaper;
}
-(id)copyWithZone:(NSZone *)zone
{
    AMPageSettings * copy = [super copyWithZone:zone];
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


@end
