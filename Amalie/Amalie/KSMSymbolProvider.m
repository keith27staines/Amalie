//
//  KSMSymbolProvider.m
//  Amalie
//
//  Created by Keith Staines on 17/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMSymbolProvider.h"

static KSMSymbolProvider * _sharedSymbolProvider;
static NSMutableDictionary * d;

@interface KSMSymbolProvider()
{
    NSUInteger _nextInteger;
    NSMutableDictionary * _symbolsForStrings;
}

@end

@implementation KSMSymbolProvider

- (id)init
{
    self = [super init];
    if (self) {
        if (!_sharedSymbolProvider) {
            _sharedSymbolProvider = self;
            _nextInteger = 0;
            _symbolsForStrings = [NSMutableDictionary dictionary];
        }
    }
    return _sharedSymbolProvider;
}

+(id)sharedSymbolProvider
{
    return [[KSMSymbolProvider alloc] init];
}

-(NSString*)symbolForString:(NSString*)string
{
    NSString * symbol = _symbolsForStrings[string];
    if (!symbol) {
        symbol = [NSString stringWithFormat:@"$%lu",(unsigned long)_nextInteger];
        _symbolsForStrings[string] = symbol;
        _nextInteger++;
    }
    return symbol;
}

-(NSString *)description
{
    return _symbolsForStrings.description;
}

@end
