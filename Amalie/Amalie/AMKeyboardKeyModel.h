//
//  AMKeyboardKeyModel.h
//  Amalie
//
//  Created by Keith Staines on 14/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMKeyboardKeyModel : NSObject

@property (copy) NSString * name;
@property (copy) NSString * keyboardName;
@property        BOOL       upperCase;
@property (copy) NSString * englishName;

/*! letter-like keys (a,b,c, alpha, beta, etc) can be used as the first character in names */
@property        BOOL       isLetter;

/*! operator keys are things like *,/+,- */
@property        BOOL       isOperator;

/*! math symbol keys are things that represent integral signs, diff symbols, sum symbols, limits, etc */
@property        BOOL       isMathSymbol;

@property        BOOL       isNumberOrExpression;

+(AMKeyboardKeyModel *)letterKeyWithName:(NSString*)name
                     englishName:(NSString *)englishName
                          keyboardName:(NSString*)family
                       upperCase:(BOOL)upperCase;

+(AMKeyboardKeyModel *)operatorKeyWithName:(NSString*)name
                               englishName:(NSString*)englishName
                              keyboardName:(NSString*)keyboardName;

+(AMKeyboardKeyModel *)mathSymbolKeyWithName:(NSString*)name
                                 englishName:(NSString*)englishName
                                keyboardName:(NSString*)keyboardName;

+(AMKeyboardKeyModel *)numberKeyWithName:(NSString*)name
                             englishName:(NSString*)englishName
                            keyboardName:(NSString*)keyboardName;
@end
