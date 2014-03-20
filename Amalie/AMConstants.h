//
//  AMConstants.h
//  Amalie
//
//  Created by Keith Staines on 08/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Unit conversions -
extern double const kAMUnitConversionPoints_Points;
extern double const kAMUnitConversionMM_Points;
extern double const kAMUnitConversionCM_Points;
extern double const kAMUnitConversionIn_Points;
extern double const kAMUnitConversionPoints_MM;
extern double const kAMUnitConversionPoints_CM;
extern double const kAMUnitConversionPoints_In;

#pragma mark - Custom notifications -
extern NSString * const kAMNotificationViewDidHide;
extern NSString * const kAMNotificationViewDidUnhide;

#pragma mark - key affixes -
extern NSString * const kAMKeyPrefix;
extern NSString * const kAMKeySuffix;
extern NSString * const kAMClassNameKey;
extern NSString * const kAMTypeKey;

#pragma mark - Main window configuration
extern NSString * const kAMSidepanelVisibilityKey;
extern CGFloat const kAMMinWidthDocumentContainerView;
extern CGFloat const kAMMinWidthLeftSidepanelView;
extern CGFloat const kAMMinWidthRightSidepanelView;
extern CGFloat const kAMNominalWidthLeftSidepanelView;
extern CGFloat const kAMNominalWidthRightSidepanelView;
extern CGFloat const kAMMaxWidthLeftSidepanelView;
extern CGFloat const kAMMaxWidthRightSidepanelView;
extern CGFloat const kAMLibraryWidth;

#pragma mark - Page Layout -
extern NSString * const kAMPaperSizeKey;
extern NSString * const kAMPageOrientationKey;

extern NSString * const kAMPageWidthCustomKey;
extern NSString * const kAMPageHeightCustomKey;
extern NSString * const kAMPageMarginsKey;
extern NSString * const kAMPaperMeasurementUnitsKey;

#pragma mark - Page Sizes in portrait orientation -
extern NSUInteger const kAMPageWidthA6;
extern NSUInteger const kAMPageHeightA6;

extern NSUInteger const kAMPageWidthA5;
extern NSUInteger const kAMPageHeightA5;

extern NSUInteger const kAMPageWidthA4;
extern NSUInteger const kAMPageHeightA4;

extern NSUInteger const kAMPageWidthA3;
extern NSUInteger const kAMPageHeightA3;

extern NSUInteger const kAMPageWidthA2;
extern NSUInteger const kAMPageHeightA2;

extern NSUInteger const kAMPageWidthA1;
extern NSUInteger const kAMPageHeightA1;

extern NSUInteger const kAMPageWidthA0;
extern NSUInteger const kAMPageHeightA0;

extern NSUInteger const kAMPageWidthB5;
extern NSUInteger const kAMPageHeightB5;

extern NSUInteger const kAMPageWidthB4;
extern NSUInteger const kAMPageHeightB4;

extern NSUInteger const kAMPageWidthUSLetter;
extern NSUInteger const kAMPageHeightUSLetter;

extern NSUInteger const kAMPageWidthUSLegal;
extern NSUInteger const kAMPageHeightUSLegal;

#pragma mark - Font -
typedef NS_ENUM(NSUInteger, AMFontType){
    AMFontTypeLiteral    = 0,
    AMFontTypeAlgebra    = 1,
    AMFontTypeVector     = 2,
    AMFontTypeMatrix     = 3,
    AMFontTypeSymbol     = 4,
    AMFontTypeText       = 5,
    AMFontTypeFixedWidth = 6,
    AMFontTypeMax        = 6,
};
// Keys
extern NSString * const kAMFontAttributesForLiteralsKey;
extern NSString * const kAMFontAttributesForAlgebraKey;
extern NSString * const kAMFontAttributesForVectorsKey;
extern NSString * const kAMFontAttributesForMatricesKey;
extern NSString * const kAMFontAttributesForSymbolsKey;
extern NSString * const kAMFontAttributesForFixedWidthTextKey;
extern NSString * const kAMFontAttributesForTextKey;

extern NSString * const kAMFontNameKey;
extern NSString * const kAMFontBoldKey;
extern NSString * const kAMFontItalicKey;
extern NSString * const kAMMinFontSizeKey;
extern NSString * const kAMFontSizeKey;
extern NSString * const kAMFixedWidthFontSizeKey;
extern NSString * const kAMAllowFontSynthesisKey;

extern NSString * const kAMSuperscriptingFractionKey;
extern NSString * const kAMSuperscriptOffsetKey;
extern NSString * const kAMSubscriptOffsetKey;
extern NSString * const kAMScriptingLevelKey;

// Factory defaults
extern NSString * const kAMFactorySettingFontNameForLiterals;
extern NSString * const kAMFactorySettingFontNameForAlgebra;
extern NSString * const kAMFactorySettingFontNameForVectors;
extern NSString * const kAMFactorySettingFontNameForMatrices;
extern NSString * const kAMFactorySettingFontNameForSymbols;
extern NSString * const kAMFactorySettingFontNameForFixedWidthText;
extern NSString * const kAMFactorySettingFontNameForText;

extern NSUInteger const kAMFactorySettingMinFontSize;
extern NSUInteger const kAMFactorySettingFontSize;
extern NSUInteger const kAMFactorySettingFixedWidthFontSize;
extern CGFloat    const kAMFactorySettingSuperscriptingFraction;
extern CGFloat    const kAMFactorySettingSuperscriptOffset;
extern CGFloat    const kAMFactorySettingSubscriptOffset;
extern BOOL       const kAMFactorySettingAllowFontSynthesis;

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

#pragma mark - Keyed Resources -
extern NSString * const kAMImageToolbarLeftSidePanelOpenKey;
extern NSString * const kAMImageToolbarLeftSidePanelClosedKey;
extern NSString * const kAMImageToolbarRightSidePanelOpenKey;
extern NSString * const kAMImageToolbarRightSidePanelClosedKey;

#pragma mark - Other -

typedef NS_ENUM(NSUInteger, AMMeasurementUnits) {
    AMMeasurementUnitsPoints      = 0,
    AMMeasurementUnitsMillimeters = 1,
    AMMeasurementUnitsCentimeters = 2,
    AMMeasurementUnitsInches      = 3,
};

typedef NS_ENUM(NSUInteger, AMPaperOrientation) {
    AMPaperOrientationPortrait,
    AMPaperOrientationLandscape,
};

typedef NS_ENUM(NSInteger, AMPaperType) {
    AMPaperTypeA0,
    AMPaperTypeA1,
    AMPaperTypeA2,
    AMPaperTypeA3,
    AMPaperTypeA4,
    AMPaperTypeA5,
    AMPaperTypeA6,
    AMPaperTypeB4,
    AMPaperTypeB5,
    AMPaperTypeUSLegal,
    AMPaperTypeUSLetter,
    AMPaperTypeCustom,
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

typedef NS_OPTIONS(NSUInteger, AMSidepanelVisibility) {
    AMSidepanelNoneVisible                 = 0,
    AMSidepanelsLeftVisible                = 1 << 0,
    AMSidepanelsRightVisible               = 1 << 1,
};

typedef NS_ENUM(NSUInteger, AMPanelBits) {
    AMPanelBitsLeftPaneBit = 0,
    AMPanelBitsRightPaneBit = 1,
};

NSData * dataFromColor(NSColor* color);
NSColor * colorFromData(NSData* data);

@interface AMConstants : NSObject

@end
