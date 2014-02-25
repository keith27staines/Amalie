//
//  AMPageOrientationViewDatasource.h
//  Amalie
//
//  Created by Keith Staines on 24/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMConstants.h"

@protocol AMPageSetupDatasource <NSObject>

-(AMPaperType)paperType;
-(NSString*)paperName;
-(NSString*)paperDescription;
-(NSString*)paperSizeDescription;
-(NSString*)paperWidthDescription;
-(NSString*)paperHeightDescription;
-(NSSize)paperSize;
-(AMPaperOrientation)paperOrientation;
-(NSString*)paperOrientationName;
-(AMMeasurementUnits)paperMeasurementUnits;
-(AMMargins)paperMargins;

@end
