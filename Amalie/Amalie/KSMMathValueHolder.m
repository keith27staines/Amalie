//
//  KSMMathValueHolder.m
//  Amalie
//
//  Created by Keith Staines on 16/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMMathValueHolder.h"
#import "KSMVector.h"
#import "KSMMatrix.h"

@interface KSMMathValueHolder()
{
    KSMMathValue * _mathValue;
}

@end

@implementation KSMMathValueHolder

- (id)initWithName:(NSString *)name symbol:(NSString *)symbol mathValue:(KSMMathValue *)mathValue
{
    self = [super init];
    if (self) {
        _name = [name copy];
        _symbol = [symbol copy];
        _mathValue = [mathValue copy];
        _type = mathValue.type;
    }
    return self;
}

-(id)initWithName:(NSString *)name symbol:(NSString *)symbol
{
    KSMMathValue * mv = nil;
    KSMValueType valueType = [KSMMathValue valueTypeForVariableName:name];
    switch (valueType) {
        case KSMValueInteger:
            mv = [KSMMathValue mathValueFromInteger:0];
            break;
        case KSMValueDouble:
            mv = [KSMMathValue mathValueFromDouble:0.0];
            break;
        case KSMValueVector:
            mv = [KSMMathValue mathValueFromVector:[KSMVector zero3DVector]];
            break;
        case KSMValueMatrix:
            mv = [KSMMathValue mathValueFromMatrix:[[KSMMatrix alloc] initWithRows:3 columns:3]];
            break;
    }
    return [self initWithName:name symbol:symbol mathValue:mv];
}

-(void)setMathValue:(KSMMathValue *)mathValue
{
    if (mathValue.type == self.type) {
        _mathValue = mathValue;
    } else {
        NSLog(@"The specified mathValue has a different type from the type of this variable.");
    }
}

-(KSMMathValue*)mathValue
{
    return _mathValue;
}

@end
