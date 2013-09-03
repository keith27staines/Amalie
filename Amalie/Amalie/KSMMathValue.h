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

@interface KSMMathValue : NSObject

@property (readonly) NSNumber        * integerValue;
@property (readonly) NSNumber        * doubleValue;
@property (readonly, copy) KSMVector * vectorValue;
@property (readonly, copy) KSMMatrix * matrixValue;
@property (readonly) KSMValueType type;


-(id)initWithInteger:(NSInteger)anInteger;
-(id)initWithDouble:(double)aDouble;
-(id)initWithIntegerValue:(NSNumber*)integerValue;
-(id)initWithDoubleValue:(NSNumber*)doubleValue;
-(id)initWithVectorValue:(KSMVector*)vectorValue;
-(id)initWithMatrixValue:(KSMMatrix*)matrixValue;

-(double)valueAsDouble;
-(NSInteger)valueAsInteger;


@end
