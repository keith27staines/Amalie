//
//  AMConstants.m
//  Amalie
//
//  Created by Keith Staines on 08/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMConstants.h"

#pragma mark - Unit conversions -
double const kAMUnitConversionPoints_Points = 1.0;
double const kAMUnitConversionMM_Points = 2.83464567;
double const kAMUnitConversionCM_Points = 28.3464567;
double const kAMUnitConversionIn_Points = 72;
double const kAMUnitConversionPoints_MM = 1.0 / kAMUnitConversionMM_Points;
double const kAMUnitConversionPoints_CM = 1.0 / kAMUnitConversionCM_Points;
double const kAMUnitConversionPoints_In = 1.0 / kAMUnitConversionIn_Points;

#pragma mark - Custom notifications -
NSString * const kAMNotificationViewDidHide = @"kAMNotificationViewDidHide";
NSString * const kAMNotificationViewDidUnhide = @"kAMNotificationViewDidUnhide";

#pragma mark - key affixes -
NSString * const kAMKeyPrefix                         = @"kAM";
NSString * const kAMKeySuffix                         = @"Key";
NSString * const kAMClassNameKey                      = @"kAMClassNameKey";
NSString * const kAMTypeKey                           = @"kAMTypeKey";

#pragma mark - Main Window configuration -
NSString * const kAMSidepanelVisibilityKey            = @"kAMSidepanelVisibilityKey";
CGFloat const kAMMinWidthDocumentContainerView        = 200;
CGFloat const kAMMinWidthLeftSidepanelView            = 100;
CGFloat const kAMMinWidthRightSidepanelView           = 100;
CGFloat const kAMNominalWidthLeftSidepanelView        = 300;
CGFloat const kAMNominalWidthRightSidepanelView       = 300;
CGFloat const kAMMaxWidthLeftSidepanelView            = 300;
CGFloat const kAMMaxWidthRightSidepanelView           = 300;
CGFloat const kAMLibraryWidth                         = 300;

#pragma mark - Page Layout -
NSString * const kAMPaperSizeKey                      = @"kAMPaperSizeKey";
NSString * const kAMPageOrientationKey                = @"kAMPageOrientationKey";
NSString * const kAMPageWidthCustomKey                = @"kAMPageWidthCustomKey";
NSString * const kAMPageHeightCustomKey               = @"kAMPageHeightCustomKey";
NSString * const kAMPageMarginsKey                    = @"kAMPageMarginsKey";
NSString * const kAMPaperMeasurementUnitsKey          = @"kAMPaperMeasurementUnitsKey";

#pragma mark - Page Sizes in portrait orientation -

NSUInteger const kAMPageWidthA6               = 298;
NSUInteger const kAMPageHeightA6              = 420;

NSUInteger const kAMPageWidthA5               = 420;
NSUInteger const kAMPageHeightA5              = 595;

NSUInteger const kAMPageWidthA4               = 595;
NSUInteger const kAMPageHeightA4              = 842;

NSUInteger const kAMPageWidthA3               = 842;
NSUInteger const kAMPageHeightA3              = 1190;

NSUInteger const kAMPageWidthA2               = 1190;
NSUInteger const kAMPageHeightA2              = 1684;

NSUInteger const kAMPageWidthA1               = 1684;
NSUInteger const kAMPageHeightA1              = 2384;

NSUInteger const kAMPageWidthA0               = 2384;
NSUInteger const kAMPageHeightA0              = 3371;

NSUInteger const kAMPageWidthB5               = 516;
NSUInteger const kAMPageHeightB5              = 729;

NSUInteger const kAMPageWidthB4               = 729;
NSUInteger const kAMPageHeightB4              = 1032;

NSUInteger const kAMPageWidthUSLetter         = 612;
NSUInteger const kAMPageHeightUSLetter        = 792;

NSUInteger const kAMPageWidthUSLegal          = 612;
NSUInteger const kAMPageHeightUSLegal         = 1008;

