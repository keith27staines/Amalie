//
//  KSMFunctionArgument.h
//  Amalie
//
//  Created by Keith Staines on 27/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class KSMMathValue;

#import <Foundation/Foundation.h>
#import "KSMMathValue.h"

@interface KSMFunctionArgument : NSObject

@property (readonly, copy) NSString * name;

/*! The value can be set at any time, but the type of the value must conform to the type of value set when the receiver was first initialized (and as returned by the type property).
 */
@property (strong, readwrite) KSMMathValue * mathValue;

@property (readonly) KSMValueType type;

/*! The designated initializer.
 @Param name The name of the argument.
 @Param value The initial value of the argument. The initial value determines  the type of the argument. The value can be changed later but only if the type remains the same.
 @Return The initialized object.
 */
- (id)initWithName:(NSString*)name mathValue:(KSMMathValue*)value;

@end
