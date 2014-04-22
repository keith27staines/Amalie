//
//  KSMWorksheetsTests.m
//  KSMath
//
//  Created by Keith Staines on 30/06/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KSMMathSheet.h"
#import "KSMExpressionEvaluator.h"
#import "KSMExpression.h"

@interface KSMMathSheetTests : XCTestCase

@end

@implementation KSMMathSheetTests

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

- (void)testInitialize
{
    KSMMathSheet * mathSheet = [[KSMMathSheet alloc] init];
    KSMExpressionEvaluator * mathSheetEvaluator = mathSheet.evaluator;
    XCTAssertTrue(mathSheetEvaluator, @"The mathsheet's expression evaluator is nil.");
}

@end
