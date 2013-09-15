//
//  KSMMathValue.h
//  Amalie
//
//  Created by Keith Staines on 29/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class KSMVector;
@class KSMMatrix;

typedef enum KSMValueType : NSUInteger {
    KSMValueInteger = 0,
    KSMValueDouble  = 1,
    KSMValueVector  = 2,
    KSMValueMatrix  = 3,
} KSMValueType;


#import <Foundation/Foundation.h>

@interface KSMMathValue : NSObject <NSCopying>

@property (readonly) NSInteger         integerValue;
@property (readonly) double            doubleValue;
@property (readonly, copy) KSMVector * vectorValue;
@property (readonly, copy) KSMMatrix * matrixValue;
@property (readonly) KSMValueType type;

+(KSMValueType)valueTypeForVariableName:(NSString*)variableName;
+(BOOL)isNumericType:(KSMMathValue*)value;
-(BOOL)isNumericType;

-(id)initWithInteger:(NSInteger)anInteger;
-(id)initWithDouble:(double)aDouble;
-(id)initWithVector:(KSMVector*)vectorValue;
-(id)initWithMatrix:(KSMMatrix*)matrixValue;
-(id)initWithValue:(KSMMathValue*)value;

+(KSMMathValue*)mathValueFromInteger:(NSInteger)i;
+(KSMMathValue*)mathValueFromDouble:(double)d;
+(KSMMathValue*)mathValueFromVector:(KSMVector*)v;
+(KSMMathValue*)mathValueFromMatrix:(KSMMatrix*)m;
+(KSMMathValue*)mathValueFromValue:(KSMMathValue*)v;

-(KSMMathValue*)mathValueByAdding:(KSMMathValue*)other;
-(KSMMathValue*)mathValueBySubtracting:(KSMMathValue*)other;
-(KSMMathValue*)mathValueByMultiplying:(KSMMathValue*)other;
-(KSMMathValue*)mathValueByDividing:(KSMMathValue*)denominator;
-(KSMMathValue*)mathValueByVectorMultiplying:(KSMMathValue*)rightVector;
-(KSMMathValue*)mathValueByRaisingToPower:(KSMMathValue*)exponent;

@end
