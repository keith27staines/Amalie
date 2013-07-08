//
//  KSMPrimeDecompositionTests.m
//  KSMath
//
//  Created by Keith Staines on 16/06/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KSMPrimeDecomposition.h"

@interface KSMPrimeDecompositionTests : XCTestCase

@end

@implementation KSMPrimeDecompositionTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testDecompositionOfVariousNumbers
{
    NSUInteger trialComposite;
    KSMPrimeDecomposition * primeDecomposer = [[KSMPrimeDecomposition alloc] init];

    trialComposite = 0;
    [primeDecomposer setIntegerValue:trialComposite];
    XCTAssertTrue([primeDecomposer primeCount]==0, @"For integers with absolute value less than 2, the prime decomposition contains no primes.");
    
    trialComposite = 1;
    [primeDecomposer setIntegerValue:trialComposite];
    if (trialComposite != [self reconstructDecomposition:primeDecomposer] ) {
        XCTFail(@"composite was not reconstructed from its prime factors correctly");
    }

    trialComposite = 2;
    [primeDecomposer setIntegerValue:trialComposite];
    if (trialComposite != [self reconstructDecomposition:primeDecomposer] ) {
        XCTFail(@"composite was not reconstructed from its prime factors correctly");
    }

    trialComposite = 3;
    [primeDecomposer setIntegerValue:trialComposite];
    if (trialComposite != [self reconstructDecomposition:primeDecomposer] ) {
        XCTFail(@"composite was not reconstructed from its prime factors correctly");
    }

    trialComposite = 4;
    [primeDecomposer setIntegerValue:trialComposite];
    if (trialComposite != [self reconstructDecomposition:primeDecomposer] ) {
        XCTFail(@"composite was not reconstructed from its prime factors correctly");
    }

    trialComposite = 5;
    [primeDecomposer setIntegerValue:trialComposite];
    if (trialComposite != [self reconstructDecomposition:primeDecomposer] ) {
        XCTFail(@"composite was not reconstructed from its prime factors correctly");
    }
    
    // 2^2 * 3^0 * 5^1 * 7^0... * 61^1 = 1220;  // 2^2 * 3^0 * 5^1 * 7^0... * 61^1
    trialComposite = 1220;
    [primeDecomposer setIntegerValue:trialComposite];
    if (trialComposite != [self reconstructDecomposition:primeDecomposer] ) {
        XCTFail(@"composite was not reconstructed from its prime factors correctly");
    }

}


-(NSUInteger)reconstructDecomposition:(KSMPrimeDecomposition *) primeDecomposer
{
    NSUInteger composite = 1;
    NSUInteger power = 0;
    NSUInteger prime = 0;
    NSUInteger primeRaisedToPower = 0;
    NSUInteger primeCount = [primeDecomposer primeCount];
    for (int i = 0; i < primeCount; i++) {
        power = [primeDecomposer primePowerAtIndex:i];
        prime = [primeDecomposer primeAtIndex:i];
        primeRaisedToPower = pow(prime, power);
        composite = composite * primeRaisedToPower;
    }
    return composite;
}

@end
