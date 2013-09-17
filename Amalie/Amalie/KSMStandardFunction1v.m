//
//  KSMStandardFunction1v.m
//  Amalie
//
//  Created by Keith Staines on 30/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMStandardFunction1v.h"
#import "KSMFunctionArgumentList.h"
#import "KSMFunctionArgument.h"
#import "KSMMathValue.h"

NSMutableArray * ksm_standardFunctionsArray;

@interface KSMStandardFunction1v()
{
    KSMStandardFunctions      _functionType;
}

@end

@implementation KSMStandardFunction1v

// Keep aligned with KSMStandardFunctions enum
+(NSArray *)arrayOfStandardFunctionNames
{
    return @[
             //Numeric functions
             @"zero",  @"unit",  @"step",  @"sign",   @"sqrt",   @"abs", @"I",
             // exponential and log
             @"exp",   @"ln",    @"log",
             //trig functions
             @"sin",   @"cos",   @"tan",   @"cosec",   @"sec",   @"cot",
             // inverse trig functions
             @"asin",  @"acos",  @"atan",  @"acosec",  @"asec",  @"acot",
             // hyperbolic functions
             @"sinh",  @"cosh",  @"tanh",  @"cosech",  @"sech",  @"coth",
             // inverse hyperbolic functions
             @"asinh", @"acosh", @"atanh", @"acosech", @"asech", @"acoth"
             ];
}

// Keep aligned with KSMStandardFunctions enum
+(KSMStandardFunctions)functionTypeForName:(NSString*)name
{
    if ( ![[self arrayOfStandardFunctionNames] containsObject:name] ) {
        [NSException raise:@"Invalid function name."
                    format:@"'%@' is not the name of a standard function.",name];
    }
    
    // Numeric functions
    if ([name isEqualToString:@"zero"])    return KSMStandardFunctionZeroFn;
    if ([name isEqualToString:@"unit"])    return KSMStandardFunctionUnitFn;
    if ([name isEqualToString:@"step"])    return KSMStandardFunctionStepFn;
    if ([name isEqualToString:@"sign"])    return KSMStandardFunctionSignFn;
    if ([name isEqualToString:@"sqrt"])    return KSMStandardFunctionAbsFn;
    if ([name isEqualToString:@"abs"])     return KSMStandardFunctionIdentityFn;
    if ([name isEqualToString:@"I"])       return KSMStandardFunctionSqrtFn;
    // logs and exp
    if ([name isEqualToString:@"exp"])     return KSMStandardFunctionExpFn;
    if ([name isEqualToString:@"ln"])      return KSMStandardFunctionLogeFn;
    if ([name isEqualToString:@"log"])     return KSMStandardFunctionLog10Fn;
    // trig functions
    if ([name isEqualToString:@"sin"])     return KSMStandardFunctionSineFn;
    if ([name isEqualToString:@"cos"])     return KSMStandardFunctionCosineFn;
    if ([name isEqualToString:@"tan"])     return KSMStandardFunctionTangentFn;
    if ([name isEqualToString:@"cosec"])   return KSMStandardFunctionCosecantFn;
    if ([name isEqualToString:@"sec"])     return KSMStandardFunctionSecantFn;
    if ([name isEqualToString:@"cot"])     return KSMStandardFunctionCotangentFn;
    // inverse trig functions
    if ([name isEqualToString:@"asin"])    return KSMStandardFunctionArcSineFn;
    if ([name isEqualToString:@"acos"])    return KSMStandardFunctionArcCosineFn;
    if ([name isEqualToString:@"atan"])    return KSMStandardFunctionArcTangentFn;
    if ([name isEqualToString:@"acosec"])  return KSMStandardFunctionArcCosecantFn;
    if ([name isEqualToString:@"asec"])    return KSMStandardFunctionArcSecantFn;
    if ([name isEqualToString:@"acot"])    return KSMStandardFunctionArcCotangentFn;
    // hyperbolic functions
    if ([name isEqualToString:@"sinh"])    return KSMStandardFunctionSinhFn;
    if ([name isEqualToString:@"cosh"])    return KSMStandardFunctionCoshFn;
    if ([name isEqualToString:@"tanh"])    return KSMStandardFunctionTanhFn;
    if ([name isEqualToString:@"cosech"])  return KSMStandardFunctionCosechFn;
    if ([name isEqualToString:@"sech"])    return KSMStandardFunctionSechFn;
    if ([name isEqualToString:@"coth"])    return KSMStandardFunctionCothFn;
    // inverse hyperbolic functions
    if ([name isEqualToString:@"asinh"])   return KSMStandardFunctionArcSinhFn;
    if ([name isEqualToString:@"acosh"])   return KSMStandardFunctionArcCoshFn;
    if ([name isEqualToString:@"atanh"])   return KSMStandardFunctionArcTanhFn;
    if ([name isEqualToString:@"acosech"]) return KSMStandardFunctionArcCosechFn;
    if ([name isEqualToString:@"asech"])   return KSMStandardFunctionArcSechFn;
    if ([name isEqualToString:@"acoth"])   return KSMStandardFunctionArcCothFn;
    [NSException raise:@"Name appears to be valid but no mapping was found."
                format:@"Name was %@",name];
    return 0;
}


