//
//  KSMMathValue.h
//  Amalie
//
//  Created by Keith Staines on 29/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class KSMVector;
@class KSMMatrix;
@class KSMExpression;
@class KSMExpressionEvaluator;

extern NSInteger const KSMIntegerMax;
extern NSInteger const KSMIntegerMin;

typedef enum KSMValueType : NSUInteger {
    KSMValueInteger = 0,
    KSMValueDouble  = 1,
    KSMValueVector  = 2,
    KSMValueMatrix  = 3,
} KSMValueType;


#import <Foundation/Foundation.h>

@interface KSMMathValue : NSObject <NSCopying, NSCoding>

@property (readonly) NSInteger         integerValue;
@property (readonly) double            doubleValue;
@property (readonly, copy) KSMVector * vectorValue;
@property (readonly, copy) KSMMatrix * matrixValue;
@property (readonly) KSMValueType      type;

/*! Initializer @Returns an initialized object wrapping an integer */
-(id)initWithInteger:(NSInteger)anInteger;

/*! Initializer @Returns an initialized object wrapping a double */
-(id)initWithDouble:(double)aDouble;

/*! Initializer @Returns an initialized object wrapping a vector */
-(id)initWithVector:(KSMVector*)vectorValue;

/*! Initializer @Returns an initialized object wrapping a matrix */
-(id)initWithMatrix:(KSMMatrix*)matrixValue;

/*! Initializer
 @Param value The value serves as a template from which the receiver is copied.
 @Returns an initialized object by copying the specified object. */
-(id)initWithValue:(KSMMathValue*)value;

-(id)initWithValueType:(KSMValueType)valueType;

-(id)initWithString:(NSString*)string;

-(id)initWithExpression:(KSMExpression*)expression
         usingEvaluator:(KSMExpressionEvaluator*)evaluator;

+(KSMMathValue*)mathValueFromValueType:(KSMValueType)valueType;
+(KSMMathValue*)mathValueFromInteger:(NSInteger)i;
+(KSMMathValue*)mathValueFromDouble:(double)d;
+(KSMMathValue*)mathValueFromVector:(KSMVector*)v;
+(KSMMathValue*)mathValueFromMatrix:(KSMMatrix*)m;
+(KSMMathValue*)mathValueFromValue:(KSMMathValue*)v;
+(KSMMathValue*)mathValueFromString:(NSString*)s;
+(KSMMathValue*)mathValueFromExpression:(KSMExpression*)expression
                         usingEvaluator:(KSMExpressionEvaluator*)evaluator;

+(KSMMathValue *) mathValueFromLeftMathValue:(KSMMathValue*)left
                                    operator:(NSString*)operator
                              rightMathValue:(KSMMathValue*)right;


-(KSMMathValue*)mathValueByAdding:(KSMMathValue*)other;
-(KSMMathValue*)mathValueBySubtracting:(KSMMathValue*)other;
-(KSMMathValue*)mathValueByMultiplying:(KSMMathValue*)other;
-(KSMMathValue*)mathValueByDividing:(KSMMathValue*)denominator;
-(KSMMathValue*)mathValueByVectorMultiplying:(KSMMathValue*)rightVector;
-(KSMMathValue*)mathValueByRaisingToPower:(KSMMathValue*)exponent;

+(BOOL)isNumericType:(KSMMathValue*)value;
-(BOOL)isNumericType;

/*!
 Use this method to implement the naming convention. The name of a variable can
 be prefixed by "x_", where x in one of the naming convention characters and is
 intended to indicate the type of variable the name refers to.
 @Param variableName The name of a variable. The following prefixes are recognised:
 i_ => integer
 f_ => float
 v= => vector
 m_ =>matrix
 @Returns the KSMValueType that is, by naming convention, associated with the
 name's prefix.
 */
+(KSMValueType)valueTypeForVariableName:(NSString*)variableName;


@end
