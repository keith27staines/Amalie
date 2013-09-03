//
//  KSMVector.m
//  Amalie
//
//  Created by Keith Staines on 29/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMVector.h"


static KSMVector * _zero3DVector;

@interface KSMVector()
{
    NSUInteger          _dimension;
    NSArray           * _array;
}

@end


@implementation KSMVector

-(id)copyWithZone:(NSZone *)zone
{
    return nil;
}

-(id)copy
{
    return [self copyWithZone:nil];
}

-(NSArray *)componentsArray
{
    return [_array copy];
}

-(float)x1
{
    return [_array[0] floatValue];
}
-(float)x2
{
    return [_array[1] floatValue];
}
-(float)x3
{
    return [_array[2] floatValue];
}

-(float)r
{
    return [_array[0] floatValue];
}
-(float)theta
{
    return [_array[1] floatValue];
}
-(float)phi
{
    return [_array[2] floatValue];
}


-(float)x
{
    return [_array[0] floatValue];
}
-(float)y
{
    return [_array[1] floatValue];
}
-(float)z
{
    return [_array[2] floatValue];
}

- (id)init
{
    return [self initWithComponents:@[@0, @0, @0]];
}

- (id)initWithComponents:(NSArray*)components
{
    self = [super init];
    if (self) {
        _dimension = [components count];
        _array = components;
    }
    return self;
}

-(id)init2DWithXComponent:(NSNumber*)x yComponent:(NSNumber*)y
{
    self = [self initWithComponents:@[x , y, @(0)] ];
    _dimension = 2;
    return self;
}

-(id)init3DWithXComponent:(NSNumber*)x yComponent:(NSNumber*)y zComponent:(NSNumber*)z
{
    self = [self initWithComponents:@[x , y, z ] ];
    _dimension = 3;
    return self;
}


+(id)zero3DVector
{
    if (!_zero3DVector) {
        _zero3DVector = [[KSMVector alloc] init];
    }
    return _zero3DVector;
}

-(NSUInteger)dimension
{
    return _dimension;
}


@end
