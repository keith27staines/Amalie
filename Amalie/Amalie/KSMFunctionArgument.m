//
//  KSMFunctionArgument.m
//  Amalie
//
//  Created by Keith Staines on 27/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMFunctionArgument.h"
#import "KSMFunction.h"
#import "KSMVector.h"
#import "KSMMatrix.h"

@implementation KSMFunctionArgument

-(id)init
{
    [NSException raise:@"Use the designated constructor." format:nil];
    return nil;
}

- (id)initWithName:(NSString*)name mathValue:(KSMMathValue*)value
{
    self = [super init];
    if (self) {
        _name = name;
        _mathValue = value;
    }
    return self;
}

-(id)initWithName:(NSString*)name type:(KSMValueType)type
{
    switch (type) {
        case KSMValueInteger:
            return [self initWithName:name mathValue:[[KSMMathValue alloc] initWithInteger:0]];
            break;
        case KSMValueDouble:
            return [self initWithName:name mathValue:[[KSMMathValue alloc] initWithDouble:0.0]];
            break;
        case KSMValueVector:
        {
            return [self initWithName:name mathValue:[[KSMMathValue alloc] initWithVector:[KSMVector zero3DVector]]];
            break;
        }
        case KSMValueMatrix:
        {
            KSMMatrix * m = [[KSMMatrix alloc] init];
            return [self initWithName:name mathValue:[[KSMMathValue alloc] initWithMatrix:m]];
        }
            
        default:
            break;
    }
}

-(KSMMathValue *)evaluate
{
    if (!self.transform) {
        return self.mathValue;
    } else {
        return [self.transform evaluateWithValues:@[self.mathValue]];
    }
}

-(KSMMathValue*)evaluateFromValue:(KSMMathValue *)value
{
    [self checkValueType:value];
    KSMMathValue * oldValue = self.mathValue;
    self.mathValue = value;
    KSMMathValue * result = [self evaluate];
    self.mathValue = oldValue;
    return result;
}

-(void)checkValueType:(KSMMathValue*)mathValue
{
    KSMValueType t = mathValue.type;
    if (t != self.type) {
        [NSException raise:@"The specified KSMMathValue has the wrong type." format:nil];
    }
}

@end
