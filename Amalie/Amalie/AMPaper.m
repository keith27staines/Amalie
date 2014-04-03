//
//  AMPaper.m
//  Amalie
//
//  Created by Keith Staines on 24/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMPaper.h"
#import "AMMeasurement.h"
#import "AMUserPreferences.h"

@interface AMPaper()
{
    AMPaperType        _paperType;
    AMPaperOrientation _paperOrientation;
    AMMeasurementUnits _paperMeasurementUnits;
    NSSize             _customSize;
    AMMargins          _margins;
}
@property NSSize customSize;
@end

@implementation AMPaper

- (instancetype)init
{
    self = [super init];
    if (self) {
        _paperType = [AMUserPreferences paperType];
        _paperOrientation = [AMUserPreferences paperOrientation];
        _margins = [AMUserPreferences pageMargins];
        _paperMeasurementUnits = [AMUserPreferences paperMeasurementUnits];
        if (_paperType != AMPaperTypeCustom) {
            self.customSize = [AMUserPreferences pageSize];
        }
    }
    return self;
}
-(void)writeToAMPreferences
{
    [AMUserPreferences setPaperType:self.paperType];
    [AMUserPreferences setPaperOrientation:self.paperOrientation];
    [AMUserPreferences setPageMargins:[self marginsInUnits:AMMeasurementUnitsPoints]];
    [AMUserPreferences setPaperMeasurementUnits:self.paperMeasurementUnits];
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
    return [AMMeasurement convertMargins:_margins fromUnits:AMMeasurementUnitsPoints toUnits:units];
}
-(void)setMargins:(AMMargins)margins inUnits:(AMMeasurementUnits)units
{
    _margins = [AMMeasurement convertMargins:margins fromUnits:units toUnits:AMMeasurementUnitsPoints];
}
-(NSSize)sizeInUnits:(AMMeasurementUnits)units
{
    NSSize size;
    if (self.paperType != AMPaperTypeCustom) {
        size = [AMPaper paperSizeForPaperType:self.paperType withOrientation:self.paperOrientation inUnits:AMMeasurementUnitsPoints];
    } else {
        size = self.customSize;
    }
    return [AMMeasurement convertSize:size fromUnits:AMMeasurementUnitsPoints toUnits:units];
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


#pragma mark - NSCoding protocol
static NSString * const AMPaperTypeKey = @"AMPaperTypeKey";
static NSString * const AMPaperOrientationKey = @"AMPaperOrientationKey";
static NSString * const AMPaperMeasurementUnitsKey = @"AMPaperMeasurementUnitsKey";
static NSString * const AMPaperCustomSizeKey = @"AMPaperCustomSizeKey";
static NSString * const AMPaperMarginTopKey = @"AMPaperMarginTopKey";
static NSString * const AMPaperMarginBottomKey = @"AMPaperMarginBottomKey";
static NSString * const AMPaperMarginLeftKey = @"AMPaperMarginLeftKey";
static NSString * const AMPaperMarginRightKey = @"AMPaperMarginRightKey";

-(id)initWithCoder:(NSCoder *)decoder
{
    _paperType = [decoder decodeIntegerForKey:@"AMPaperTypeKey"];
    _paperOrientation      = [decoder decodeIntegerForKey:@"AMPaperOrientationKey"];
    _paperMeasurementUnits = [decoder decodeIntegerForKey:@"AMPaperMeasurementUnitsKey"];
    _customSize            = [decoder decodeSizeForKey:@"AMPaperCustomSizeKey"];
    _margins.top           = [decoder decodeFloatForKey:@"AMPaperMarginTopKey"];
    _margins.bottom        = [decoder decodeFloatForKey:@"AMPaperMarginBottomKey"];
    _margins.left          = [decoder decodeFloatForKey:@"AMPaperMarginLeftKey"];
    _margins.right         = [decoder decodeFloatForKey:@"AMPaperMarginRightKey"];
    return self;
}
-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInteger:_paperType forKey:@"AMPaperTypeKey"];
    [coder encodeInteger:_paperOrientation forKey:@"AMPaperOrientationKey"];
    [coder encodeInteger:_paperMeasurementUnits forKey:@"AMPaperMeasurementUnitsKey"];
    [coder encodeSize:_customSize forKey:@"AMPaperCustomSizeKey"];
    [coder encodeFloat:_margins.top forKey:@"AMPaperMarginTopKey"];
    [coder encodeFloat:_margins.bottom forKey:@"AMPaperMarginBottomKey"];
    [coder encodeFloat:_margins.left forKey:@"AMPaperMarginLeftKey"];
    [coder encodeFloat:_margins.right forKey:@"AMPaperMarginRightKey"];
}

#pragma mark - NSCopying protocol
-(id)copyWithZone:(NSZone *)zone
{
    AMPaper * copy = [[AMPaper alloc] init];
    if (copy) {
        copy.paperType = self.paperType;
        copy.paperOrientation = self.paperOrientation;
        copy.paperMeasurementUnits = self.paperMeasurementUnits;
        copy.customSize = self.customSize;
        [copy setMargins:[self marginsInUnits:AMMeasurementUnitsPoints] inUnits:AMMeasurementUnitsPoints];
    }
    return copy;
}




























@end
