//
//  AMMeasurement.h
//  Amalie
//
//  Created by Keith Staines on 24/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMConstants.h"

@interface AMMeasurement : NSObject

+(NSString*)nameForUnitType:(AMMeasurementUnits)unitType;
+(NSArray*)namesForUnitTypes;

+(NSString *)abbreviatedMameForUnitType:(AMMeasurementUnits)unitType;

+(NSSize)convertSize:(NSSize)size fromUnits:(AMMeasurementUnits)originalUnits toUnits:(AMMeasurementUnits)finalUnits;

+(CGFloat)convertLength:(CGFloat)length fromUnits:(AMMeasurementUnits)originalUnits toUnits:(AMMeasurementUnits)finalUnits;

+(AMMargins)convertMargins:(AMMargins)margins fromUnits:(AMMeasurementUnits)originalUnits toUnits:(AMMeasurementUnits)finalUnits;

+(CGFloat)conversionFactorFromUnits:(AMMeasurementUnits)originalUnits toUnits:(AMMeasurementUnits)finalUnits;


@end
