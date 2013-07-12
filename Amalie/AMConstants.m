//
//  AMConstants.m
//  Amalie
//
//  Created by Keith Staines on 08/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMConstants.h"

#pragma mark - Default values -
NSUInteger const kAMDefaultFontSize                   = 16;
NSUInteger const kAMDefaultFixedWidthFontSize         = 16;
NSUInteger const kAMDefaultFontDelta                  =  2;
NSUInteger const kAMDefaultMinFontSize                = 10;
NSString * const kAMDefaultFontName                   = @"Times New Roman";
NSString * const kAMDefaultFixedWidthFontName         = @"Monaco";

#pragma mark - key affixes -
NSString * const kAMKeyPrefix                         =@"kAM";
NSString * const kAMKeySuffix                         = @"Key";

#pragma mark - Page Layout -
NSString * const kAMPaperSizeKey                      = @"kAMPaperSizeKey";
NSString * const kAMPaperSizeA4Portrait               = @"A4Portrait";
NSString * const kAMPaperSizeA4Landscape              = @"A4Landscape";

#pragma mark - Font -
NSString * const kAMFontNameKey                       = @"kAMFontNameKey";
NSString * const kAMFontSizeKey                       = @"kAMFontSizeKey";
NSString * const kAMFontSizeDeltaKey                  = @"kAMFontSizeDeltaKey";
NSString * const kAMMinFontSizeKey                    = @"kAMMinFontSizeKey";
NSString * const kAMFixedWidthFontNameKey             = @"kAMFixedWidthFontNameKey";
NSString * const kAMFixedWidthFontSizeKey             = @"kAMFixedWidthFontSizeKey";

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
NSString * const kAMEquationKey                       = @"kAMEquationKey";
NSString * const kAMGraph2DKey                        = @"kAMGraph2DKey";
NSString * const kAMMathematicalSetKey                = @"kAMMathematicalSetKey";
NSString * const kAMVectorKey                         = @"kAMVectorKey";
NSString * const kAMMatrixKey                         = @"kAMMatrixKey";


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
