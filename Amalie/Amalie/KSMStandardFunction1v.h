//
//  KSMStandardFunction1v.h
//  Amalie
//
//  Created by Keith Staines on 30/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMFunction.h"

typedef enum KSMStandardFunctions : NSUInteger {
    // numeric functions
    KSMStandardFunctionZeroFn = 0,
    KSMStandardFunctionUnitFn,
    KSMStandardFunctionStepFn,
    KSMStandardFunctionSignFn,
    KSMStandardFunctionAbsFn,
    KSMStandardFunctionIdentityFn,
    KSMStandardFunctionSqrtFn,
    // exponential and log
    KSMStandardFunctionExpFn,
    KSMStandardFunctionLogeFn,
    KSMStandardFunctionLog10Fn,
    // trig functions
    KSMStandardFunctionSineFn,
    KSMStandardFunctionCosineFn,
    KSMStandardFunctionTangentFn,
    KSMStandardFunctionCosecantFn,
    KSMStandardFunctionSecantFn,
    KSMStandardFunctionCotangentFn,
    // inverse trig functions
    KSMStandardFunctionArcSineFn,
    KSMStandardFunctionArcCosineFn,
    KSMStandardFunctionArcTangentFn,
    KSMStandardFunctionArcCosecantFn,
    KSMStandardFunctionArcSecantFn,
    KSMStandardFunctionArcCotangentFn,
    // Hyperbolic functions
    KSMStandardFunctionSinhFn,
    KSMStandardFunctionCoshFn,
    KSMStandardFunctionTanhFn,
    KSMStandardFunctionCosechFn,
    KSMStandardFunctionSechFn,
    KSMStandardFunctionCothFn,
    // inverse hyperbolic functions
    KSMStandardFunctionArcSinhFn,
    KSMStandardFunctionArcCoshFn,
    KSMStandardFunctionArcTanhFn,
    KSMStandardFunctionArcCosechFn,
    KSMStandardFunctionArcSechFn,
    KSMStandardFunctionArcCothFn,
}KSMStandardFunctions;

@interface KSMStandardFunction1v : KSMFunction

- (id)initWithFunctionType:(KSMStandardFunctions)functionType;
+(NSArray*)standardFunctionsArray;


@end
