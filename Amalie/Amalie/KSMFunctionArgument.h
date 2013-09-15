//
//  KSMFunctionArgument.h
//  Amalie
//
//  Created by Keith Staines on 27/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class KSMMathValue;
@class KSMFunction;

#import <Foundation/Foundation.h>
#import "KSMMathValue.h"

@interface KSMFunctionArgument : NSObject

@property (readonly, copy) NSString * name;

/*! The value can be set at any time, but the type of the value must conform to the type of value set when the receiver was first initialized (and as returned by the type property).
 */
@property (strong, readwrite) KSMMathValue * mathValue;

/*! The transform function can be set at any time, but the return type of function must conform to the type of value set when the receiver was first initialized (and as returned by the type property). An exception is thrown if the transform function returns the wrong type. Note that if the transform function is not specified, then the identity function will be used in its place.
 */
@property (weak, readwrite) KSMFunction * transform;

/*! The type specifies the type of mathematical object that the receiver holds.
 */
@property (readonly) KSMValueType type;

/*! The designated initializer.
 @Param name The name of the argument.
 @Param value The initial value of the argument. The initial value determines  the type of the argument. The value can be changed later but only if the type remains the same.
 @Return The initialized object.
 */
- (id)initWithName:(NSString*)name mathValue:(KSMMathValue*)value;

/*! Evaluate the argument using the value currently stored in mathValue, transformed by the transform function if specified.
 @Return The argument's value, evaluated using the value stored in mathValue, and then transformed by the transform function. If no transform function has been specified, then the identity function is used, and thus this method returns the value stored in mathValue.
 */
-(KSMMathValue*)evaluate;

/*! Evaluate the function using the specified value after transformation with the transformation function (if specified, otherwise the identity function will be used, thus effectively returning the specified value), while leaving the value currently stored in mathValue unchanged.
 @Param value The KSMMathValue that is the input to the argument.
 @Return The transformed value.
 */
-(KSMMathValue*)evaluateFromValue:(KSMMathValue*)value;


@end
