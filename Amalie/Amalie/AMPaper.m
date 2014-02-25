//
//  AMPaper.m
//  Amalie
//
//  Created by Keith Staines on 24/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMPaper.h"
#import "AMMeasurement.h"

@interface AMPaper()
{
    AMPaperType        _paperType;
    AMPaperOrientation _orientation;
    AMMeasurementUnits _measurementUnits;
    NSSize             _customSize;
    AMMargins          _margins;
}
@property NSSize customSize;
@end

@implementation AMPaper

- (instancetype)init
{
    return [self initWithType:AMPaperTypeA4 orientation:AMPaperOrientationPortrait];
}
+(AMPaper*)paperWithType:(AMPaperType)paperType orientation:(AMPaperOrientation)orientation
{
    return [[AMPaper alloc] initWithType:paperType orientation:orientation];
}
-(id)initWithType:(AMPaperType)paperType orientation:(AMPaperOrientation)orientation
{
    self = [super init];
    if (self) {
        _paperType = paperType;
        _orientation = orientation;
        if (_paperType != AMPaperTypeCustom) {
            self.customSize = self.paperSize;
        }
    }
    return self;
}

-(NSString*)paperName
{
    return [AMPaper paperNameForPaperType:self.paperType];
}
-(NSString *)paperOrientationName
{
    return [AMPaper paperOrientationNameForOrientationType:self.paperOrientation];
}
/*! sets the custom height and width in portrait mode */
-(void)makeCustomPortraitWidth:(CGFloat)width portraitHeight:(CGFloat)height
{
    self.paperType = AMPaperTypeCustom;
    _customSize = NSMakeSize(width, height);
}
-(NSSize)customSize
{
    return _customSize;
}
-(void)setCustomSize:(NSSize)size
{
    _customSize = size;
}
-(NSSize)paperSize
{
    return [self sizeInUnits:self.paperMeasurementUnits];
}
-(AMMargins)marginsInUnits:(AMMeasurementUnits)units
{
    return _margins;
}
-(void)setMargins:(AMMargins)margins inUnits:(AMMeasurementUnits)units
{
    
}
-(NSSize)sizeInUnits:(AMMeasurementUnits)units
{
    if (self.paperType != AMPaperTypeCustom) {
        return [AMPaper paperSizeForPaperType:self.paperType withOrientation:self.paperOrientation inUnits:units];
    } else {
        NSSize size;
        if (self.paperOrientation == AMPaperOrientationPortrait) {
            size = self.customSize;
        } else {
            size = NSMakeSize(self.customSize.height, self.customSize.width);
        }
        return [AMMeasurement convertSize:size fromUnits:AMMeasurementUnitsPoints toUnits:units];
    }
}
-(NSString*)paperDescription
{
    return [NSString stringWithFormat:@"%@ - %@ %@",self.paperName,self.paperOrientationName,[self paperSizeDescription]];
}
/*!
 Format is (width unit height+unit), so e.g,
 (21cm x 30cm)
 */