#pragma mark - Font -
//Keys for particular fonts
NSString * const kAMFontAttributesForLiteralsKey       = @"kAMFactorySettingFontNameForLiteralsKey";
NSString * const kAMFontAttributesForAlgebraKey        = @"kAMFontAttributesForAlgebraKey";
NSString * const kAMFontAttributesForVectorsKey        = @"kAMFontAttributesForVectorsKey";
NSString * const kAMFontAttributesForMatricesKey       = @"kAMFontAttributesForMatricesKey";
NSString * const kAMFontAttributesForSymbolsKey        = @"kAMFontAttributesForSymbolsKey";
NSString * const kAMFontAttributesForFixedWidthTextKey = @"kAMFontAttributesForFixedWidthTextKey";
NSString * const kAMFontAttributesForTextKey           = @"kAMFontAttributesForTextKey";

// Keys for specific font attributes in a dictionary
NSString * const kAMFontNameKey                       = @"kAMFontNameKey";
NSString * const kAMMinFontSizeKey                    = @"kAMMinFontSizeKey";
NSString * const kAMFontSizeKey                       = @"kAMFontSizeKey";
NSString * const kAMFontBoldKey                       = @"kAMFontBoldKey";
NSString * const kAMFontItalicKey                     = @"kAMFontItalicKey";
NSString * const kAMFixedWidthFontSizeKey             = @"kAMFixedWidthFontSizeKey";
NSString * const kAMAllowFontSynthesisKey             = @"kAMAllowFontSynthesisKey";

// Color keys
NSString * const kAMDocumentBackgroundColorKey        = @"kAMDocumentBackgroundColorKey";
NSString * const kAMPaperColorKey                     = @"kAMPaperColorKey";
NSString * const kAMDocumentBackgroundFontColorKey    = @"kAMDocumentBackgroundFontColorKey";
NSString * const kAMPaperFontColorKey                 = @"kAMPaperFontColorKey";

// Color keys for drilling down into compound structures
NSString * const kAMFontColorKey                      = @"kAMFontColorKey";
NSString * const kAMBackColorKey                      = @"kAMBackColorKey";

// other keys
NSString * const kAMSuperscriptingFractionKey         = @"kAMSuperscriptingFractionKey";
NSString * const kAMSuperscriptOffsetKey              = @"kAMSuperscriptOffsetKey";
NSString * const kAMSubscriptOffsetKey                = @"kAMSubscriptOffsetKey";
NSString * const kAMScriptingLevelKey                 = @"kAMScriptingLevel";

// Factory default fonts
NSString * const kAMFactorySettingFontNameForLiterals       = @"Times New Roman";
NSString * const kAMFactorySettingFontNameForAlgebra        = @"Times New Roman";
NSString * const kAMFactorySettingFontNameForVectors        = @"Times New Roman";
NSString * const kAMFactorySettingFontNameForMatrices       = @"Times New Roman";
NSString * const kAMFactorySettingFontNameForSymbols        = @"Times New Roman";
NSString * const kAMFactorySettingFontNameForFixedWidthText = @"Monaco";
NSString * const kAMFactorySettingFontNameForText           = @"Times New Roman";

NSUInteger const kAMFactorySettingMinFontSize                = 6;
NSUInteger const kAMFactorySettingFontSize                   = 12;
NSUInteger const kAMFactorySettingFixedWidthFontSize         = 12;
CGFloat    const kAMFactorySettingSuperscriptingFraction     = 0.7;
CGFloat    const kAMFactorySettingSuperscriptOffset          = 0.8;
CGFloat    const kAMFactorySettingSubscriptOffset            = 0.8;
BOOL       const kAMFactorySettingAllowFontSynthesis         = YES;

