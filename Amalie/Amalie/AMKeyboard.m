//
//  AMKeyboard.m
//  Amalie
//
//  Created by Keith Staines on 16/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMKeyboard.h"
#import "AMKeyboardKeyModel.h"

@interface AMKeyboard()
{
    NSString * _name;
    NSMutableArray * _keysArray;
    NSMutableDictionary * _keysDictionary;
}

@end


@implementation AMKeyboard

-(NSString *)name
{
    return [_name copy];
}

- (id)initWithName:(NSString*)name keys:(NSArray*)keys;
{
    self = [super init];
    if (self) {
        _name = [name copy];
        _keysArray = [keys mutableCopy];
        if (!_keysArray) {
            _keysArray = [NSMutableArray array];
        }
        _keysDictionary = [NSMutableDictionary dictionary];
        for (AMKeyboardKeyModel * key in _keysArray) {
            _keysDictionary[key.englishName] = key;
        }
    }
    return self;
}

-(void)addKey:(AMKeyboardKeyModel*)key;
{
    AMKeyboardKeyModel * k = _keysDictionary[key.englishName];
    if ( !k ) {
        _keysDictionary[key.englishName] = key;
        _keysArray[_keysArray.count] = key;
    }
}

-(AMKeyboardKeyModel *)keyWithEnglishName:(NSString *)englishName
{
    return _keysDictionary[englishName];
}

-(AMKeyboardKeyModel *)keyWithIndex:(NSUInteger)index
{
    return _keysArray[index];
}

-(NSArray*)allKeys
{
    return [_keysArray copy];
}


@end
