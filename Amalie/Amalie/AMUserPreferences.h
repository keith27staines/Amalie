//
//  AMUserPreferences.h
//  Amalie
//
//  Created by Keith Staines on 10/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMFontSettings;

#import <Foundation/Foundation.h>
#import "AMConstants.h"

@interface AMUserPreferences : NSObject

#pragma mark - Register factory default settings -
+(void)registerDefaultPreferences;

#pragma mark - Reset settings to factory defaults -


#pragma mark - Getters and setters for user preferences -
#pragma mark - Page layout
+(AMPaperType)paperType;
+(void)setPaperType:(AMPaperType)paperType;
+(AMPaperOrientation)paperOrientation;
+(void)setPaperOrientation:(AMPaperOrientation)paperOrientation;
+(AMMargins)pageMargins;
+(void)setPageMargins:(AMMargins)margins;
+(AMMeasurementUnits)paperMeasurementUnits;
+(void)setPaperMeasurementUnits:(AMMeasurementUnits)units;

#pragma mark - Math Style
+(NSUInteger)smallestFontSize;
+(void)setSmallestFontSize:(NSUInteger)size;
+(CGFloat)superscriptingFraction;
+(void)setSuperscriptingFraction:(CGFloat)superscriptingFraction;
+(CGFloat)superscriptOffset;
+(void)setSuperscriptOffset:(CGFloat)offset;
+(CGFloat)subscriptOffset;
+(void)setSubscriptOffset:(CGFloat)offset;

#pragma mark - Misc  -
+(NSSize)pageSize;
+(void)setPageSize:(NSSize)size;

#pragma mark - Getters and setters for entre settings section
+(NSData*)dataForSettingsSection:(AMSettingsSectionType)section;
+(void)setData:(NSData*)data forSettingsSection:(AMSettingsSectionType)section;
+(void)resetSettingsForSection:(AMSettingsSectionType)section;

@end
