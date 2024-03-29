//
//  AMMeasurement.m
//  Amalie
//
//  Created by Keith Staines on 24/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMMeasurement.h"

@implementation AMMeasurement

+(NSString *)nameForUnitType:(AMMeasurementUnits)unitType
{
    return [self namesForUnitTypes][unitType];
}
+(NSArray *)namesForUnitTypes
{
    return @[NSLocalizedString(@"Points", @"A point being the unit of length = 1/72 inch"),
             NSLocalizedString(@"Millimeters", @"but millimetres in UK English, etc"),
             NSLocalizedString(@"Centimeters", @"but centimetres in UK English, etc."),
             NSLocalizedString(@"Inches",nil)];
}
+(NSString *)abbreviatedMameForUnitType:(AMMeasurementUnits)unitType
{
    NSString * name;
    switch (unitType) {
        case AMMeasurementUnitsCentimeters:
            name = NSLocalizedString(@"cm", @"local abbreviation for centimetre");
            break;
        case AMMeasurementUnitsMillimeters:
            name = NSLocalizedString(@"mm", @"local abbreviation for millimeter");
            break;
        case AMMeasurementUnitsInches:
            name = NSLocalizedString(@"\"", @"local abbreviation for inch");
            break;
        case AMMeasurementUnitsPoints:
            name = NSLocalizedString(@"pt", nil);
            break;
    }
    return name;
}
+(NSSize)convertSize:(NSSize)size fromUnits:(AMMeasurementUnits)originalUnits toUnits:(AMMeasurementUnits)finalUnits
{
    double conversionFactor = [self conversionFactorFromUnits:originalUnits
                                                      toUnits:finalUnits];
    return NSMakeSize(size.width * conversionFactor, size.height * conversionFactor);
}
+(CGFloat)convertLength:(CGFloat)length fromUnits:(AMMeasurementUnits)originalUnits toUnits:(AMMeasurementUnits)finalUnits
{
    double conversionFactor = [self conversionFactorFromUnits:originalUnits
                                                      toUnits:finalUnits];
    return length * conversionFactor;
}
+(AMMargins)convertMargins:(AMMargins)margins fromUnits:(AMMeasurementUnits)originalUnits toUnits:(AMMeasurementUnits)finalUnits
{
    double conversionFactor = [self conversionFactorFromUnits:originalUnits
                                                      toUnits:finalUnits];
    margins.bottom *= conversionFactor;
    margins.left   *= conversionFactor;
    margins.right  *= conversionFactor;
    margins.top    *= conversionFactor;
    return margins;
}
+(CGFloat)conversionFactorFromUnits:(AMMeasurementUnits)originalUnits toUnits:(AMMeasurementUnits)finalUnits
{
    double conversionFactor;
    switch (originalUnits) {
        case AMMeasurementUnitsPoints:
            conversionFactor = kAMUnitConversionPoints_Points;
            break;
        case AMMeasurementUnitsCentimeters:
            conversionFactor = kAMUnitConversionCM_Points;
            break;
        case AMMeasurementUnitsMillimeters:
            conversionFactor = kAMUnitConversionMM_Points;
            break;
        case AMMeasurementUnitsInches:
            conversionFactor = kAMUnitConversionIn_Points;
            break;
    }
    switch (finalUnits) {
        case AMMeasurementUnitsPoints:
            conversionFactor *= kAMUnitConversionPoints_Points;
            break;
        case AMMeasurementUnitsCentimeters:
            conversionFactor *= kAMUnitConversionPoints_CM;
            break;
        case AMMeasurementUnitsMillimeters:
            conversionFactor *= kAMUnitConversionPoints_MM;
            break;
        case AMMeasurementUnitsInches:
            conversionFactor *= kAMUnitConversionPoints_In;
            break;
    }
    return conversionFactor;
}



















@end
