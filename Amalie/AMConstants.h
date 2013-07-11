//
//  AMConstants.h
//  Amalie
//
//  Created by Keith Staines on 08/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kAMPaperSizeA4Portrait;
extern NSString * const kAMPaperSizeA4Landscape;

extern NSString * const kAMKeySuffix;


// Default values for strings and integers. Colors are dealt with differently.
extern NSString * const kAMDefaultFontName;
extern NSString * const kAMDefaultFixedWidthFontName;
extern NSUInteger const kAMDefaultFontSize;
extern NSUInteger const kAMDefaultFixedWidthFontSize;
extern NSUInteger const kAMDefaultFontDelta;
extern NSUInteger const kAMDefaultMinFontSize;

// 
extern NSString * const kAMFontSizeKey;
extern NSString * const kAMFixedWidthFontSizeKey;
extern NSString * const kAMFontSizeDeltaKey;
extern NSString * const kAMMinFontSizeKey;
extern NSString * const kAMPaperSizeKey;

// Font property identifiers
extern NSString * const kAMFontNameKey;
extern NSString * const kAMFixedWidthFontNameKey;
extern NSString * const kAMBackColorKey;
extern NSString * const kAMForeColorKey;
extern NSString * const kAMFontColorKey;

// Identifies the Preferences panel Tray dictionary has one entry for each tray items
extern NSString * const kAMTrayDictionaryKey;

// Tray item identifiers
extern NSString * const kAMTrayDictionaryKey;  // the tray itself, now its contents...
extern NSString * const kAMConstantKey;
extern NSString * const kAMVariableKey;
extern NSString * const kAMExpressionKey;
extern NSString * const kAMEquationKey;
extern NSString * const kAMGraph2DKey;
extern NSString * const kAMMathematicalSetKey;
extern NSString * const kAMVectorKey;
extern NSString * const kAMMatrixKey;


// Tray item property identifiers
extern NSString * const kAMTrayItemIconKey;
extern NSString * const kAMTrayItemTitleKey;
extern NSString * const kAMTrayItemDescriptionKey;
extern NSString * const kAMTrayItemBackcolorKey;
extern NSString * const kAMTrayItemFontColorKey;


typedef enum AMColor : NSUInteger {
    AMColorPaleRed = 0,
    AMColorPaleGreen = 1,
    AMColorPaleBlue = 2,
    AMColorPaleYellow = 3,
    AMColorPalePurple = 4,
    AMColorPaleAzure = 5,
    AMColorWhite = 1000,
    AMColorBlack = 1001,
} AMColor;


NSData * dataFromColor(NSColor* color);
NSColor * colorFromData(NSData* data);

@interface AMConstants : NSObject

@end
