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
#import "NSString+KSMMath.h"
#import "KSMExpression.h"

@interface KSMMathValue()
{
    NSInteger _integerValue;
    double _doubleValue;
    KSMVector * _vectorValue;
    KSMMatrix * _matrixValue;
}

@end

@implementation KSMMathValue

+(KSMMathValue*)mathValueFromInteger:(NSInteger)i
{
    return [[KSMMathValue alloc] initWithInteger:i];
}

+(KSMMathValue*)mathValueFromDouble:(double)d
{
    return [[KSMMathValue alloc] initWithDouble:d];
}

+(KSMMathValue*)mathValueFromVector:(KSMVector *)v
{
    return [[KSMMathValue alloc] initWithVector:v];
}

+(KSMMathValue*)mathValueFromMatrix:(KSMMatrix *)m
{
    return [[KSMMathValue alloc] initWithMatrix:m];
}

+(KSMMathValue*)mathValueFromValue:(KSMMathValue *)v
{
    return [[KSMMathValue alloc] initWithValue:v];
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(id)initWithInteger:(NSInteger)anInteger
{
    self = [self init];
    _type = KSMValueInteger;
    _integerValue = anInteger;
    return self;
}

-(id)initWithDouble:(double)aDouble
{
    self = [self init];
    _type = KSMValueDouble;
    _doubleValue = aDouble;
    return self;
}

-(id)initWithVector:(KSMVector*)vectorValue
{
    self = [self init];
    _type = KSMValueVector;
    _vectorValue = vectorValue;
    return self;
}

-(id)initWithMatrix:(KSMMatrix*)matrixValue
{
    self = [self init];
    _type = KSMValueMatrix;
    _matrixValue = matrixValue;
    return self;
}

-(id)initWithValue:(KSMMathValue *)value
{
    switch (value.type) {
        case KSMValueInteger:
            return [self initWithInteger:value.integerValue];
        case KSMValueDouble:
            return [self initWithDouble:value.doubleValue];
        case KSMValueVector:
            return [self initWithVector:value.vectorValue];
        case KSMValueMatrix:
            return [self initWithMatrix:value.matrixValue];
    }
}

-(NSInteger)valueAsInteger
{
    switch (_type) {
        case KSMValueInteger:
            return self.integerValue;
        case KSMValueDouble:
            return (NSInteger)self.doubleValue;
        default:
            [NSException raise:@"This KSMValueType is either a vector or a matrix." format:nil];
            return 0;
    }
}

-(double)valueAsDouble
{
    switch (_type) {
        case KSMValueInteger:
            return (double)self.integerValue;
        case KSMValueDouble:
            return self.doubleValue;
        default:
            [NSException raise:@"This KSMValueType is either a vector or a matrix." format:nil];
            return 0;
    }
}

+(KSMValueType)valueTypeForVariableName:(NSString *)variableName
{
    NSString * integerType = @"i_";
    NSString * doubleType  = @"f_";
    NSString * vectorType  = @"v_";
    NSString * matrixType  = @"m_";
    
    if ([variableName hasPrefix:vectorType]) {
        return KSMValueVector;
    }
    
    if ([variableName hasPrefix:matrixType]) {
        return KSMValueMatrix;
    }

    if ([variableName hasPrefix:integerType]) {
        return KSMValueInteger;
    }

    if ([variableName hasPrefix:doubleType]) {
        return KSMValueDouble;
    }

    return KSMValueDouble;
}

-(id)copyWithZone:(NSZone *)zone
{
    switch (self.type) {
        case KSMValueInteger:
            return [[KSMMathValue alloc] initWithInteger:[self valueAsInteger]];
        case KSMValueDouble:
            return [[KSMMathValue alloc] initWithDouble:[self valueAsDouble]];
        case KSMValueVector:
            return [[KSMMathValue alloc] initWithVector:[[self vectorValue] copy]];
        case KSMValueMatrix:
            return [[KSMMathValue alloc] initWithMatrix:[[self matrixValue] copy]];
    }
}

+(KSMMathValue *) mathValueFromLeftMathValue:(KSMMathValue*)left
                                    operator:(NSString*)operator
                              rightMathValue:(KSMMathValue*)right
{
    KSMOperatorType operatorType = [KSMExpression operatorTypeFromString:operator];
    switch (operatorType) {
        case KSMOperatorTypeAdd:
            return [left mathValueByAdding:right];
        case KSMOperatorTypeSubtract:
            return [left mathValueBySubtracting:right];
        case KSMOperatorTypeMultiply:
            return [left mathValueByMultiplying:right];
        case KSMOperatorTypeDivide:
            return [left mathValueByDividing:right];
        case KSMOperatorTypeScalarMultiply:
            return [left mathValueByMultiplying:right];
        case KSMOperatorTypePower:
            return [left mathValueByRaisingToPower:right];
        case KSMOperatorTypeVectorMultiply:
            return [left mathValueByVectorMultiplying:right];
        case KSMOperatorTypeUnrecognized:
            return nil;
    }
}

-(KSMMathValue*)mathValueByAdding:(KSMMathValue*)other
{
    // Handle integer and floating point operation
    if (self.isNumericType && other.isNumericType) {
        if (self.type == KSMValueInteger && other.type == KSMValueInteger) {
            return [KSMMathValue mathValueFromInteger:(self.integerValue + other.integerValue)];
        } else {
            return [KSMMathValue mathValueFromDouble:(self.doubleValue + other.doubleValue)];
        }
    }
    
    // Handle vector operation
    if (self.type == KSMValueVector && other.type == KSMValueVector) {
        KSMVector * a = self.vectorValue;
        KSMVector * b = other.vectorValue;
        return [KSMMathValue mathValueFromVector:[a vectorByAdding:b]];
    }
    
    // Handle matrix operation
    if (self.type == KSMValueMatrix && other.type == KSMValueMatrix) {
        KSMMatrix * a = self.matrixValue;
        KSMMatrix * b = other.matrixValue;
        return [KSMMathValue mathValueFromMatrix:[a matrixByAddingMatrix:b]];
    }
    
    return nil;
}

-(KSMMathValue*)mathValueBySubtracting:(KSMMathValue*)other
{
    // Handle integer and floating point operation
    if (self.isNumericType && other.isNumericType) {
        if (self.type == KSMValueInteger && other.type == KSMValueInteger) {
            return [KSMMathValue mathValueFromInteger:(self.integerValue - other.integerValue)];
        } else {
            return [KSMMathValue mathValueFromDouble:(self.doubleValue - other.doubleValue)];
        }
    }
    
    // Handle vector operation
    if (self.type == KSMValueVector && other.type == KSMValueVector) {
        KSMVector * a = self.vectorValue;
        KSMVector * b = other.vectorValue;
        return [KSMMathValue mathValueFromVector:[a vectorBySubtracting:b]];
    }
    
    // Handle matrix operation
    if (self.type == KSMValueMatrix && other.type == KSMValueMatrix) {
        KSMMatrix * a = self.matrixValue;
        KSMMatrix * b = other.matrixValue;
        return [KSMMathValue mathValueFromMatrix:[a matrixBySubtractingMatrix:b]];
    }
    return nil;
}

-(KSMMathValue*)mathValueByMultiplying:(KSMMathValue *)other
{
    if (self.isNumericType && other.isNumericType) {
        // Handle integer and floating point additions
        if (self.type == KSMValueInteger && other.type == KSMValueInteger) {
            return [KSMMathValue mathValueFromInteger:(self.integerValue * other.integerValue)];
        } else {
            return [KSMMathValue mathValueFromDouble:(self.doubleValue * other.doubleValue)];
        }
        
        // Handle vector additions
        if (self.type == KSMValueVector && other.type == KSMValueVector) {
            KSMVector * a = self.vectorValue;
            KSMVector * b = other.vectorValue;
            return [a scalarProductWith:b];
        }
        
        // Handle matrix additions
        if (self.type == KSMValueMatrix && other.type == KSMValueMatrix) {
            KSMMatrix * a = self.matrixValue;
            KSMMatrix * b = other.matrixValue;
            return [KSMMathValue mathValueFromMatrix:[a matrixByRightMultiplyingByMatrix:b]];
        }
    }
    
    return nil;
}

-(KSMMathValue*)mathValueByDividing:(KSMMathValue*)denominator
{
    // Handle integer and floating point operation
    if (self.isNumericType && denominator.isNumericType) {
        if (self.type == KSMValueInteger && denominator.type == KSMValueInteger) {
            return [KSMMathValue mathValueFromInteger:(self.integerValue / denominator.integerValue)];
        } else {
            return [KSMMathValue mathValueFromDouble:(self.doubleValue / denominator.doubleValue)];
        }
    }
    
    // Handle vector operation
    if (self.type == KSMValueVector && denominator.type == KSMValueVector) {
        return nil;
    }
    
    // Handle matrix operation
    if (self.type == KSMValueMatrix && denominator.type == KSMValueMatrix) {
        KSMMatrix * a = self.matrixValue;
        KSMMatrix * b = [denominator.matrixValue matrixByInverting];
        return [KSMMathValue mathValueFromMatrix:[a matrixByRightMultiplyingByMatrix:b]];
    }
    
    return nil;
}

-(KSMMathValue*)mathValueByVectorMultiplying:(KSMMathValue*)rightVector
{
    if (self.type != KSMValueVector || self.type != rightVector.type ) return nil;
    KSMVector * a = self.vectorValue;
    KSMVector * b = rightVector.vectorValue;
    return [KSMMathValue mathValueFromVector:[a vectorProductWith:b]];
}

-(KSMMathValue*)mathValueByRaisingToPower:(KSMMathValue *)exponent
{
    // Handle integer and floating point additions
    if (self.isNumericType && exponent.isNumericType) {
        double a = self.doubleValue;
        double x = exponent.doubleValue;
        double result = pow(a,x);
        return [KSMMathValue mathValueFromDouble:result];
    }
        
    // Handle vector operation
    if (self.type == KSMValueVector) {
        return nil;
    }
    
    // Handle matrix operation
    if (self.type == KSMValueMatrix && exponent.type == KSMValueInteger) {
        KSMMatrix * a = self.matrixValue;
        return [KSMMathValue mathValueFromMatrix:[a matrixByRaisingToIntegerPower:exponent]];
    }
    
    return nil;
}


-(BOOL)isNumericType
{
    return [KSMMathValue isNumericType:self];
}

+(BOOL)isNumericType:(KSMMathValue*)value
{
    switch (value.type) {
        case KSMValueInteger: case KSMValueDouble:
            return YES;
        default:
            return NO;
    }
}

@end
