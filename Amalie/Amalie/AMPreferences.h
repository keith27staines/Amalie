//
//  AMPreferences.h
//  Amalie
//
//  Created by Keith Staines on 10/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMConstants.h"

@interface AMPreferences : NSObject

+(void)registerDefaultPreferences;

+(AMPreferences*)sharedPreferences;

#pragma mark - Main window configuration -


#pragma mark - Worksheet page size and margins -
@property NSSize worksheetPageSize;
+(NSSize)worksheetPageSize;
+(void)setWorksheetPageSize:(NSSize)size;
@property AMMargins pageMargins;
+(AMMargins)pageMargins;
+(void)setPageMargins:(AMMargins)margins;

@property AMPaperType worksheetPaperType;
+(AMPaperType)worksheetPaperType;
+(void)setWorksheetPaperType:(AMPaperType)paperType;

#pragma mark - Fonts -
+(NSDictionary*)fonts;
+(NSFont*)standardFont;
+(NSFont*)fixedWidthFont;
+(NSString*)worksheetFontName;
+(void)setWorksheetFontName:(NSString*)fontName;
+(NSString*)worksheetFixedWidthFontName;
+(void)setWorksheetFixedWidthFontName:(NSString*)fontName;

#pragma mark - Worksheet standard font size -
@property NSUInteger worksheetFontSize;
+(NSUInteger)worksheetFontSize;
+(void)setWorksheetFontSize:(NSUInteger)size;
+(NSUInteger)worksheetSmallestFontSize;
+(void)setWorksheetSmallestFontSize:(NSUInteger)size;

#pragma mark - Worksheet fixed width font size -
+(NSUInteger)worksheetFixedWidthFontSize;
+(void)setWorksheetFixedWidthFontSize:(NSUInteger)size;

#pragma mark - Scripting fraction -
+(CGFloat)superscriptingFraction;
+(NSUInteger)worksheetFontDelta;
+(void)setWorksheetFontDelta:(NSUInteger)delta;

+(void)setSuperscriptingFraction:(CGFloat)superscriptingFraction;

+(id)objectForKey:(NSString*)key;

+(NSUserDefaults*)defaults;

@end
