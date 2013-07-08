//
//  AMInsertableDefinition.m
//  Amalie
//
//  Created by Keith Staines on 03/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMInsertableDefinition.h"

@implementation AMInsertableDefinition

- (id)init
{
    [NSException raise:@"Use the designated initialiser" format:nil];
    return nil;
}

- (id)initWithName:(NSString*)name
{
    return [self initWithName:name text:name];
}

- (id)initWithName:(NSString*)name text:(NSString*)description
{
    self = [super init];
    if (self) {
        _name = name;
        _text = description;
        NSBundle * bundle = [NSBundle mainBundle];
        _icon = [bundle imageForResource:name];
    }
    return self;
}

@end
