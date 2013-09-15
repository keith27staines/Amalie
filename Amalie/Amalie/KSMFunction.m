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

@interface KSMFunction()

@property (readwrite, copy) NSString * name;

@end


@implementation KSMFunction


-(id)init
{
    return [self initWithArgumentList:nil returnType:KSMValueDouble];
}

- (id)initWithArgumentList:(KSMFunctionArgumentList*)argumentList
                returnType:(KSMValueType)returnType
{
    self = [super init];
    if (self) {
        _argumentList = argumentList;
        if (!_argumentList) {
            _argumentList = [[KSMFunctionArgumentList alloc] init];
        }
        _returnType = returnType;
        _name = @"";
    }
    return self;
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
    return [NSString stringWithFormat:@"%lu",(unsigned long)self.hash];
}

@end
