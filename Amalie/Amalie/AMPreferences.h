//
//  AMPreferences.h
//  Amalie
//
//  Created by Keith Staines on 10/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMPreferences : NSObject

+(void)registerDefaultPreferences;

+(NSSize)worksheetPageSize;
+(NSUInteger)worksheetFontSize;
+(NSUInteger)worksheetFontDelta;
+(NSUInteger)worksheetSmallestFontSize;
+(NSString*)worksheetFontName;
+(NSString*)worksheetFixedWidthFontName;
+(NSUInteger)worksheetFixedWidthFontSize;
+(NSDictionary*)fonts;
+(CGFloat)superscriptingFraction;

+(void)setWorksheetFixedWidthFontSize:(NSUInteger)size;
+(void)setWorksheetFontSize:(NSUInteger)size;
+(void)setWorksheetFontDelta:(NSUInteger)delta;
+(void)setWorksheetSmallestFontSize:(NSUInteger)size;
+(void)setWorksheetFontName:(NSString*)fontName;
+(void)setWorksheetFixedWidthFontName:(NSString*)fontName;
+(void)setSuperscriptingFraction:(CGFloat)superscriptingFraction;

+(id)objectForKey:(NSString*)key;

+(NSFont*)standardFont;
+(NSFont*)fixedWidthFont;

+(NSUserDefaults*)defaults;

@end
