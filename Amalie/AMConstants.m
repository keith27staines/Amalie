//
//  AMConstants.m
//  Amalie
//
//  Created by Keith Staines on 08/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMConstants.h"

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

#pragma mark - Page Layout -
NSString * const kAMPaperSizeKey                      = @"kAMPaperSizeKey";
NSString * const kAMPageWidthCustomKey                = @"kAMPageWidthCustomKey";
NSString * const kAMPageHeightCustomKey               = @"kAMPageHeightCustomKey";
NSString * const kAMPageMarginsKey                    = @"kAMPageMarginsKey";

NSString * const kAMPaperSizeA6Portrait               = @"A6 Portrait";
NSString * const kAMPaperSizeA6Landscape              = @"A6 Landscape";
NSString * const kAMPaperSizeA5Portrait               = @"A5 Portrait";
NSString * const kAMPaperSizeA5Landscape              = @"A5 Landscape";
NSString * const kAMPaperSizeA4Portrait               = @"A4 Portrait";
NSString * const kAMPaperSizeA4Landscape              = @"A4 Landscape";
NSString * const kAMPaperSizeA3Portrait               = @"A3 Portrait";
NSString * const kAMPaperSizeA3Landscape              = @"A3 Landscape";
NSString * const kAMPaperSizeA2Portrait               = @"A2 Portrait";
NSString * const kAMPaperSizeA2Landscape              = @"A2 Landscape";
NSString * const kAMPaperSizeA1Portrait               = @"A1 Portrait";
NSString * const kAMPaperSizeA1Landscape              = @"A1 Landscape";
NSString * const kAMPaperSizeA0Portrait               = @"A0 Portrait";
NSString * const kAMPaperSizeA0Landscape              = @"A0 Landscape";
NSString * const kAMPaperSizeB5Portrait               = @"B5 Portrait";
NSString * const kAMPaperSizeB5Landscape              = @"B5 Landscape";
NSString * const kAMPaperSizeB4Portrait               = @"B4 Portrait";
NSString * const kAMPaperSizeB4Landscape              = @"B4 Landscape";
NSString * const kAMPaperSizeUSLetterPortrait         = @"US Letter Portrait";
NSString * const kAMPaperSizeUSLetterLandscape        = @"US Letter Landscape";
NSString * const kAMPaperSizeUSLegalPortrait          = @"US Legal Portrait";
NSString * const kAMPaperSizeUSLegalLandscape         = @"US Legal Landscape";
NSString * const kAMPaperSizeCustom                   = @"Custom";

#pragma mark - Page Sizes -

NSUInteger const kAMPageWidthA6Portrait               = 298;
NSUInteger const kAMPageHeightA6Portrait              = 420;
NSUInteger const kAMPageWidthA6Landscape              = 420;
NSUInteger const kAMPageHeightA6Landscape             = 298;

NSUInteger const kAMPageWidthA5Portrait               = 420;
NSUInteger const kAMPageHeightA5Portrait              = 595;
NSUInteger const kAMPageWidthA5Landscape              = 595;
NSUInteger const kAMPageHeightA5Landscape             = 420;

NSUInteger const kAMPageWidthA4Portrait               = 595;
NSUInteger const kAMPageHeightA4Portrait              = 842;
NSUInteger const kAMPageWidthA4Landscape              = 842;
NSUInteger const kAMPageHeightA4Landscape             = 595;

NSUInteger const kAMPageWidthA3Portrait               = 842;
NSUInteger const kAMPageHeightA3Portrait              = 1190;
NSUInteger const kAMPageWidthA3Landscape              = 1190;
NSUInteger const kAMPageHeightA3Landscape             = 842;

NSUInteger const kAMPageWidthA2Portrait               = 1190;
NSUInteger const kAMPageHeightA2Portrait              = 1684;
NSUInteger const kAMPageWidthA2Landscape              = 1684;
NSUInteger const kAMPageHeightA2Landscape             = 1190;

NSUInteger const kAMPageWidthA1Portrait               = 1684;
NSUInteger const kAMPageHeightA1Portrait              = 2384;
NSUInteger const kAMPageWidthA1Landscape              = 2384;
NSUInteger const kAMPageHeightA1Landscape             = 1684;

NSUInteger const kAMPageWidthA0Portrait               = 2384;
NSUInteger const kAMPageHeightA0Portrait              = 3371;
NSUInteger const kAMPageWidthA0Landscape              = 3371;
NSUInteger const kAMPageHeightA0Landscape             = 2384;

NSUInteger const kAMPageWidthB5Portrait               = 516;
NSUInteger const kAMPageHeightB5Portrait              = 729;
NSUInteger const kAMPageWidthB5Landscape              = 729;
NSUInteger const kAMPageHeightB5Landscape             = 516;

NSUInteger const kAMPageWidthB4Portrait               = 729;
NSUInteger const kAMPageHeightB4Portrait              = 1032;
NSUInteger const kAMPageWidthB4Landscape              = 1032;
NSUInteger const kAMPageHeightB4Landscape             = 729;

NSUInteger const kAMPageWidthUSLetterPortrait         = 612;
NSUInteger const kAMPageHeightUSLetterPortrait        = 792;
NSUInteger const kAMPageWidthUSLetterLandscape        = 792;
NSUInteger const kAMPageHeightUSLetterLandscape       = 612;

NSUInteger const kAMPageWidthUSLegalPortrait          = 612;
NSUInteger const kAMPageHeightUSLegalPortrait         = 1008;
NSUInteger const kAMPageWidthUSLegalLandscape         = 1008;
NSUInteger const kAMPageHeightUSLegalLandscape        = 612;

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
