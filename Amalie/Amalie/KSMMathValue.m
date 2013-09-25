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
#import "KSMExpressionEvaluator.h"
#import "KSMWorksheet.h"

NSInteger const KSMIntegerMax = NSIntegerMax;
NSInteger const KSMIntegerMin = NSIntegerMin;

@interface KSMMathValue()
{
    NSInteger _integerValue;
    double _doubleValue;
    KSMVector * _vectorValue;
    KSMMatrix * _matrixValue;
}

@property (readwrite) NSInteger         integerValue;
@property (readwrite) double            doubleValue;
@property (readwrite, copy) KSMVector * vectorValue;
@property (readwrite, copy) KSMMatrix * matrixValue;
@property (readwrite) KSMValueType      type;
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

+(KSMMathValue*)mathValueFromString:(NSString *)s
{
    return [[KSMMathValue alloc] initWithString:s];
}

-(id)initWithString:(NSString *)string
{
    NSDecimalNumber * n = [NSDecimalNumber decimalNumberWithString:string];
    BOOL isNumber = [n isEqualToNumber:[NSDecimalNumber notANumber]];
    if ( !isNumber ) {
        // Programming error somewhere...
        NSAssert(isNumber, @"The string %@ cannot be interpreted as a number.",string);
        return nil;
    }
    
    double d = [n doubleValue];
    if ( d > KSMIntegerMax || d < KSMIntegerMin ) {
        // Value too big to be represented by an NSInteger
        return [KSMMathValue mathValueFromDouble:d];
    }
    NSInteger i = interpretDoubleAsInteger(d);
    if ( (double)i == d ) {
        return [KSMMathValue mathValueFromInteger:i];
    } else {
        return [KSMMathValue mathValueFromDouble:d];
    }
}

+(KSMMathValue*)mathValueFromExpression:(KSMExpression*)expression
                         usingEvaluator:(KSMExpressionEvaluator*)evaluator
{
    return [[KSMMathValue alloc] initWithExpression:expression
                                     usingEvaluator:evaluator];
}

-(id)initWithExpression:(KSMExpression*)expression
         usingEvaluator:(KSMExpressionEvaluator*)evaluator
{
    switch (expression.expressionType) {
        case KSMExpressionTypeLiteral:
        {
            return [KSMMathValue mathValueFromString:expression.bareString];
        }
        case KSMExpressionTypeVariable:
        {
            return [evaluator.worksheet variableForSymbol:expression.symbol];
        }
        case KSMExpressionTypeBinary:
        {
            KSMExpression * leftExpression;
            KSMExpression * rightExpression;
            KSMMathValue  * leftValue;
            KSMMathValue  * rightValue;
            NSString * operator = expression.operator;
            [evaluator getLeftOperandResult:&leftExpression
                        rightOperandResult:&rightExpression
                            fromExpression:expression];
            leftValue  = [KSMMathValue mathValueFromExpression:leftExpression
                                                usingEvaluator:evaluator];
            rightValue = [KSMMathValue mathValueFromExpression:rightExpression
                                                usingEvaluator:evaluator];

            return [KSMMathValue mathValueFromLeftMathValue:leftValue
                                                   operator:operator
                                             rightMathValue:rightValue];
        }
        default:
            return nil;
    }
    
    return nil;
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
    if (!left || ! right || !operator) return nil;
    
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


-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt64:self.type forKey:@"type"];
    switch (self.type) {
        case KSMValueInteger:
            [coder encodeDouble:self.integerValue forKey:@"integerValue"];
            break;
        case KSMValueDouble:
            [coder encodeDouble:self.doubleValue forKey:@"doubleValue"];
            break;
        case KSMValueVector:
            [coder encodeObject:self.vectorValue forKey:@"vectorValue"];
            break;
        case KSMValueMatrix:
            [coder encodeObject:self.matrixValue forKey:@"matrixValue"];
            break;
    }
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.type = [decoder decodeIntegerForKey:@"type"];
    switch (self.type) {
        case KSMValueInteger:
            self.integerValue = [decoder decodeIntegerForKey:@"integerValue"];
            break;
        case KSMValueDouble:
            self.doubleValue = [decoder decodeDoubleForKey:@"doubleValue"];
            break;
        case KSMValueVector:
            self.vectorValue = [decoder decodeObjectForKey:@"vectorValue"];
            break;
        case KSMValueMatrix:
            self.matrixValue = [decoder decodeObjectForKey:@"matrixValue"];
            break;
    }
    return self;
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

/*!
 * If the double has no fractional part (in otherwords, can be interpreted as an
 * integer with no loss of precision, then this function returns that double. If
 * the fractional part is non-zero, then NAN is returned.
 * @Param d The double to investigate.
 * @Return An integer exactly equivalent to d if d has no fractional part,
 * otherwise returns the integer NAN.
 */
NSInteger interpretDoubleAsInteger(double d)
{
    return ( (d - (NSInteger)d)==0 ) ? (NSInteger)d : NAN;
}

@end
