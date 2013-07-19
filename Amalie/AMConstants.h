//
//  AMConstants.h
//  Amalie
//
//  Created by Keith Staines on 08/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Default values -
extern NSUInteger const kAMDefaultFontSize;
extern NSUInteger const kAMDefaultFixedWidthFontSize;
extern NSUInteger const kAMDefaultFontDelta;
extern NSUInteger const kAMDefaultMinFontSize;
extern NSString * const kAMDefaultFontName;
extern NSString * const kAMDefaultFixedWidthFontName;

#pragma mark - key affixes -
extern NSString * const kAMKeyPrefix;
extern NSString * const kAMKeySuffix;
extern NSString * const kAMClassNameKey;
extern NSString * const kAMTypeKey;

#pragma mark - Page Layout -
extern NSString * const kAMPaperSizeKey;
extern NSString * const kAMPaperSizeA4Portrait;
extern NSString * const kAMPaperSizeA4Landscape;

#pragma mark - Font -
extern NSString * const kAMFontNameKey;
extern NSString * const kAMFontSizeKey;
extern NSString * const kAMFontSizeDeltaKey;
extern NSString * const kAMMinFontSizeKey;
extern NSString * const kAMFixedWidthFontNameKey;
extern NSString * const kAMFixedWidthFontSizeKey;

#pragma mark - Icon and title -
extern NSString * const kAMIconKey;
extern NSString * const kAMTitleKey;
extern NSString * const kAMInfoKey;

extern NSString * const kAMBackColorKey;
extern NSString * const kAMForeColorKey;
extern NSString * const kAMFontColorKey;

#pragma mark - Keys for dictionaries controlled by AppController -
extern NSString * const kAMTrayDictionaryKey;

#pragma mark - Members of the kAMTrayDictionary -
extern NSString * const kAMConstantKey;
extern NSString * const kAMVariableKey;
extern NSString * const kAMExpressionKey;
extern NSString * const kAMEquationKey;
extern NSString * const kAMGraph2DKey;
extern NSString * const kAMMathematicalSetKey;
extern NSString * const kAMVectorKey;
extern NSString * const kAMMatrixKey;

typedef NS_ENUM(NSUInteger, AMInsertableType){
    AMInsertableTypeConstant,
    AMInsertableTypeVariable,
    AMInsertableTypeExpression,
    AMInsertableTypeEquation,
    AMInsertableTypeGraph2D,
    AMInsertableTypeMathematicalSet,
    AMInsertableTypeVector,
    AMInsertableTypeMatrix,
};

typedef enum AMColor : NSUInteger {
    AMColorPaleRed          = 0,
    AMColorPaleGreen        = 1,
    AMColorPaleBlue         = 2,
    AMColorPaleYellow       = 3,
    AMColorPalePurple       = 4,
    AMColorPaleAzure        = 5,
    AMColorPaleOrange       = 6,
    AMColorBarleyWhite      = 7,
    AMColorWhite            = 1000,
    AMColorBlack            = 1001,
} AMColor;




NSData * dataFromColor(NSColor* color);
NSColor * colorFromData(NSData* data);

@interface AMConstants : NSObject

@end
