//
//  AMPageSettings.h
//  Amalie
//
//  Created by Keith Staines on 02/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMSettingsSection.h"

@interface AMPageSettings : AMSettingsSection <NSCopying, NSCoding>
+(NSSize)paperSizeForPaperType:(AMPaperType)paperType withOrientation:(AMPaperOrientation)orientation inUnits:(AMMeasurementUnits)units;

-(void)makeCustomPortraitWidth:(CGFloat)width portraitHeight:(CGFloat)height;

@property AMPaperType                paperType;
@property AMPaperOrientation         paperOrientation;
@property (readonly)      NSSize     paperSize;
@property (readwrite) AMMeasurementUnits paperMeasurementUnits;

-(AMMargins)marginsInUnits:(AMMeasurementUnits)units;
-(void)setMargins:(AMMargins)margins inUnits:(AMMeasurementUnits)units;

#pragma mark - Names and descriptions -
@property (readonly,copy) NSString * paperName;
@property (readonly,copy) NSString * paperDescription;
@property (readonly,copy) NSString * paperOrientationName;

+(NSString*)paperNameForPaperType:(AMPaperType)paperType;
+(NSArray*)paperNames;
+(NSString*)paperOrientationNameForOrientationType:(AMPaperOrientation)orientation;
+(NSArray*)paperOrientationNames;

/*! Format is (width unit height+unit), so e.g, (21cm x 30cm) */
+(NSString*)paperSizeDescriptionForPaperType:(AMPaperType)paperType withOrientation:(AMPaperOrientation)orientation inUnits:(AMMeasurementUnits)units;
/*! Format is e.g, 21 cm */
+(NSString*)paperWidthDescriptionForPaperType:(AMPaperType)paperType withOrientation:(AMPaperOrientation)orientation inUnits:(AMMeasurementUnits)units;
/*! Format is e.g, 30 cm */
+(NSString*)paperHeightDescriptionForPaperType:(AMPaperType)paperType withOrientation:(AMPaperOrientation)orientation inUnits:(AMMeasurementUnits)units;
+(NSString*)paperSizeDescriptionForPaperWithPortraitSize:(NSSize)size inOrientation:(AMPaperOrientation)orientation inUnits:(AMMeasurementUnits)units;
/*! Format is (width unit height+unit), so e.g, (21cm x 30cm) */
-(NSString*)paperSizeDescription;
/*! Format is e.g, 21 cm */
-(NSString*)paperWidthDescription;
/*! Format is e.g, 30 cm */
-(NSString*)paperHeightDescription;



@end
