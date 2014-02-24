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
    CGFloat            _customWidth;
    CGFloat            _customHeight;
}
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
-(void)makeCustomWidth:(CGFloat)width height:(CGFloat)height
{
    self.paperType = AMPaperTypeCustom;
    _customWidth = width;
    _customHeight = height;
}

-(NSSize)paperSize
{
    return [self sizeInUnits:self.paperMeasurementUnits];
}
-(NSSize)sizeInUnits:(AMMeasurementUnits)units
{
    return [AMPaper paperSizeForPaperType:self.paperType withOrientation:self.paperOrientation inUnits:units];
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
    NSString * unit = [AMMeasurement abbreviatedMameForUnitType:units];
    return [NSString stringWithFormat:@"(%i%@ x %i%@)",width,unit,height,unit];
}
-(NSString*)paperSizeDescription
{
    return [AMPaper paperSizeDescriptionForPaperType:self.paperType withOrientation:self.paperOrientation inUnits:self.paperMeasurementUnits];
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
    switch (orientation) {
        case AMPaperOrientationPortrait:
            return NSLocalizedString(@"portrait", @"Paper orientation 'portrait'");
        case AMPaperOrientationLandscape:
            return NSLocalizedString(@"landscape", @"Paper orientation 'landscape'");
    }
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
