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

#pragma mark - Settings sections -
typedef NS_ENUM(NSUInteger, AMSettingsSectionType) {
    AMSettingsSectionPage       = 0,
    AMSettingsSectionColors     = 1,
    AMSettingsSectionFonts      = 2,
    AMSettingsSectionMathsStyle = 3,
};
extern NSString * const kAMAllColorSettingsKey;
extern NSString * const kAMAllFontSettingsKey;
extern NSString * const kAMAllPageSettingsKey;
extern NSString * const KAMAllMathStyleSettingsKey;

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

// Keys for colors
extern NSString * const kAMDocumentBackgroundColorKey;
extern NSString * const kAMPaperColorKey;
extern NSString * const kAMDocumentBackgroundFontColorKey;
extern NSString * const kAMPaperFontColorKey;

// Color keys for drilling down into compound structures
extern NSString * const kAMFontColorKey;
extern NSString * const kAMBackColorKey;

// Factory defaults for fonts
extern NSString * const kAMFactorySettingFontNameForLiterals;
extern NSString * const kAMFactorySettingFontNameForAlgebra;
extern NSString * const kAMFactorySettingFontNameForVectors;
extern NSString * const kAMFactorySettingFontNameForMatrices;
extern NSString * const kAMFactorySettingFontNameForSymbols;
extern NSString * const kAMFactorySettingFontNameForFixedWidthText;
extern NSString * const kAMFactorySettingFontNameForText;

extern CGFloat    const kAMFactorySettingMinFontSizeFraction;
extern NSUInteger const kAMFactorySettingFontSize;
extern NSUInteger const kAMFactorySettingFixedWidthFontSize;
extern CGFloat    const kAMFactorySettingSuperscriptingFraction;
extern CGFloat    const kAMFactorySettingSuperscriptOffsetFraction;
extern CGFloat    const kAMFactorySettingSubscriptOffsetFraction;
extern BOOL       const kAMFactorySettingAllowFontSynthesis;

// Factory default colors
typedef NS_ENUM(NSUInteger, AMNamedColor) {
    AMNamedColorPaleRed          = 0,
    AMNamedColorPaleGreen        = 1,
    AMNamedColorPaleBlue         = 2,
    AMNamedColorPaleYellow       = 3,
    AMNamedColorPalePurple       = 4,
    AMNamedColorPaleAzure        = 5,
    AMNamedColorPaleOrange       = 6,
    AMNamedColorBarleyWhite      = 7,
    AMNamedColorWhite            = 1000,
    AMNamedColorBlack            = 1001,
};
extern AMNamedColor kAMFactorySettingConstantsBackColor;
extern AMNamedColor kAMFactorySettingVariablesBackColor;
extern AMNamedColor kAMFactorySettingExpressionsBackColor;
extern AMNamedColor kAMFactorySettingFunctionsBackColor;
extern AMNamedColor kAMFactorySettingEquationsBackColor;
extern AMNamedColor kAMFactorySettingVectorsBackColor;
extern AMNamedColor kAMFactorySettingMatricesBackColor;
extern AMNamedColor kAMFactorySettingSetsBackColor;
extern AMNamedColor kAMFactorySettingGraph2DBackColor;

extern AMNamedColor kAMFactorySettingConstantsFontColor;
extern AMNamedColor kAMFactorySettingVariablesFontColor;
extern AMNamedColor kAMFactorySettingExpressionsFontColor;
extern AMNamedColor kAMFactorySettingFunctionsFontColor;
extern AMNamedColor kAMFactorySettingEquationsFontColor;
extern AMNamedColor kAMFactorySettingVectorsFontColor;
extern AMNamedColor kAMFactorySettingMatricesFontColor;
extern AMNamedColor kAMFactorySettingSetsFontColor;
extern AMNamedColor kAMFactorySettingGraph2DFontColor;
extern AMNamedColor kAMFactorySettingDocumentBackgroundColor;
extern AMNamedColor kAMFactorySettingPaperColor;
extern AMNamedColor kAMFactorySettingDocumentBackgroundFontColor;
extern AMNamedColor kAMFactorySettingPaperFontColor;

#pragma mark - Icon and title -
extern NSString * const kAMIconKey;
extern NSString * const kAMTitleKey;
extern NSString * const kAMInfoKey;

#pragma mark - Key for all color settings
extern NSString * const kAMAllColorSettingsKey;

#pragma mark - Keys for insertable object library -
extern NSString * const kAMLibraryObjectsKey;

#pragma mark - Keys for other document areas -
extern NSString * const kAMNonLibraryObjectsKey;
extern NSString * const kAMDocumentBackgroundKey;
extern NSString * const kAMPaperKey;

#pragma mark - Keys for objects in the insertable objects library -
extern NSString * const kAMConstantKey;
extern NSString * const kAMVariableKey;
extern NSString * const kAMDummyVariableKey;
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

typedef NS_ENUM(NSInteger, AMSettingsStorageLocationType){
    AMSettingsStorageLocationTypeFactoryDefaults = 0,
    AMSettingsStorageLocationTypeUserDefaults    = 1,
    AMSettingsStorageLocationTypeCurrentDocument = 2,
};

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
