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

+(AMKeyboardKeyModel *)keyWithName:(NSString*)name
                     englishName:(NSString *)englishName
                          keyboardName:(NSString*)keyboardName
                       upperCase:(BOOL)upperCase
{
    AMKeyboardKeyModel * key = [[AMKeyboardKeyModel alloc] init];
    key.name = name;
    key.englishName = englishName;
    key.keyboardName = keyboardName;
    key.upperCase = upperCase;
    return key;
}

@end