// Factory default colors
AMNamedColor kAMFactorySettingConstantsBackColor      = AMNamedColorPaleRed;
AMNamedColor kAMFactorySettingVariablesBackColor      = AMNamedColorPaleGreen;
AMNamedColor kAMFactorySettingExpressionsBackColor    = AMNamedColorPaleBlue;
AMNamedColor kAMFactorySettingFunctionsBackColor      = AMNamedColorPaleGreen;
AMNamedColor kAMFactorySettingEquationsBackColor      = AMNamedColorPaleYellow;
AMNamedColor kAMFactorySettingVectorsBackColor        = AMNamedColorPaleOrange;
AMNamedColor kAMFactorySettingMatricesBackColor       = AMNamedColorBarleyWhite;
AMNamedColor kAMFactorySettingSetsBackColor           = AMNamedColorPaleAzure;
AMNamedColor kAMFactorySettingGraph2DBackColor        = AMNamedColorPalePurple;
AMNamedColor kAMFactorySettingConstantsFontColor      = AMNamedColorBlack;
AMNamedColor kAMFactorySettingVariablesFontColor      = AMNamedColorBlack;
AMNamedColor kAMFactorySettingExpressionsFontColor    = AMNamedColorBlack;
AMNamedColor kAMFactorySettingFunctionsFontColor      = AMNamedColorBlack;
AMNamedColor kAMFactorySettingEquationsFontColor      = AMNamedColorBlack;
AMNamedColor kAMFactorySettingVectorsFontColor        = AMNamedColorBlack;
AMNamedColor kAMFactorySettingMatricesFontColor       = AMNamedColorBlack;
AMNamedColor kAMFactorySettingSetsFontColor           = AMNamedColorBlack;
AMNamedColor kAMFactorySettingGraph2DFontColor        = AMNamedColorBlack;

AMNamedColor kAMFactorySettingDocumentBackgroundColor = AMNamedColorPaleRed;
AMNamedColor kAMFactorySettingPaperColor              = AMNamedColorWhite;
AMNamedColor kAMFactorySettingDocumentBackgroundFontColor = AMNamedColorPaleRed;
AMNamedColor kAMFactorySettingPaperFontColor          = AMNamedColorBlack;
AMNamedColor kAMFactorySettingFontColor               = AMNamedColorBlack;

#pragma mark - Icon and title -
NSString * const kAMIconKey                           = @"kAMIconKey";
NSString * const kAMTitleKey                          = @"kAMTitleKey";
NSString * const kAMInfoKey                           = @"kAMInfoKey";

#pragma mark - Key for all color settings
NSString * const kAMAllColorSettingsKey               = @"kAMAllColorSettingsKey";

#pragma mark - Key for library of insertable objects
NSString * const kAMLibraryObjectsKey                 = @"kAMLibraryObjectsKey";

#pragma mark - Key for Non library objects areas
NSString * const kAMNonLibraryObjectsKey              = @"kAMNonLibraryObjectsKey";
NSString * const kAMDocumentBackgroundKey             = @"kAMDocumentBackgroundKey";
NSString * const kAMPaperKey                          = @"kAMPaperKey";

#pragma mark - Keys for objects in insertable objects library -
NSString * const kAMConstantKey                       = @"kAMConstantKey";
NSString * const kAMVariableKey                       = @"kAMVariableKey";
NSString * const kAMDummyVariableKey                  = @"kAMDummyVariableKey";
NSString * const kAMExpressionKey                     = @"kAMExpressionKey";
NSString * const kAMFunctionKey                       = @"kAMFunctionKey";
NSString * const kAMEquationKey                       = @"kAMEquationKey";
NSString * const kAMGraph2DKey                        = @"kAMGraph2DKey";
NSString * const kAMMathematicalSetKey                = @"kAMMathematicalSetKey";
NSString * const kAMVectorKey                         = @"kAMVectorKey";
NSString * const kAMMatrixKey                         = @"kAMMatrixKey";

#pragma mark - Keyed Resources -
NSString * const kAMImageToolbarLeftSidePanelOpenKey    = @"LeftSidebarOpenBtn";
NSString * const kAMImageToolbarLeftSidePanelClosedKey  = @"LeftSidebarClosedBtn";
NSString * const kAMImageToolbarRightSidePanelOpenKey   = @"RightSidebarOpenBtn";
NSString * const kAMImageToolbarRightSidePanelClosedKey = @"RightSidebarClosedBtn";

#pragma mark - Other -

#pragma mark - Helper C functions -

NSData * dataFromColor(NSColor* color)
{
    return [NSKeyedArchiver archivedDataWithRootObject:color];
}

NSColor * colorFromData(NSData* data)
{
    assert(data);
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@implementation AMConstants

@end
