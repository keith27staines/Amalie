//
//  KSMFunction.m
//  Amalie
//
//  Created by Keith Staines on 26/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMFunction.h"
#import "KSMExpression.h"
#import "KSMWorksheet.h"
#import "KSMFunctionArgumentList.h"
#import "KSMSymbolProvider.h"

@interface KSMFunction()
{
    NSString * _name;
}
@property (readwrite, copy) NSString * name;

@end


@implementation KSMFunction

-(id)init
{
    return [self initWithArgumentList:nil returnType:KSMValueDouble];
}

- (id)initWithArgumentList:(KSMFunctionArgumentList*)argumentList
                returnType:(KSMValueType)returnType name:(NSString*)name
{
    self = [super init];
    if (self) {
        _argumentList = argumentList;
        if (!_argumentList) {
            _argumentList = [[KSMFunctionArgumentList alloc] init];
        }
        _returnType = returnType;
        _name = name;
        NSLog(@"%@",self.name);
    }
    return self;
}

- (id)initWithArgumentList:(KSMFunctionArgumentList*)argumentList
                returnType:(KSMValueType)returnType
{
    return [self initWithArgumentList:argumentList returnType:returnType name:@""];
}

-(KSMMathValue *)evaluateWithValues:(NSArray *)mathValues
{
    [self.argumentList setValuesFromArray:mathValues];
    return [self evaluate];
}

-(KSMMathValue *)evaluate
{
    [NSException raise:@"This method must be overridden in subclasses" format:nil];
    return nil;
}

#pragma mark - KSMReferenceCountedObject -
-(NSString *)symbol
{
    return [[KSMSymbolProvider sharedSymbolProvider] symbolForString:self.name];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Function named %@",self.name];
}

@end
