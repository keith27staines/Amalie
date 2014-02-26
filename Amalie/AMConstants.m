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

#pragma mark - Default values -
NSUInteger const kAMDefaultFontSize                   = 17;
NSUInteger const kAMDefaultFixedWidthFontSize         = 17;
NSUInteger const kAMDefaultFontDelta                  =  2;
NSUInteger const kAMDefaultMinFontSize                = 10;
NSString * const kAMDefaultFontName                   = @"Times";
NSString * const kAMDefaultFixedWidthFontName         = @"Monaco";
CGFloat    const kAMDefaultSuperscriptingFraction     = 0.7;

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
NSString * const kAMFontNameKey                       = @"kAMFontNameKey";
NSString * const kAMFontSizeKey                       = @"kAMFontSizeKey";
NSString * const kAMFontSizeDeltaKey                  = @"kAMFontSizeDeltaKey";
NSString * const kAMMinFontSizeKey                    = @"kAMMinFontSizeKey";
NSString * const kAMFixedWidthFontNameKey             = @"kAMFixedWidthFontNameKey";
NSString * const kAMFixedWidthFontSizeKey             = @"kAMFixedWidthFontSizeKey";
NSString * const kAMSuperscriptingFraction            = @"kAMSuperscriptingFraction";
NSString * const kAMScriptingLevelKey                 = @"kAMScriptingLevel";

#pragma mark - Icon and title -
NSString * const kAMIconKey                           = @"kAMIconKey";
NSString * const kAMTitleKey                          = @"kAMTitleKey";
NSString * const kAMInfoKey                           = @"kAMInfoKey";

NSString * const kAMBackColorKey                      = @"kAMBackColorKey";
NSString * const kAMForeColorKey                      = @"kAMForeColorKey";
NSString * const kAMFontColorKey                      = @"kAMFontColorKey";

#pragma mark - Keys for dictionaries controlled by AppController -
NSString * const kAMTrayDictionaryKey                 = @"kAMTrayDictionaryKey";

#pragma mark - Members of the kAMTrayDictionary -
NSString * const kAMConstantKey                       = @"kAMConstantKey";
NSString * const kAMVariableKey                       = @"kAMVariableKey";
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
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@implementation AMConstants

@end
