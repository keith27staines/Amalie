//
//  KSMPrimeTests.m
//  KSMPrimeTests
//
//  Created by Keith Staines on 21/05/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMPrimeTests.h"

@implementation KSMPrimeTests

- (void)setUp
{
    [super setUp];
    
    // following list of primes stolen from the internet...
    knownPrimes =  @[
        @(2),   @(3),   @(5),   @(7),   @(11),  @(13),
        @(17),  @(19),  @(23),  @(29),  @(31),  @(37),
        @(41),  @(43),  @(47),  @(53),  @(59),  @(61),
        @(67),  @(71),  @(73),  @(79),  @(83),  @(89),
        @(97),  @(101), @(103), @(107), @(109), @(113),
        @(127), @(131), @(137), @(139), @(149), @(151),
        @(157), @(163), @(167), @(173), @(179), @(181),
        @(191), @(193), @(197), @(199), @(211), @(223),
        @(227), @(229), @(233), @(239), @(241), @(251),
        @(257), @(263), @(269), @(271), @(277), @(281),
        @(283), @(293), @(307), @(311), @(313), @(317),
        @(331), @(337), @(347), @(349), @(353), @(359),
        @(367), @(373), @(379), @(383), @(389), @(397),
        @(401), @(409), @(419), @(421), @(431), @(433),
        @(439), @(443), @(449), @(457), @(461), @(463),
        @(467), @(479), @(487), @(491), @(499), @(503),
        @(509), @(521), @(523), @(541), @(547), @(557),
        @(563), @(569), @(571), @(577), @(587), @(593),
        @(599), @(601), @(607), @(613), @(617), @(619),
        @(631), @(641), @(643), @(647), @(653), @(659),
        @(661), @(673), @(677), @(683), @(691), @(701),
        @(709), @(719), @(727), @(733), @(739), @(743),
        @(751), @(757), @(761), @(769), @(773), @(787),
        @(797), @(809), @(811), @(821), @(823), @(827),
        @(829), @(839), @(853), @(857), @(859), @(863),
        @(877), @(881), @(883), @(887), @(907), @(911),
        @(919), @(929), @(937), @(941), @(947), @(953),
        @(967), @(971), @(977), @(983), @(991), @(997)
    ];
    
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


// test the construction of the a Primes object
-(void)testConstruction
{
    KSMPrimes * primes = [[KSMPrimes alloc] init];
    if (!primes) {
        XCTFail(@"Failed to construct default primes object");
    }
    
    if ([primes currentPrimeCount] !=1) {
        XCTFail(@"newly constructed default primes doesn't contain exactly 1 prime");
    }
    
    if ([primes currentHighestPrime] != 2) {
        XCTFail(@"Newly constructed default primes doesn't contain 2 as the first prime");

    }
}

// test generation of first 1000 primes
-(void)testPrimeDetection
{
    KSMPrimes * primes = [[KSMPrimes alloc] init];
    if (!primes) {
        XCTFail(@"Failed to construct primes object");
    }
    
    // test 0
    BOOL isZeroPrime = [primes isPrime:0];
    if (isZeroPrime) {
        XCTFail(@"Zero was incorrectly identified as prime.");
    }
    
    // test 1
    BOOL is1Prime = [primes isPrime:1];
    if (is1Prime) {
        XCTFail(@"1 was incorrectly identified as prime.");
    }

    // test 2
    BOOL is2Prime = [primes isPrime:2];
    if (!is2Prime) {
        XCTFail(@"2 was not identified as prime.");
    }

    // test 3
    BOOL is3Prime = [primes isPrime:3];
    if (!is3Prime) {
        XCTFail(@"3 was not identified as prime.");
    }

    // test 4
    BOOL is4Prime = [primes isPrime:4];
    if (is4Prime) {
        XCTFail(@"4 was incorrectly identified as prime.");
    }
    
    
    // test high prime
    NSUInteger highPrime = 997;
    BOOL isHighPrime = [primes isPrime:highPrime];
    if (!isHighPrime) {
        XCTFail(@"%ld was not identified as prime.", highPrime);
    }
    
    // test high non-prime
    NSUInteger highNonPrime = 995;
    isHighPrime = [primes isPrime:highNonPrime];
    if (isHighPrime) {
        XCTFail(@"%ld was incorrectly identified as prime.", highNonPrime);
    }

}

-(void)testPrimesBelow1000InitWithBlockSize
{

    for (NSUInteger blockSize = 1; blockSize < 1001; blockSize+=1000) {
        KSMPrimes * primes = [[KSMPrimes alloc] initWithBlockSize:blockSize];
        [primes generatePrimesLowerThan:blockSize];
        
        for (NSUInteger i = 0; i < 1000; i++) {
            if ( [self array:knownPrimes contains:i] ) {
                // dealing with a known prime
                if ( ![primes isPrime:i]) {
                    // dsagreement!
                    XCTFail(@"%ld is prime but was not identified as such. BlockSize was %ld", i, blockSize);
                }
            } else {
                // dealing with a composite number
                if ([primes isPrime:i]) {
                    // disagreement
                    XCTFail(@"%ld is not prime but was identified as prime. BlockSize was %ld", i, blockSize);
                }
            }
        }

    }

}

-(void)testPrimeAtIndex{

    for (NSUInteger blockSize = 0; blockSize < 1000; blockSize++) {
        KSMPrimes * primes = [[KSMPrimes alloc] initWithBlockSize:blockSize];
        [primes generatePrimesLowerThan:blockSize];
        NSLog(@"Prime count is %ld of %ld",[primes currentPrimeCount] , [knownPrimes count]);
        
        for (NSUInteger i = 0; i < [knownPrimes count]; i++) {
            NSNumber * knownPrime = knownPrimes[i];
            NSUInteger iKnownPrime = [knownPrime integerValue];
            NSUInteger calcPrime = [primes primeAtIndex:i];
            if ( iKnownPrime != calcPrime ) {
                // mismatch
                XCTFail(@"Known prime at index %ld is %ld, but calculated prime at same index is %ld. Blocksize was %ld", i, iKnownPrime, calcPrime, blockSize);
            }
        }
    }
}

-(BOOL)array:(NSArray*)array contains:(NSUInteger)i
{
    for (NSNumber * number in array) {
        NSUInteger j = [number integerValue];
        if (i==j) {
            return YES;
        }
    }
    return NO;
}

@end
