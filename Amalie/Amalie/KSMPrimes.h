//
//  KSMPrimes.h
//  KSMath
//
//  Created by Keith Staines on 21/05/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSMPrimes : NSObject

@property (readonly) NSUInteger blockSize;

+(id)defaultPrimes;

// designated constructor, blocksize specifies number of integers to search for primeness in each chunk
-(id)initWithBlockSize:(NSUInteger)blockSize;

// Return the nth prime
-(NSUInteger)primeAtIndex:(NSUInteger)index;

// tests an integer for primeness
-(BOOL)isPrime:(NSUInteger)possiblePrime;

// populates the prime store so that it contains all primes up to and including the specified numer
-(void)generatePrimesLowerThan:(NSUInteger)number;

// returns the highest prime so far discovered
-(NSUInteger)currentHighestPrime;

// returns the number of primes so far discovered
-(NSUInteger)currentPrimeCount;

// Returns an array containing primes in the specified range, without affecting the prime store
-(NSArray *)calculatePrimesBetweenLowInteger:(NSUInteger)low
                                 highInteger:(NSUInteger)high;
@end
