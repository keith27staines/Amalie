//
//  KSMVector.h
//  Amalie
//
//  Created by Keith Staines on 29/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class KSMMathValue;

#import <Foundation/Foundation.h>


@interface KSMVector : NSObject <NSCopying>

@property (readonly, copy) NSArray      * componentsArray;
@property (readonly) KSMMathValue * x1;
@property (readonly) KSMMathValue * x2;
@property (readonly) KSMMathValue * x3;
@property (readonly) KSMMathValue * r;
@property (readonly) KSMMathValue * theta;
@property (readonly) KSMMathValue * phi;
@property (readonly) KSMMathValue * x;
@property (readonly) KSMMathValue * y;
@property (readonly) KSMMathValue * z;
@property (readonly) NSUInteger dimension;


+(KSMVector*)zero2DVector;
+(KSMVector*)zero3DVector;

-(id)initWithComponents:(NSArray*)components;
-(id)init2DWithXComponent:(NSNumber*)x yComponent:(NSNumber*)y;
-(id)init3DWithXComponent:(NSNumber*)x yComponent:(NSNumber*)y zComponent:(NSNumber*)z;

+(KSMVector*)unitVectorFrom:(KSMVector*)vector;
+(KSMVector*)vectorByAdding:(KSMVector *)u and:(KSMVector*)v;
+(KSMVector*)vectorBySubtracting:(KSMVector *)u from:(KSMVector*)v;
+(KSMVector*)vectorFromProductLeft:(KSMVector*)u withRight:(KSMVector*)v;
+(KSMMathValue*)scalarProduct:(KSMVector*)u with:(KSMVector*)v;

-(KSMVector*)unitVector;
-(KSMVector*)vectorByAdding:(KSMVector *)rightVector;
-(KSMVector*)vectorBySubtracting:(KSMVector *)rightVector;
-(KSMVector*)vectorProductWith:(KSMVector *)rightVector;
-(KSMMathValue*)scalarProductWith:(KSMVector*)otherVector;

-(KSMMathValue*)magnitude;
-(KSMMathValue*)magnitudeSquared;

@end
