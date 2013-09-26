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
#import "KSMReferenceCounter.h"

@interface KSMFunction()
{
    NSString * _name;
    KSMReferenceCounter * _referenceCounter;
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

-(KSMReferenceCounter *)referenceCounter
{
    return _referenceCounter;
}

-(void)setReferenceCounter:(KSMReferenceCounter *)referenceCounter
{
    if (!_referenceCounter) {
        _referenceCounter = referenceCounter;
    } else {
        NSAssert(referenceCounter == _referenceCounter, @"Attempt was made to change the receiver's reference counter.");
    }
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@<%@>",[super description],self.name];
}

-(void)dealloc
{
    if (self.referenceCounter) {
        [self.referenceCounter objectIsDeallocating:self];
    }
}

@end
