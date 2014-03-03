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
/*! Returns the paper size in portrait orientation */
-(NSSize)paperSize;
/*! Returns the actual orientation type of the paper */
-(AMPaperOrientation)paperOrientation;
/*! Returns the localised name of the paper orientation */
-(NSString*)paperOrientationName;
/*! Returns the type of type of measurement units */
-(AMMeasurementUnits)paperMeasurementUnits;
/*! Returns the widths of the four margins */
-(AMMargins)paperMargins;

@end
