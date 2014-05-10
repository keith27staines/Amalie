//
//  AMKeyboardConstants.h
//  Amalie
//
//  Created by Keith Staines on 10/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum AMKeyboardIndex : NSInteger {
    AMKeyboardIndexNone = 0,
    AMKeyboardIndexGreekSmall,
    AMKeyboardIndexGreekCapital,
    AMKeyboardIndexEnglishSmall,
    AMKeyboardIndexEnglishCapital,
    AMKeyboardIndexNumeric,
    AMKeyboardIndexMathOperators,
    AMKeyboardIndexMathSymbols
} AMKeyboardIndex;

extern NSString * const kAMKeyboardNone;
extern NSString * const kAMKeyboardSmallGreek;
extern NSString * const kAMKeyboardCapitalGreek;
extern NSString * const kAMKeyboardSmallEnglish;
extern NSString * const kAMKeyboardCapitalEnglish;
extern NSString * const kAMKeyboardNumeric;
extern NSString * const kAMKeyboardMathOperators;
extern NSString * const kAMKeyboardMathSymbols;
