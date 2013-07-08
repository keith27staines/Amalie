//
//  KSMPrimeDecomposition.m
//  KSMath
//
//  Created by Keith Staines on 16/06/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMPrimeDecomposition.h"
#import "KSMPrimes.h"


@interface KSMPrimeDecomposition ()
{
    NSInteger _integerValue;
    NSMutableArray * _primesList;
    NSMutableArray * _powersList;
}
@end

@implementation KSMPrimeDecomposition

-(id)initWithInteger:(NSInteger)integer
{
    self = [super init];
    if (self) {
        [self setIntegerValue:integer];
    }
    return self;
}

-(NSInteger)integerValue
{
    return _integerValue;
}

-(void)setIntegerValue:(NSInteger)integerValue
{
    _integerValue = labs(integerValue);
    _primesList = [NSMutableArray array];
    _powersList = [NSMutableArray array];
    
    if (labs(_integerValue) < 2) return;
    
    KSMPrimes * primes = [KSMPrimes defaultPrimes];
    NSUInteger factorRemaining = _integerValue;
    NSUInteger index = 0;
    while (factorRemaining != 1) {
        NSUInteger prime = [primes primeAtIndex:index];
        NSUInteger power = 0;
        BOOL isFactor;
        do {
            isFactor = (factorRemaining % prime == 0);
            if (isFactor) {
                factorRemaining = factorRemaining / prime;
                power++;
            } else {
                [_primesList addObject:@(prime)];
                [_powersList addObject:@(power)];
                index++;
            }
        } while (isFactor);
    }    
}

-(NSUInteger)primeAtIndex:(NSUInteger)index
{
    if (index > [self primeCount]) {
        return 0;
    }
    return [_primesList[index] integerValue];
}

-(NSUInteger)primePowerAtIndex:(NSUInteger)index
{
    if (index > [self primeCount]) {
        return 0;
    }
    return [_powersList[index] integerValue];
}

-(NSUInteger)primeCount
{
    return [_primesList count];
}



@end
