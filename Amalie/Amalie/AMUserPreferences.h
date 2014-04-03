//
//  AMUserPreferences.h
//  Amalie
//
//  Created by Keith Staines on 10/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMFontAttributes, AMColorSettings;

#import <Foundation/Foundation.h>
#import "AMConstants.h"

@interface AMUserPreferences : NSObject

#pragma mark - Register factory default settings -
+(void)registerDefaultPreferences;

#pragma mark - Reset settings to factory defaults -
+(void)resetAll;
+(void)resetPaperType;
+(void)resetPaperOrientation;
+(void)resetPageMargins;
+(void)resetFontAttributesForFontType:(AMFontType)fontType;
+(void)resetFontSize;
+(void)resetSmallestFontSize;
+(void)resetFixedWidthFontSize;
+(void)resetSuperscriptingFraction;
+(void)resetAllowFontSynthesis;

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

#pragma mark - Fonts
+(AMFontAttributes*)fontAttributesForFontType:(AMFontType)fontType;
+(void)setFontAttributes:(AMFontAttributes*)attributes forFontType:(AMFontType)fontType;
+(NSUInteger)fontSize;
+(void)setFontSize:(NSUInteger)size;
+(NSUInteger)smallestFontSize;
+(void)setSmallestFontSize:(NSUInteger)size;
+(NSUInteger)fixedWidthFontSize;
+(void)setFixedWidthFontSize:(NSUInteger)size;
+(CGFloat)superscriptingFraction;
+(void)setSuperscriptingFraction:(CGFloat)superscriptingFraction;
+(CGFloat)superscriptOffset;
+(void)setSuperscriptOffset:(CGFloat)offset;
+(CGFloat)subscriptOffset;
+(void)setSubscriptOffset:(CGFloat)offset;

+(BOOL)allowFontSynthesis;
+(void)setAllowFontSynthesis:(BOOL)yn;

#pragma mark - Misc  -
+(NSSize)pageSize;
+(void)setPageSize:(NSSize)size;
+(NSFont*)fontForFontType:(AMFontType)fontType;

#pragma mark - Colors
+(AMColorSettings*)colorSettings;
+(void)setColorSettings:(AMColorSettings*)colorSettings;
+(void)resetColorSettings;

@end
