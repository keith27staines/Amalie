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

+(NSUInteger)worksheetFontSize;
+(NSUInteger)worksheetFontDelta;
+(NSUInteger)worksheetSmallestFontSize;
+(NSString*)worksheetFontName;
+(NSString*)worksheetFixedWidthFontName;
+(NSDictionary*)fonts;

+(void)setWorksheetFixedWidthFontSize:(NSUInteger)size;
+(void)setWorksheetFontSize:(NSUInteger)size;
+(void)setWorksheetFontDelta:(NSUInteger)delta;
+(void)setWorksheetSmallestFontSize:(NSUInteger)size;
+(void)setWorksheetFontName:(NSString*)fontName;
+(void)setWorksheetFixedWidthFontName:(NSString*)fontName;

+(id)objectForKey:(NSString*)key;

+(NSUserDefaults*)defaults;

@end