+(NSArray*)standardFunctionsArray
{
    if (!ksm_standardFunctionsArray) {
        ksm_standardFunctionsArray = [NSMutableArray array];
        for (NSString * fnName in [self arrayOfStandardFunctionNames]) {
            KSMStandardFunctions type = [KSMStandardFunction1v functionTypeForName:fnName];
            KSMStandardFunction1v * fn = [[KSMStandardFunction1v alloc] initWithFunctionType:type];
            [ksm_standardFunctionsArray addObject:fn];
        }

    }
    return ksm_standardFunctionsArray;
}



+(NSString*)standardFunctionNameFromType:(KSMStandardFunctions)functionType
{
    switch (functionType) {

        // numerical functions
        case KSMStandardFunctionZeroFn:             return @"zero";
        case KSMStandardFunctionUnitFn:             return @"unit";
        case KSMStandardFunctionStepFn:             return @"step";
        case KSMStandardFunctionSignFn:             return @"sign";
        case KSMStandardFunctionSqrtFn:             return @"sqrt";
        case KSMStandardFunctionAbsFn:              return @"abs";
        case KSMStandardFunctionIdentityFn:         return @"I";

        // exponential and logarithmic functions
        case KSMStandardFunctionExpFn:              return @"exp";
        case KSMStandardFunctionLogeFn:             return @"ln";
        case KSMStandardFunctionLog10Fn:            return @"log";

        // trig functions
        case KSMStandardFunctionSineFn:             return @"sin";
        case KSMStandardFunctionCosineFn:           return @"cos";
        case KSMStandardFunctionTangentFn:          return @"tan";
        case KSMStandardFunctionCosecantFn:         return @"cosec";
        case KSMStandardFunctionSecantFn:           return @"sec";
        case KSMStandardFunctionCotangentFn:        return @"cot";

        // inverse trig functions
        case KSMStandardFunctionArcSineFn:          return @"asin";
        case KSMStandardFunctionArcCosineFn:        return @"acos";
        case KSMStandardFunctionArcTangentFn:       return @"atan";
        case KSMStandardFunctionArcCosecantFn:      return @"acosec";
        case KSMStandardFunctionArcSecantFn:        return @"asec";
        case KSMStandardFunctionArcCotangentFn:     return @"acot";
            
        // hyperbolic functions
        case KSMStandardFunctionSinhFn:             return @"sinh";
        case KSMStandardFunctionCoshFn:             return @"cosh";
        case KSMStandardFunctionTanhFn:             return @"tanh";
        case KSMStandardFunctionCosechFn:           return @"cosech";
        case KSMStandardFunctionSechFn:             return @"sech";
        case KSMStandardFunctionCothFn:             return @"coth";

        // inverse hyperbolic functions
        case KSMStandardFunctionArcSinhFn:          return @"asinh";
        case KSMStandardFunctionArcCoshFn:          return @"acosh";
        case KSMStandardFunctionArcTanhFn:          return @"atanh";
        case KSMStandardFunctionArcCosechFn:        return @"acosech";
        case KSMStandardFunctionArcSechFn:          return @"asech";
        case KSMStandardFunctionArcCothFn:          return @"acoth";
        
    }
}

