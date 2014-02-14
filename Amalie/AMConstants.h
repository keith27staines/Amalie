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
extern CGFloat    const kAMDefaultSuperscriptingFraction;

#pragma mark - key affixes -
extern NSString * const kAMKeyPrefix;
extern NSString * const kAMKeySuffix;
extern NSString * const kAMClassNameKey;
extern NSString * const kAMTypeKey;

#pragma mark - Page Layout -
extern NSString * const kAMPaperSizeKey;
extern NSString * const kAMPaperSizeA6Portrait;
extern NSString * const kAMPaperSizeA6Landscape;
extern NSString * const kAMPaperSizeA5Portrait;
extern NSString * const kAMPaperSizeA5Landscape;
extern NSString * const kAMPaperSizeA4Portrait;
extern NSString * const kAMPaperSizeA4Landscape;
extern NSString * const kAMPaperSizeA3Portrait;
extern NSString * const kAMPaperSizeA3Landscape;
extern NSString * const kAMPaperSizeA2Portrait;
extern NSString * const kAMPaperSizeA2Landscape;
extern NSString * const kAMPaperSizeA1Portrait;
extern NSString * const kAMPaperSizeA1Landscape;
extern NSString * const kAMPaperSizeA0Portrait;
extern NSString * const kAMPaperSizeA0Landscape;
extern NSString * const kAMPaperSizeB5Portrait;
extern NSString * const kAMPaperSizeB5Landscape;
extern NSString * const kAMPaperSizeB4Portrait;
extern NSString * const kAMPaperSizeB4Landscape;
extern NSString * const kAMPaperSizeUSLetterPortrait;
extern NSString * const kAMPaperSizeUSLetterLandscape;
extern NSString * const kAMPaperSizeUSLegalPortrait;
extern NSString * const kAMPaperSizeUSLegalLandscape;

#pragma mark - Page Sizes -
extern NSUInteger const kAMPageWidthA6Portrait;
extern NSUInteger const kAMPageHeightA6Portrait;
extern NSUInteger const kAMPageWidthA6Landscape;
extern NSUInteger const kAMPageHeightA6Landscape;

extern NSUInteger const kAMPageWidthA5Portrait;
extern NSUInteger const kAMPageHeightA5Portrait;
extern NSUInteger const kAMPageWidthA5Landscape;
extern NSUInteger const kAMPageHeightA5Landscape;

extern NSUInteger const kAMPageWidthA4Portrait;
extern NSUInteger const kAMPageHeightA4Portrait;
extern NSUInteger const kAMPageWidthA4Landscape;
extern NSUInteger const kAMPageHeightA4Landscape;

extern NSUInteger const kAMPageWidthA3Portrait;
extern NSUInteger const kAMPageHeightA3Portrait;
extern NSUInteger const kAMPageWidthA3Landscape;
extern NSUInteger const kAMPageHeightA3Landscape;

extern NSUInteger const kAMPageWidthA2Portrait;
extern NSUInteger const kAMPageHeightA2Portrait;
extern NSUInteger const kAMPageWidthA2Landscape;
extern NSUInteger const kAMPageHeightA2Landscape;

extern NSUInteger const kAMPageWidthA1Portrait;
extern NSUInteger const kAMPageHeightA1Portrait;
extern NSUInteger const kAMPageWidthA1Landscape;
extern NSUInteger const kAMPageHeightA1Landscape;

extern NSUInteger const kAMPageWidthA0Portrait;
extern NSUInteger const kAMPageHeightA0Portrait;
extern NSUInteger const kAMPageWidthA0Landscape;
extern NSUInteger const kAMPageHeightA0Landscape;

extern NSUInteger const kAMPageWidthB5Portrait;
extern NSUInteger const kAMPageHeightB5Portrait;
extern NSUInteger const kAMPageWidthB5Landscape;
extern NSUInteger const kAMPageHeightB5Landscape;

extern NSUInteger const kAMPageWidthB4Portrait;
extern NSUInteger const kAMPageHeightB4Portrait;
extern NSUInteger const kAMPageWidthB4Landscape;
extern NSUInteger const kAMPageHeightB4Landscape;

extern NSUInteger const kAMPageWidthUSLetterPortrait;
extern NSUInteger const kAMPageHeightUSLetterPortrait;
extern NSUInteger const kAMPageWidthUSLetterLandscape;
extern NSUInteger const kAMPageHeightUSLetterLandscape;

extern NSUInteger const kAMPageWidthUSLegalPortrait;
extern NSUInteger const kAMPageHeightUSLegalPortrait;
extern NSUInteger const kAMPageWidthUSLegalLandscape;
extern NSUInteger const kAMPageHeightUSLegalLandscape;

#pragma mark - Font -
extern NSString * const kAMFontNameKey;
extern NSString * const kAMFontSizeKey;
extern NSString * const kAMFontSizeDeltaKey;
extern NSString * const kAMMinFontSizeKey;
extern NSString * const kAMFixedWidthFontNameKey;
extern NSString * const kAMFixedWidthFontSizeKey;
extern NSString * const kAMSuperscriptingFraction;
extern NSString * const kAMScriptingLevelKey;

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
extern NSString * const kAMFunctionKey;
extern NSString * const kAMEquationKey;
extern NSString * const kAMGraph2DKey;
extern NSString * const kAMMathematicalSetKey;
extern NSString * const kAMVectorKey;
extern NSString * const kAMMatrixKey;

typedef NS_ENUM(NSInteger, AMPageSize) {
    AMPageSizeA4Portrait,
    AMPageSizeA4Landscape,
    AMPageSizeCustom,
};

typedef struct AMMargins {
    CGFloat top;
    CGFloat left;
    CGFloat right;
    CGFloat bottom;
} AMMargins;

typedef NS_ENUM(NSInteger, AMInsertableType){
    AMInsertableTypeConstant,
    AMInsertableTypeVariable,
    AMInsertableTypeDummyVariable,
    AMInsertableTypeExpression,
    AMInsertableTypeFunction,
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
