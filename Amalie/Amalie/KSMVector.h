//
//  KSMVector.h
//  Amalie
//
//  Created by Keith Staines on 29/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KSMVector : NSObject <NSCopying>

@property (readonly, copy) NSArray      * componentsArray;
@property (readonly) float x1;
@property (readonly) float x2;
@property (readonly) float x3;
@property (readonly) float r;
@property (readonly) float theta;
@property (readonly) float phi;
@property (readonly) float x;
@property (readonly) float y;
@property (readonly) float z;
@property (readonly) NSUInteger dimension;

+(id)zero3DVector;

-(id)initWithComponents:(NSArray*)components;
-(id)init2DWithXComponent:(NSNumber*)x yComponent:(NSNumber*)y;
-(id)init3DWithXComponent:(NSNumber*)x yComponent:(NSNumber*)y zComponent:(NSNumber*)z;

@end
