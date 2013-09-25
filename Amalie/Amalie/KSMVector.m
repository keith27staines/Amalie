//
//  KSMVector.m
//  Amalie
//
//  Created by Keith Staines on 29/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMVector.h"
#import "KSMMathValue.h"

static KSMVector * _zero3DVector;

@interface KSMVector()
{
    NSArray           * _array;
}

@property (readwrite) NSArray * array;
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

-(KSMMathValue*)x1
{
    return _array[0];
}
-(KSMMathValue*)x2
{
    return _array[1];
}
-(KSMMathValue*)x3
{
    return _array[2];
}

-(KSMMathValue*)r
{
    return _array[0];
}
-(KSMMathValue*)theta
{
    return _array[1];
}
-(KSMMathValue*)phi
{
    return _array[2];
}


-(KSMMathValue*)x
{
    return _array[0];
}
-(KSMMathValue*)y
{
    return _array[1];
}
-(KSMMathValue*)z
{
    return _array[2];
}

- (id)init
{
    return [self initWithComponents:@[@0, @0, @0]];
}

- (id)initWithComponents:(NSArray*)components
{
    self = [super init];
    if (self) {
        _array = [components copy];
    }
    return self;
}

-(id)init2DWithXComponent:(NSNumber*)x yComponent:(NSNumber*)y
{
    self = [self initWithComponents:@[x , y, @(0)] ];
    return self;
}

-(id)init3DWithXComponent:(NSNumber*)x yComponent:(NSNumber*)y zComponent:(NSNumber*)z
{
    self = [self initWithComponents:@[x , y, z ] ];
    return self;
}

+(KSMVector*)zero2DVector
{
    return [KSMVector zero3DVector];
}

+(KSMVector*)zero3DVector
{
    if (!_zero3DVector) {
        _zero3DVector = [[KSMVector alloc] init];
    }
    return _zero3DVector;
}

-(NSUInteger)dimension
{
    return self.array.count;
}

+(KSMVector*)unitVectorFrom:(KSMVector*)vector
{
    return nil;
}

-(KSMVector*)unitVector
{
    return [KSMVector unitVectorFrom:self];
}

+(KSMVector*)vectorByAdding:(KSMVector*)u and:(KSMVector *)v
{
    return nil;
}

-(KSMVector*)vectorByAdding:(KSMVector*)rightVector
{
    return [KSMVector vectorByAdding:rightVector and:self];
}

+(KSMVector*)vectorBySubtracting:(KSMVector *)u from:(KSMVector*)v
{
    return nil;
}

-(KSMVector*)vectorBySubtracting:(KSMVector *)rightVector
{
    return [KSMVector vectorBySubtracting:rightVector from:self];
}

+(KSMVector*)vectorFromProductLeft:(KSMVector*)left withRight:(KSMVector*)right
{
    return nil;
}

-(KSMVector*)vectorProductWith:(KSMVector *)rightVector
{
    return [KSMVector vectorFromProductLeft:self withRight:rightVector];
}

+(KSMMathValue*)scalarProduct:(KSMVector*)u with:(KSMVector*)v
{
    return nil;
}

-(KSMMathValue*)scalarProductWith:(KSMVector*)otherVector
{
    return [KSMVector scalarProduct:self with:otherVector];
}

-(KSMMathValue*)magnitude
{
    return nil;
}

-(KSMMathValue*)magnitudeSquared
{
    return nil;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.array forKey:@"array"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.array = [decoder decodeObjectForKey:@"array"];
    return self;
}

@end
