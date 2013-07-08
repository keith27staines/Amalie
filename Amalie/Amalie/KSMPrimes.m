//
//  KSMPrimes.m
//  KSMath
//
//  Created by Keith Staines on 21/05/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMPrimes.h"

KSMPrimes * _defaultPrimes;

// kBlockSize is the default number of integers to check for prime-ness in a single hit
const NSUInteger kBlockSize = 100;

@interface KSMPrimes()
{
    NSUInteger _lastIntegerChecked;
    NSMutableArray * _allPrimes;
    NSUInteger _blockSize;
}

@end

@implementation KSMPrimes

- (id)initWithBlockSize:(NSUInteger)blockSize
{
    self = [super init];
    if (self) {
        _allPrimes = [NSMutableArray arrayWithObjects:@(2), nil];
        _lastIntegerChecked = 2;
        if (blockSize < 1) blockSize = 1;
        _blockSize = blockSize;
    }
    return self;
}

- (id)init
{
    return [self initWithBlockSize:kBlockSize];
}

+(id)defaultPrimes
{
    if (!_defaultPrimes) {
        _defaultPrimes = [[KSMPrimes alloc] init];
    }
    return _defaultPrimes;
}

-(NSUInteger)primeAtIndex:(NSUInteger)index
{
    while ( index > [self currentPrimeCount] - 1 ) {
        [self generateNextPrime];
    }
    
    NSNumber * number = _allPrimes[index];
    return [number integerValue];
}

-(void)generateNextPrime
{
    _lastIntegerChecked++;
    while ( ![self isPrime:_lastIntegerChecked]) {
        _lastIntegerChecked++;
    }
    [self appendArrayToAllPrimes:@[@(_lastIntegerChecked)]];
}


-(BOOL)isPrime:(NSUInteger)possiblePrime
{
    if (possiblePrime < 2) return NO;
    
    // Calculate the maximum divisor we ever need test
    NSUInteger maxDivisor = (NSUInteger)sqrt((double)possiblePrime);
    
    // Use sieve of Eratosthenes as far as possible, testing prime by prime
    NSUInteger index = 0;
    NSUInteger possiblePrimeDivisor = 2;
    while ( index < [self currentPrimeCount] ) {
        
        possiblePrimeDivisor = [self primeAtIndex:index];
        
        // If we have exceeded the maximum possible divisor, then we have found a prime
        if (possiblePrimeDivisor > maxDivisor) return YES;
        
        // If the current prime divides the possible prime, then the possible prime is not a prime
        if ( [self doesDivide:possiblePrimeDivisor
                    quotient:possiblePrime]) {
            return NO;
        }
        index++;
    }
    
    // now do the rest the hard way, integer by integer
    for (NSUInteger possibleDivisor = [self currentHighestPrime] + 1;
         possibleDivisor <= maxDivisor;
         possibleDivisor++) {
        
        // if we find that possibleDivisor divides the possible prime, then the possible prime is not a prime
        if ( [self doesDivide:possibleDivisor quotient:possiblePrime]) return NO;
    }
    
    // No divosors, hence a prime
    return YES;
}

-(BOOL)doesDivide:(NSUInteger)possibleDivisor
        quotient:(NSUInteger)quotient
{
    NSUInteger remainder = quotient % possibleDivisor;
    if (remainder == 0) {
        return YES;
    }
    return NO;
}

-(void)generatePrimesLowerThan:(NSUInteger)number
{
    if (number <= _lastIntegerChecked) return;

    NSArray * primesToAdd;
    primesToAdd = [self calculatePrimesBetweenLowInteger:_lastIntegerChecked + 1
                                             highInteger:number];
    [self appendArrayToAllPrimes:primesToAdd];
    _lastIntegerChecked = number;
}

-(NSArray *)calculatePrimesBetweenLowInteger:(NSUInteger)low
                                 highInteger:(NSUInteger)high
{
    NSMutableArray * primes = [NSMutableArray array];
    for (NSUInteger i = low; i <= high; i++) {
        if ([self isPrime:i]) {
            [primes addObject:@(i)];
        }
    }
    return primes;
}

// this is a dumb append - make sure the append makes sense before calling
-(void)appendArrayToAllPrimes:(NSArray *)arrayToAppend
{
    [_allPrimes addObjectsFromArray:arrayToAppend];
}

-(NSUInteger)currentHighestPrime
{
    NSNumber * highestPrime = [_allPrimes lastObject];
    return [highestPrime integerValue];
}

-(NSUInteger)currentPrimeCount
{
    return [_allPrimes count];
}



@end
