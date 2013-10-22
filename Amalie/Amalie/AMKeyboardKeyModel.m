//
//  AMKeyboardKeyModel.m
//  Amalie
//
//  Created by Keith Staines on 14/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMKeyboardKeyModel.h"

@interface AMKeyboardKeyModel ()
{
    BOOL _upperCase;
    NSString * _name;
    NSString * _keyboardName;
    NSString * _englishName;
}

@end

@implementation AMKeyboardKeyModel

+(AMKeyboardKeyModel *)letterKeyWithName:(NSString*)name
                             englishName:(NSString *)englishName
                            keyboardName:(NSString*)keyboardName
                               upperCase:(BOOL)upperCase
{
    AMKeyboardKeyModel * key = [[AMKeyboardKeyModel alloc] init];
    key.name         = name;
    key.englishName  = englishName;
    key.keyboardName = keyboardName;
    key.upperCase    = upperCase;
    key.isLetter     = YES;
    key.isMathSymbol = NO;
    key.isOperator   = NO;
    return key;
}

+(AMKeyboardKeyModel *)operatorKeyWithName:(NSString*)name
                               englishName:(NSString*)englishName
                              keyboardName:(NSString*)keyboardName
{
    AMKeyboardKeyModel * key = [[AMKeyboardKeyModel alloc] init];
    key.name         = name;
    key.englishName  = englishName;
    key.keyboardName = keyboardName;
    key.isOperator   = YES;
    return key;
}

+(AMKeyboardKeyModel *)numberKeyWithName:(NSString*)name
                             englishName:(NSString*)englishName
                            keyboardName:(NSString*)keyboardName
{
    AMKeyboardKeyModel * key = [[AMKeyboardKeyModel alloc] init];
    key.name         = name;
    key.englishName  = englishName;
    key.keyboardName = keyboardName;
    key.isNumberOrExpression   = YES;
    return key;
}

+(AMKeyboardKeyModel *)mathSymbolKeyWithName:(NSString*)name
                                 englishName:(NSString*)englishName
                                keyboardName:(NSString*)keyboardName
{
    AMKeyboardKeyModel * key = [[AMKeyboardKeyModel alloc] init];
    key.name         = name;
    key.englishName  = englishName;
    key.keyboardName = keyboardName;
    key.isMathSymbol = YES;

    return key;
}
@end