- (id)initWithFunctionType:(KSMStandardFunctions)functionType
{
    KSMMathValue * value = [[KSMMathValue alloc] initWithDouble:0.0];
    KSMFunctionArgumentList * argList = [[KSMFunctionArgumentList alloc] init];
    [argList addArgumentWithName:@"x" value:value];
    NSString * name = [KSMStandardFunction1v standardFunctionNameFromType:functionType];
    self = [super initWithArgumentList:argList returnType:KSMValueDouble name:name];
    if (self) {
        _functionType = functionType;
    }
    return self;
}

- (id)initWithFunctionName:(NSString*)name
{
    KSMStandardFunctions type = [KSMStandardFunction1v functionTypeForName:name];
    return [self initWithFunctionType:type];
}

- (id)initWithArgumentList:(KSMFunctionArgumentList *)argumentList
                returnType:(KSMValueType)returnType
{
    [NSException raise:@"Use the designated initializer." format:nil];
    return nil;
}

-(KSMMathValue *)evaluate
{
    KSMFunctionArgument * arg = [self.argumentList argumentAtIndex:0];
    KSMMathValue * mv = arg.mathValue;
    NSNumber * n = mv.value;
    double x = n.doubleValue;
    double d = 0.0;
    
    switch (_functionType) {
            
        // numerical functions
        case KSMStandardFunctionZeroFn:         d = 0.0; break;
        case KSMStandardFunctionUnitFn:         d = 1.0; break;
        case KSMStandardFunctionStepFn:         d = (x<1)?0.0:1.0;
        case KSMStandardFunctionSignFn:
        {
            if (x < 0)                          d = -1.0;
            else if (d == 0)                    d = 0.0;
            else                                d = 1.0;
             break;
        }
        case KSMStandardFunctionSqrtFn:         d = sqrt(x); break;
        case KSMStandardFunctionAbsFn:          d = fabs(x); break;
        case KSMStandardFunctionIdentityFn:     d = x; break;
            
        // exponential and logarithmic functions
        case KSMStandardFunctionExpFn:          d = exp(x); break;
        case KSMStandardFunctionLogeFn:         d = log(x); break;
        case KSMStandardFunctionLog10Fn:        d = log10(x); break;
            
        // trig functions
        case KSMStandardFunctionSineFn:         d = sin(x); break;
        case KSMStandardFunctionCosineFn:       d = cos(x); break;
        case KSMStandardFunctionTangentFn:      d = tan(x); break;
        case KSMStandardFunctionSecantFn:       d = 1.0/sin(x); break;
        case KSMStandardFunctionCosecantFn:     d = 1.0/cos(x); break;
        case KSMStandardFunctionCotangentFn:    d = 1.0/tan(x); break;
            
        // inverse trig functions
        case KSMStandardFunctionArcSineFn:      d = asin(x); break;
        case KSMStandardFunctionArcCosineFn:    d = acos(x); break;
        case KSMStandardFunctionArcTangentFn:   d = atan(x); break;
        case KSMStandardFunctionArcSecantFn:    d = 1.0/asin(x); break;
        case KSMStandardFunctionArcCosecantFn:  d = 1.0/acos(x); break;
        case KSMStandardFunctionArcCotangentFn: d = 1.0/atan(x); break;
            
        // hyperbolic functions
        case KSMStandardFunctionSinhFn:         d = sinh(x); break;
        case KSMStandardFunctionCoshFn:         d = cosh(x); break;
        case KSMStandardFunctionTanhFn:         d = tanh(x); break;
        case KSMStandardFunctionCosechFn:       d = 1.0/sinh(x); break;
        case KSMStandardFunctionSechFn:         d = 1.0/cosh(x); break;
        case KSMStandardFunctionCothFn:         d = 1.0/tanh(x); break;

        // inverse hyperbolic functions
        case KSMStandardFunctionArcSinhFn:      d = asinh(x); break;
        case KSMStandardFunctionArcCoshFn:      d = acosh(x); break;
        case KSMStandardFunctionArcTanhFn:      d = atanh(x); break;
        case KSMStandardFunctionArcCosechFn:    d = 1.0/asinh(x); break;
        case KSMStandardFunctionArcSechFn:      d = 1.0/acosh(x); break;
        case KSMStandardFunctionArcCothFn:      d = 1.0/atanh(x); break;
    }
    
    return [[KSMMathValue alloc] initWithDouble:d];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Standard function %@ ",self.name];
}

@end
