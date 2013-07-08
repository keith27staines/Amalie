//
//  KSMPrimeDecomposition.h
//  KSMath
//
//  Created by Keith Staines on 16/06/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KSMPrimeDecomposition : NSObject

@property (readwrite) NSInteger integerValue;
@property (readonly) NSUInteger primeCount;

-(id)initWithInteger:(NSInteger)integer;

-(NSUInteger)primeAtIndex:(NSUInteger)index;
-(NSUInteger)primePowerAtIndex:(NSUInteger)index;

@end
