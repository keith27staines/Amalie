//
//  KSMExpressionBuilderTests.m
//  KSMath
//
//  Created by Keith Staines on 30/06/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <XCTest/XCTest.h>
#import "KSMWorksheet.h"
#import "KSMExpressionBuilder.h"
#import "KSMExpression.h"

@interface KSMExpressionBuilderTests : XCTestCase

@property (readwrite) KSMWorksheet * worksheet;

@end

@implementation KSMExpressionBuilderTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    self.worksheet = [[KSMWorksheet alloc] init];
    
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    self.worksheet = nil;
}

-(void)testBuildAndRegister
{
    NSString * mathString = @"1+2*3";
    KSMExpressionBuilder * builder = self.worksheet.builder;
    KSMExpression * exp = [builder buildExpressionFromString:mathString];
    KSMExpression * identicalExpression = [[KSMExpression alloc] initWithString:mathString];
    
    XCTAssertTrue([exp.symbol isEqualToString:identicalExpression.symbol], @"Different symbols when same symbols were expected.");
    
}

@end
