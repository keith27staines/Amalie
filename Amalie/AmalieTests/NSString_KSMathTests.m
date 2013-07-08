//
//  NSString_KSMathTests.m
//  KSMath
//
//  Created by Keith Staines on 20/06/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+KSMMath.h"

@interface NSString_KSMathTests : XCTestCase

@end

@implementation NSString_KSMathTests

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

- (void)testKSMfirstAndLastCharacter
{
    
    NSString * str = @"";
    
    NSString * firstChar = [str KSMfirstCharacter];
    NSString * lastChar = [str KSMlastCharacter];
    
    XCTAssertTrue((firstChar == nil), @"First character of empty string should be nil.");
    XCTAssertTrue((lastChar == nil), @"Last character of empty string should be nil.");

    str = @"a";
    firstChar = [str KSMfirstCharacter];
    lastChar = [str KSMlastCharacter];
    XCTAssertTrue([firstChar isEqualToString:@"a"], @"First character of one-letter string should be that letter.");
    XCTAssertTrue([lastChar isEqualToString:@"a"], @"Last character of one-letter string should be that letter.");

    
    str = @"hello world";
    firstChar = [str KSMfirstCharacter];
    lastChar = [str KSMlastCharacter];
    XCTAssertTrue([firstChar isEqualToString:@"h"], @"First character of 'hello world' should be h.");
    
    XCTAssertTrue([lastChar isEqualToString:@"d"], @"Last character of 'hello world' should be d.");
    
    
}


- (void)testKSMNumberOfOccurencesOfString
{
    NSString * stringToExamine;
    NSString * stringToFind = nil;
    stringToExamine = @"abc";
    stringToFind = nil;
    XCTAssertTrue([stringToExamine KSMnumberOfOccurencesOfString:stringToFind]==0, @"Strings contain no occurences of nil.");

    stringToExamine = @"";
    stringToFind = @"";
    XCTAssertTrue([stringToExamine KSMnumberOfOccurencesOfString:stringToFind]==0, @"Empty strings contain no occurences of anything, even other empty strings.");
    
    stringToFind = @"z";
    XCTAssertTrue([stringToExamine KSMnumberOfOccurencesOfString:stringToFind]==0, @"Empty strings contain no occurences of anything, including 'z'.");
    
    stringToExamine = @"a";
    stringToFind = @"";
    XCTAssertTrue([stringToExamine KSMnumberOfOccurencesOfString:stringToFind]==0, @"strings contain no occurences of empty strings.");

    stringToExamine = @"a";
    stringToFind = @"a";
    XCTAssertTrue([stringToExamine KSMnumberOfOccurencesOfString:stringToFind]==1, @"a one-letter string should contain exactly one occurence of that letter.");
    
    stringToExamine = @"AbcdAefghijklmnAopAAqrstAAAAAuvwxyzA";
    stringToFind = @"A";
    XCTAssertTrue([stringToExamine KSMnumberOfOccurencesOfString:stringToFind]==11, @"Wrong number of occurences returned.");
    
    stringToFind = @"a";
    XCTAssertTrue([stringToExamine KSMnumberOfOccurencesOfString:stringToFind]==0, @"Wrong number of occurences returned.");
    
}

- (void)testKSMcontainsOnlyCharactersInString
{
    NSString * stringToExamine = @"";
    NSString * stringOfAllowedCharacters = @"";
    
    stringToExamine = @"";
    stringOfAllowedCharacters = @"";
    XCTAssertTrue([stringToExamine KSMcontainsOnlyCharactersInString:stringOfAllowedCharacters]==YES, @"Empty strings contain no occurences of anything, even other empty strings.");

    stringToExamine = @"";
    stringOfAllowedCharacters = nil;
    XCTAssertTrue([stringToExamine KSMcontainsOnlyCharactersInString:stringOfAllowedCharacters]==NO, @"The allowed characters string is nil so the answer should be NO.");

    stringToExamine = @"abcdEfgh";
    stringOfAllowedCharacters = @"a";
    XCTAssertTrue([stringToExamine KSMcontainsOnlyCharactersInString:stringOfAllowedCharacters]==NO, @"The receiver contains characters other than 'a'.");
    
    stringToExamine = @"abcdEfgh";
    stringOfAllowedCharacters = @"abcdefgh";
    XCTAssertTrue([stringToExamine KSMcontainsOnlyCharactersInString:stringOfAllowedCharacters]==NO, @"The receiver contains E whereas the allowed characters specifies only 'e'.");
    
    stringToExamine = @"abcccccdEfgh";
    stringOfAllowedCharacters = stringToExamine;
    XCTAssertTrue([stringToExamine KSMcontainsOnlyCharactersInString:stringOfAllowedCharacters]==YES, @"The strings are identical so the answer should be yes.");
    
}

- (void)testKSMvalidName
{
    // test a variety of bad names
    XCTAssertFalse([@"" KSMvalidName],    @"%@ is not a valid name.",@"empty string");
    XCTAssertFalse([@"0" KSMvalidName],   @"%@ is not a valid name.",@"0");
    XCTAssertFalse([@"0a" KSMvalidName],  @"%@ is not a valid name.",@"0a");
    XCTAssertFalse([@"$" KSMvalidName],   @"%@ is not a valid name.",@"$");
    XCTAssertFalse([@"$a$" KSMvalidName], @"%@ is not a valid name.",@"$a$");
    XCTAssertFalse([@"$1$" KSMvalidName], @"%@ is not a valid name.",@"$1$");
    XCTAssertFalse([@"a.b" KSMvalidName], @"%@ is not a valid name.",@"a.b");
    XCTAssertFalse([@"a+b" KSMvalidName], @"%@ is not a valid name.",@"a+b");
    XCTAssertFalse([@"$A)" KSMvalidName], @"%@ is not a valid name.",@"$A)");
    
    // test a variety of good names
    XCTAssertTrue([@"a" KSMvalidName],    @"%@ is a valid name.",@"a");
    XCTAssertTrue([@"a0" KSMvalidName],   @"%@ is a valid name.",@"a0");
    XCTAssertTrue([@"A" KSMvalidName],    @"%@ is a valid name.",@"A");
    XCTAssertTrue([@"A0" KSMvalidName],   @"%@ is a valid name.",@"A0");
    XCTAssertTrue([@"abcdEFGhi" KSMvalidName], @"%@ is a valid name.",@"abcdEFGhi");
    XCTAssertTrue([@"$ab" KSMvalidName],  @"%@ is a valid name.",@"$ab");
    
    XCTAssertTrue([@"a1" KSMvalidName],   @"%@ is a valid name.",@"a1");
    XCTAssertTrue([@"$0" KSMvalidName],   @"%@ is a valid name.",@"$0");
    XCTAssertTrue([@"$A" KSMvalidName],   @"%@ is a valid name.",@"$A");
}

- (void)testKSMpureNumber
{
    // test a variety of non numbers
    XCTAssertFalse([@"" KSMpureNumber],    @"%@ is not a number.",@"empty string");
    XCTAssertFalse([@"1a" KSMpureNumber],  @"%@ is not a number.",@"1a");
    XCTAssertFalse([@"/2" KSMpureNumber],  @"/2 is not a number.",@"/2");
    XCTAssertFalse([@"+1" KSMpureNumber],  @"%@ is not a number (for our purposes, we regard it as an arithmetic operation).",@"+1");
    
    // test a variety of numbers
    XCTAssertTrue([@"0" KSMpureNumber],        @"%@ is a number.",@"0");
    XCTAssertTrue([@"-123.456" KSMpureNumber], @"%@ is a number.",@"-123.456");

}

@end
























