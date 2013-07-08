//
//  AMConstants.h
//  Amalie
//
//  Created by Keith Staines on 08/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSUInteger kAMDefaultWorksheetFontSize;
extern NSUInteger kAMDefaultWorksheetFontDelta;
extern NSUInteger kAMDefaultWorksheetMinFontSize;

extern NSString * const kAMPaperSizeA4Portrait;
extern NSString * const kAMPaperSizeA4Landscape;

extern NSString * const kAMDefaultFixedWidthFontName;
extern NSString * const kAMDefaultFontName;

extern NSString * const kAMPreferencesWorksheetFontSizeKey;
extern NSString * const kAMPreferencesWorksheetFontSizeDeltaKey;
extern NSString * const kAMPreferencesWorksheetMinFontSizeKey;
extern NSString * const kAMPreferencesWorksheetPaperSizeKey;

extern NSString * const kAMPreferencesFontNameKey;
extern NSString * const kAMPreferencesBackColorKey;
extern NSString * const kAMPreferencesForeColorKey;
extern NSString * const kAMPreferencesFontColorKey;


extern NSString * const kAMPreferencesConstantDictionaryKey;
extern NSString * const kAMPreferencesVariableDictionaryKey;
extern NSString * const kAMPreferencesExpressionDictionaryKey;
extern NSString * const kAMPreferencesEquationDictionaryKey;
extern NSString * const kAMPreferencesGraph2DDictionaryKey;
extern NSString * const kAMPreferencesSetKey;

typedef enum AMColor : NSUInteger {
    AMColorPaleRed = 0,
    AMColorPaleGreen = 1,
    AMColorPaleBlue = 2,
    AMColorPaleYellow = 3,
    AMColorPalePurple = 4,
    AMColorPaleAzure = 5,
} AMColor;

@interface AMConstants : NSObject

@end
