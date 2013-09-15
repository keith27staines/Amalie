//
//  KSMExpressionEvaluatorTests.m
//  KSMath
//
//  Created by Keith Staines on 30/06/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <XCTest/XCTest.h>
#import "KSMWorksheet.h"
#import "KSMExpressionEvaluator.h"
#import "KSMExpression.h"
@interface KSMExpressionEvaluatorTests : XCTestCase

@property (readwrite, strong) KSMWorksheet * worksheet;

@end

@implementation KSMExpressionEvaluatorTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    self.worksheet = [[KSMWorksheet alloc] init];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    self.worksheet = nil;
}

- (void)testSimplifiedExpression
{
    NSString * mathString;
    NSString * simplifiedString;
    NSString * calculatedSimplifiedString;
    NSString * symbol;
    KSMExpression * complexExpression;
    KSMExpression * simplifiedExpression;
    
    // simple addition
    mathString = @"9+3";
    simplifiedString = @"12";
    symbol = [self.worksheet buildAndRegisterExpressionFromString:mathString];
    complexExpression = [self.worksheet expressionForSymbol:symbol];
    simplifiedExpression = [self.worksheet simplifiedExpressionFromExpression:complexExpression];
    
    calculatedSimplifiedString = [self.worksheet.evaluator stringByExpandingSymbolsInExpression:simplifiedExpression];
    
    XCTAssertTrue([calculatedSimplifiedString isEqualToString:simplifiedString],@"simplified expression's string isn't correct.");

    
    // simple subtraction
    mathString = @"9-12";
    simplifiedString = @"0-3";
    symbol = [self.worksheet buildAndRegisterExpressionFromString:mathString];
    complexExpression = [self.worksheet expressionForSymbol:symbol];
    simplifiedExpression = [self.worksheet simplifiedExpressionFromExpression:complexExpression];
    calculatedSimplifiedString = [self.worksheet.evaluator stringByExpandingSymbolsInExpression:simplifiedExpression];
    
    XCTAssertTrue([calculatedSimplifiedString isEqualToString:simplifiedString],@"simplified expression's string isn't correct.");
    
    // straightforward multiplication
    mathString = @"9*3";
    simplifiedString = @"27";
    symbol = [self.worksheet buildAndRegisterExpressionFromString:mathString];
    complexExpression = [self.worksheet expressionForSymbol:symbol];
    simplifiedExpression = [self.worksheet simplifiedExpressionFromExpression:complexExpression];
    calculatedSimplifiedString = [self.worksheet.evaluator stringByExpandingSymbolsInExpression:simplifiedExpression];
    
    XCTAssertTrue([calculatedSimplifiedString isEqualToString:simplifiedString],@"simplified expression's string isn't correct.");

    // simple division, resulting in integer
    mathString = @"9/3";
    simplifiedString = @"3";
    symbol = [self.worksheet buildAndRegisterExpressionFromString:mathString];
    complexExpression = [self.worksheet expressionForSymbol:symbol];
    simplifiedExpression = [self.worksheet simplifiedExpressionFromExpression:complexExpression];
    calculatedSimplifiedString = [self.worksheet.evaluator stringByExpandingSymbolsInExpression:simplifiedExpression];
    
    XCTAssertTrue([calculatedSimplifiedString isEqualToString:simplifiedString],@"simplified expression's string isn't correct.");

    // rational fraction that cannot be simplified
    mathString = @"1/7";
    simplifiedString = @"1/7";  //
    symbol = [self.worksheet buildAndRegisterExpressionFromString:mathString];
    complexExpression = [self.worksheet expressionForSymbol:symbol];
    simplifiedExpression = [self.worksheet simplifiedExpressionFromExpression:complexExpression];
    calculatedSimplifiedString = [self.worksheet.evaluator stringByExpandingSymbolsInExpression:simplifiedExpression];
    
    XCTAssertTrue([calculatedSimplifiedString isEqualToString:simplifiedString],@"simplified expression's string isn't correct.");

    
    // rational fraction that can be simplified
    mathString = @"3/9";
    simplifiedString = @"1/3";  //
    symbol = [self.worksheet buildAndRegisterExpressionFromString:mathString];
    complexExpression = [self.worksheet expressionForSymbol:symbol];
    simplifiedExpression = [self.worksheet simplifiedExpressionFromExpression:complexExpression];
    calculatedSimplifiedString = [self.worksheet.evaluator stringByExpandingSymbolsInExpression:simplifiedExpression];
    
    XCTAssertTrue([calculatedSimplifiedString isEqualToString:simplifiedString],@"simplified expression's string isn't correct.");
    
    // more complex example of rational fraction that can be simplified
    mathString = @"9/54";
    simplifiedString = @"1/6";
    symbol = [self.worksheet buildAndRegisterExpressionFromString:mathString];
    complexExpression = [self.worksheet expressionForSymbol:symbol];
    simplifiedExpression = [self.worksheet simplifiedExpressionFromExpression:complexExpression];
    calculatedSimplifiedString = [self.worksheet.evaluator stringByExpandingSymbolsInExpression:simplifiedExpression];
    
    XCTAssertTrue([calculatedSimplifiedString isEqualToString:simplifiedString],@"simplified expression's string isn't correct.");

    
}

@end
