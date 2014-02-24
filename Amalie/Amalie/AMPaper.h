//
//  AMPaper.h
//  Amalie
//
//  Created by Keith Staines on 24/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMConstants.h"

@interface AMPaper : NSObject

+(AMPaper*)paperWithType:(AMPaperType)paperType orientation:(AMPaperOrientation)orientation;
-(id)initWithType:(AMPaperType)type orientation:(AMPaperOrientation)orientation;

+(NSString*)paperNameForPaperType:(AMPaperType)paperType;
+(NSArray*)paperNames;
+(NSString*)paperOrientationNameForOrientationType:(AMPaperOrientation)orientation;
+(NSSize)paperSizeForPaperType:(AMPaperType)paperType withOrientation:(AMPaperOrientation)orientation inUnits:(AMMeasurementUnits)units;

-(void)makeCustomWidth:(CGFloat)width height:(CGFloat)height;
/*!
 Format is (width unit height+unit), so e.g,
 (21cm x 30cm)
 */
+(NSString*)paperSizeDescriptionForPaperType:(AMPaperType)paperType withOrientation:(AMPaperOrientation)orientation inUnits:(AMMeasurementUnits)units;
-(NSString*)paperSizeDescription;

@property AMPaperType                paperType;
@property AMPaperOrientation         paperOrientation;
@property (readonly,copy) NSString * paperName;
@property (readonly,copy) NSString * paperDescription;
@property (readonly,copy) NSString * paperOrientationName;
@property (readonly)      NSSize     paperSize;
@property (readwrite) AMMeasurementUnits paperMeasurementUnits;
@end
