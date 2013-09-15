//
//  KSMWorksheetsTests.m
//  KSMath
//
//  Created by Keith Staines on 30/06/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KSMWorksheet.h"
#import "KSMExpressionEvaluator.h"
#import "KSMExpression.h"

@interface KSMWorksheetsTests : XCTestCase

@end

@implementation KSMWorksheetsTests

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
    KSMWorksheet * worksheet = [[KSMWorksheet alloc] init];
    worksheet.title = @"Test Worksheet";
    KSMExpressionEvaluator * worksheetEvaluator = worksheet.evaluator;
    XCTAssertTrue(worksheetEvaluator, @"The worksheet's expression evaluator is nil.");
}

@end
