//
//  KSMMathValue.m
//  Amalie
//
//  Created by Keith Staines on 29/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMMathValue.h"
#import "KSMVector.h"
#import "KSMMatrix.h"

@implementation KSMMathValue


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(id)initWithInteger:(NSInteger)anInteger
{
    return [self initWithIntegerValue:@(anInteger)];
}

-(id)initWithDouble:(double)aDouble
{
    return [self initWithDoubleValue:@(aDouble)];
}

-(id)initWithIntegerValue:(NSNumber*)integerValue
{
    self = [self init];
    _type = KSMValueInteger;
    _integerValue = integerValue;
    return self;
}

-(id)initWithDoubleValue:(NSNumber*)doubleValue
{
    self = [self init];
    _type = KSMValueDouble;
    _doubleValue = doubleValue;
    return self;
}

-(id)initWithVectorValue:(KSMVector*)vectorValue
{
    self = [self init];
    _type = KSMValueVector;
    _vectorValue = vectorValue;
    return self;
}

-(id)initWithMatrixValue:(KSMMatrix*)matrixValue
{
    self = [self init];
    _type = KSMValueMatrix;
    _matrixValue = matrixValue;
    return self;
}

-(NSInteger)valueAsInteger
{
    switch (_type) {
        case KSMValueInteger:
            return [self.integerValue integerValue];
        case KSMValueDouble:
            return (NSInteger)[self.doubleValue doubleValue];
        default:
            [NSException raise:@"This KSMValueType is either a vector or a matrix." format:nil];
            return 0;
    }
}

-(double)valueAsDouble
{
    switch (_type) {
        case KSMValueInteger:
            return (double)[self.integerValue integerValue];
        case KSMValueDouble:
            return [self.doubleValue doubleValue];
        default:
            [NSException raise:@"This KSMValueType is either a vector or a matrix." format:nil];
            return 0;
    }
}

@end