+(NSString*)paperSizeDescriptionForPaperType:(AMPaperType)paperType withOrientation:(AMPaperOrientation)orientation inUnits:(AMMeasurementUnits)units
{
    NSSize size = [self paperSizeForPaperType:paperType withOrientation:orientation inUnits:units];
    int width = round(size.width);
    int height = round(size.height);
    return [self paperSizeFormattedStringWithUnits:units width:width height:height];
}
+(NSString*)paperSizeDescriptionForPaperWithPortraitSize:(NSSize)size inOrientation:(AMPaperOrientation)orientation inUnits:(AMMeasurementUnits)units
{
    int width;
    int height;
    if (orientation == AMPaperOrientationLandscape) {
        width = round(size.width);
        height = round(size.height);
    } else {
        width = round(size.height);
        height = round(size.width);
    }
    return [self paperSizeFormattedStringWithUnits:units width:width height:height];
}
+(NSString*)paperSizeFormattedStringWithUnits:(AMMeasurementUnits)units width:(int)width height:(int)height
{
    NSString * unit = [AMMeasurement abbreviatedMameForUnitType:units];
    return [NSString stringWithFormat:@"(%i%@ x %i%@)",width,unit,height,unit];
}
-(NSString*)paperSizeDescription
{
    if (self.paperType == AMPaperTypeCustom) {
        return [AMPaper paperSizeDescriptionForPaperWithPortraitSize:self.customSize inOrientation:self.paperOrientation inUnits:self.paperMeasurementUnits];
    } else {
        return [AMPaper paperSizeDescriptionForPaperType:self.paperType withOrientation:self.paperOrientation inUnits:self.paperMeasurementUnits];
    }
}
-(NSString*)paperWidthDescription
{
    return [AMPaper paperWidthDescriptionForPaperType:self.paperType withOrientation:self.paperOrientation inUnits:self.paperMeasurementUnits];
}
-(NSString*)paperHeightDescription
{
    return [AMPaper paperHeightDescriptionForPaperType:self.paperType withOrientation:self.paperOrientation inUnits:self.paperMeasurementUnits];
}
+(NSString*)paperWidthDescriptionForPaperType:(AMPaperType)paperType withOrientation:(AMPaperOrientation)orientation inUnits:(AMMeasurementUnits)units
{
    NSSize size = [self paperSizeForPaperType:paperType withOrientation:orientation inUnits:units];
    int width = round(size.width);
    NSString * unit = [AMMeasurement abbreviatedMameForUnitType:units];
    return [NSString stringWithFormat:@"%i %@",width,unit];
}
+(NSString*)paperHeightDescriptionForPaperType:(AMPaperType)paperType withOrientation:(AMPaperOrientation)orientation inUnits:(AMMeasurementUnits)units
{
    NSSize size = [self paperSizeForPaperType:paperType withOrientation:orientation inUnits:units];
    int height = round(size.height);
    NSString * unit = [AMMeasurement abbreviatedMameForUnitType:units];
    return [NSString stringWithFormat:@"%i %@",height,unit];
}
-(NSString*)description
{
    return [self paperDescription];
}
+(NSString *)paperNameForPaperType:(AMPaperType)paperType
{
    return [self paperNames][paperType];
}
+(NSArray*)paperNames
{
    return @[NSLocalizedString(@"A0", @"ISO Paper size A0"),
             NSLocalizedString(@"A1", @"ISO Paper size A1"),
             NSLocalizedString(@"A2", @"ISO Paper size A2"),
             NSLocalizedString(@"A3", @"ISO Paper size A3"),
             NSLocalizedString(@"A4", @"ISO Paper size A4"),
             NSLocalizedString(@"A5", @"ISO Paper size A5"),
             NSLocalizedString(@"A6", @"ISO Paper size A6"),
             NSLocalizedString(@"B4", @"ISO Paper size B4"),
             NSLocalizedString(@"B5", @"ISO Paper size B5"),
             NSLocalizedString(@"US Legal", @"US 'legal' paper size"),
             NSLocalizedString(@"US Letter", @"US 'letter' paper size"),
             NSLocalizedString(@"Custom", @"Custom paper type")
             ];
}

+(NSString*)paperOrientationNameForOrientationType:(AMPaperOrientation)orientation
{
    return [self paperOrientationNames][orientation];
}
+(NSArray*)paperOrientationNames
{
    return @[NSLocalizedString(@"portrait", @"Paper orientation 'portrait'"),
             NSLocalizedString(@"landscape", @"Paper orientation 'landscape'")];
}
+(NSSize)paperSizeForPaperType:(AMPaperType)paperType withOrientation:(AMPaperOrientation)orientation inUnits:(AMMeasurementUnits)units
{
    NSSize size;
    switch (paperType) {
        case AMPaperTypeA0:
            size = NSMakeSize(kAMPageWidthA0, kAMPageHeightA0);
            break;
        case AMPaperTypeA1:
            size = NSMakeSize(kAMPageWidthA1, kAMPageHeightA1);
            break;
        case AMPaperTypeA2:
            size = NSMakeSize(kAMPageWidthA2, kAMPageHeightA2);
            break;
        case AMPaperTypeA3:
            size = NSMakeSize(kAMPageWidthA3, kAMPageHeightA3);
            break;
        case AMPaperTypeA4:
            size = NSMakeSize(kAMPageWidthA4, kAMPageHeightA4);
            break;
        case AMPaperTypeA5:
            size = NSMakeSize(kAMPageWidthA5, kAMPageHeightA5);
            break;
        case AMPaperTypeA6:
            size = NSMakeSize(kAMPageWidthA6, kAMPageHeightA6);
            break;
        case AMPaperTypeB4:
            size = NSMakeSize(kAMPageWidthB4, kAMPageHeightB4);
            break;
        case AMPaperTypeB5:
            size = NSMakeSize(kAMPageWidthB5, kAMPageHeightB5);
            break;
        case AMPaperTypeUSLegal:
            size = NSMakeSize(kAMPageWidthUSLegal, kAMPageHeightUSLegal);
            break;
        case AMPaperTypeUSLetter:
            size = NSMakeSize(kAMPageWidthUSLetter, kAMPageHeightUSLetter);
            break;
        case AMPaperTypeCustom:
            size = NSMakeSize(0, 0);
            break;
    }
    return [AMMeasurement convertSize:size fromUnits:AMMeasurementUnitsPoints toUnits:units];
}

@end
