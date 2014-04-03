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
//    // Paper size and margins
//    [defaults setObject:@(AMPaperTypeA4) forKey:kAMPaperSizeKey];
//    [defaults setObject:@(kAMPageWidthA4) forKey:kAMPageWidthCustomKey];
//    [defaults setObject:@(kAMPageHeightA4) forKey:kAMPageHeightCustomKey];
//    [defaults setObject:@(AMPaperOrientationPortrait) forKey:kAMPageOrientationKey];
//    [defaults setObject:@(AMMeasurementUnitsPoints) forKey:kAMPaperMeasurementUnitsKey];
//    
//    AMMargins margins = AMMarginsMake(72, 72, 72, 72);
//    [defaults setObject:[self NSStringFromAMMargins:margins] forKey:kAMPageMarginsKey];

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


@end
