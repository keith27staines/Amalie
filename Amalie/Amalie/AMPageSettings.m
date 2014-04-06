//
//  AMPageSettings.m
//  Amalie
//
//  Created by Keith Staines on 02/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMPageSettings.h"
#import "AMConstants.h"
#import "AMMeasurement.h"

@interface AMPageSettings()
{
    AMPaperType        _paperType;
    AMPaperOrientation _paperOrientation;
    AMMeasurementUnits _paperMeasurementUnits;
    NSSize             _customSize;
    AMMargins          _margins;
}
@property NSSize customSize;
@property AMMargins margins;  // In points
@end

@implementation AMPageSettings

#pragma mark - Essential AMSettingsSection overrides -
-(instancetype)initWithFactoryDefaults
{
    self = [super initWithFactoryDefaults];
    if (!self) {
        return nil;
    }
    NSMutableDictionary * defaults;
    [defaults setObject:@(AMPaperTypeA4) forKey:kAMPaperSizeKey];
    [defaults setObject:@(kAMPageWidthA4) forKey:kAMPageWidthCustomKey];
    [defaults setObject:@(kAMPageHeightA4) forKey:kAMPageHeightCustomKey];
    [defaults setObject:@(AMPaperOrientationPortrait) forKey:kAMPageOrientationKey];
    [defaults setObject:@(AMMeasurementUnitsPoints) forKey:kAMPaperMeasurementUnitsKey];
    
    AMMargins margins = AMMarginsMake(72, 72, 72, 72);
    [defaults setObject:[AMPageSettings NSStringFromAMMargins:margins] forKey:kAMPageMarginsKey];

    return self;
}
-(AMSettingsSectionType)section
{
    return AMSettingsSectionPage;
}

#pragma mark - Class methods
-(NSString*)paperName
{
    return [AMPageSettings paperNameForPaperType:self.paperType];
}
-(NSString *)paperOrientationName
{
    return [AMPageSettings paperOrientationNameForOrientationType:self.paperOrientation];
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
        size = [AMPageSettings paperSizeForPaperType:self.paperType withOrientation:self.paperOrientation inUnits:AMMeasurementUnitsPoints];
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
        return [AMPageSettings paperSizeDescriptionForPaperWithPortraitSize:self.customSize inOrientation:self.paperOrientation inUnits:self.paperMeasurementUnits];
    } else {
        return [AMPageSettings paperSizeDescriptionForPaperType:self.paperType withOrientation:self.paperOrientation inUnits:self.paperMeasurementUnits];
    }
}
-(NSString*)paperWidthDescription
{
    return [AMPageSettings paperWidthDescriptionForPaperType:self.paperType withOrientation:self.paperOrientation inUnits:self.paperMeasurementUnits];
}
-(NSString*)paperHeightDescription
{
    return [AMPageSettings paperHeightDescriptionForPaperType:self.paperType withOrientation:self.paperOrientation inUnits:self.paperMeasurementUnits];
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
#pragma mark - NSCopying protocol
-(id)copyWithZone:(NSZone *)zone
{
    AMPageSettings * copy = [super copyWithZone:zone];
    if (copy) {
        copy.paperType = self.paperType;
        copy.paperOrientation = self.paperOrientation;
        copy.paperMeasurementUnits = self.paperMeasurementUnits;
        copy.customSize = self.customSize;
        [copy setMargins:[self marginsInUnits:AMMeasurementUnitsPoints] inUnits:AMMeasurementUnitsPoints];
    }
    return copy;
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
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.paperType             = [aDecoder decodeIntegerForKey:@"AMPaperTypeKey"];
        self.paperOrientation      = [aDecoder decodeIntegerForKey:@"AMPaperOrientationKey"];
        self.paperMeasurementUnits = [aDecoder decodeIntegerForKey:@"AMPaperMeasurementUnitsKey"];
        self.customSize            = [aDecoder decodeSizeForKey:@"AMPaperCustomSizeKey"];

        self.margins = AMMarginsMake([aDecoder decodeFloatForKey:@"AMPaperMarginLeftKey"],
                                     [aDecoder decodeFloatForKey:@"AMPaperMarginRightKey"],
                                     [aDecoder decodeFloatForKey:@"AMPaperMarginTopKey"],
                                     [aDecoder decodeFloatForKey:@"AMPaperMarginBottomKey"]);
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:self.paperType forKey:@"AMPaperTypeKey"];
    [aCoder encodeInteger:_paperOrientation forKey:@"AMPaperOrientationKey"];
    [aCoder encodeInteger:_paperMeasurementUnits forKey:@"AMPaperMeasurementUnitsKey"];
    [aCoder encodeSize:_customSize forKey:@"AMPaperCustomSizeKey"];
    [aCoder encodeFloat:_margins.top forKey:@"AMPaperMarginTopKey"];
    [aCoder encodeFloat:_margins.bottom forKey:@"AMPaperMarginBottomKey"];
    [aCoder encodeFloat:_margins.left forKey:@"AMPaperMarginLeftKey"];
    [aCoder encodeFloat:_margins.right forKey:@"AMPaperMarginRightKey"];
}

#pragma mark - AMPageSettings -


#pragma mark - Utility methods -
AMMargins AMMarginsFromNSRect(NSRect rect)
{
    return AMMarginsMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

AMMargins AMMarginsMake(CGFloat left, CGFloat right, CGFloat top, CGFloat bottom)
{
    AMMargins margins;
    margins.left = left;
    margins.right = right;
    margins.top = top;
    margins.bottom = bottom;
    return margins;
}

+(AMMargins)AMMarginsFromNSString:(NSString*)string
{
    NSArray * components = [string componentsSeparatedByString:@" "];
    NSString * left   = components[0];
    NSString * right  = components[1];
    NSString * top    = components[2];
    NSString * bottom = components[3];
    return AMMarginsMake(left.doubleValue, right.doubleValue, top.doubleValue, bottom.doubleValue);
}
+(NSString*)NSStringFromAMMargins:(AMMargins)margins
{
    return [NSString stringWithFormat:@"%f %f %f %f", margins.left, margins.right, margins.top, margins.bottom];
}

@end
