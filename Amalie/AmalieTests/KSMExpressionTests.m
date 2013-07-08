//
//  KSMExpressionTests.m
//  KSMath
//
//  Created by Keith Staines on 21/06/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KSMExpression.h"
#import "NSString+KSMMath.h"

NSString * dollar = @"$";

@interface KSMExpressionTests : XCTestCase

@end

@implementation KSMExpressionTests

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

- (void)testInit
{
    // Call the init constructor, expecting an exception as this constructor isn't to be used.
    XCTAssertThrowsSpecific([[KSMExpression alloc] init],
                            NSException, @"The init constructor should throw an exception if used.");
}

- (void)testInitWithString
{
    
    XCTAssertThrows([[KSMExpression alloc] initWithString:nil], @"An exception was expected because initWithString was called with a nil string.");
    
    XCTAssertTrue([[KSMExpression alloc] initWithString:@""], @"Failed to initialise test didn't return a valid id.");

    XCTAssertTrue([[KSMExpression alloc] initWithString:@"x"], @"Failed to initialise test didn't return a valid id.");

    XCTAssertTrue([[KSMExpression alloc] initWithString:@"-x"], @"Failed to initialise test didn't return a valid id.");

    XCTAssertTrue([[KSMExpression alloc] initWithString:@"(x)"], @"Failed to initialise test didn't return a valid id.");

    XCTAssertTrue([[KSMExpression alloc] initWithString:@"(-x)"], @"Failed to initialise test didn't return a valid id.");

    XCTAssertTrue([[KSMExpression alloc] initWithString:@"2"], @"Failed to initialise test didn't return a valid id.");
    
    XCTAssertTrue([[KSMExpression alloc] initWithString:@"-2"], @"Failed to initialise test didn't return a valid id.");

    XCTAssertTrue([[KSMExpression alloc] initWithString:@"(2)"], @"Failed to initialise test didn't return a valid id.");

    XCTAssertTrue([[KSMExpression alloc] initWithString:@"(-2)"], @"Failed to initialise test didn't return a valid id.");

    
    XCTAssertTrue([[KSMExpression alloc] initWithString:@"a+b"], @"Failed to initialise: test didn't return a valid id.");
    
    XCTAssertTrue([[KSMExpression alloc] initWithString:@"a+b+c"], @"Failed to initialise: test didn't return a valid id.");
    
    // Test the case a+a+a. Here, we expect a+a to be replaced by a symble, $x, so that the resulting binary string should be $x+$y, where $x = correct symbol for a+a and $y is the correct symbol for a
    NSString * symbolA = [self correctSymbolFromBareString:@"a"];
    NSString * symbolAPlusA = [self correctSymbolFromBareString:@"a+a"];
    NSString * expectedString = [symbolAPlusA stringByAppendingString:@"+"];
    expectedString = [expectedString stringByAppendingString:symbolA];
    KSMExpression * exp;
    
    exp = [[KSMExpression alloc] initWithString:@"a+a+a"];
    XCTAssertTrue(exp, @"Failed to initialise: test didn't return a valid id.");
    XCTAssertTrue([exp.string isEqualToString:expectedString], @"Expression isn't returning its equivalent string.");
    
    // Very similar case but with expression (needlessly) enclosed in brackets. Result should be the same as the case above because the enclosing brackets should be stripped away
    exp = [[KSMExpression alloc] initWithString:@"(a+a+a)"];
    XCTAssertTrue(exp, @"Failed to initialise: test didn't return a valid id.");
    XCTAssertTrue([exp.string isEqualToString:expectedString], @"Expression isn't returning its equivalent string.");
    
}

- (void)testUnclotheString
{
    NSString * clothedString = @"(a)";
    NSString * unclothedString = @"a";
    NSString * result = [KSMExpression stripEnclosingBrackets:clothedString];
    XCTAssertTrue([result isEqualToString:unclothedString], @"Didn't remove enclosing brackets.");
    
    clothedString = @"(a)(b)";  // NOT really enclosed but might look like it to naive algorithm
    result = [KSMExpression stripEnclosingBrackets:clothedString];
    XCTAssertTrue([result isEqualToString:clothedString], @"Remove or altered brackets in a non-enclosing expression.");
}

- (void)testBracketlessString
{
    XCTAssertTrue([KSMExpression isBracketlessString:@"a*1-+X"], @"String is bracketless.");
    
    XCTAssertFalse([KSMExpression isBracketlessString:@"a(*1-+X)"], @"String is not bracketless.");
    
    XCTAssertFalse([KSMExpression isBracketlessString:@"(a*1-+)X"], @"String is not bracketless.");
    
    XCTAssertFalse([KSMExpression isBracketlessString:@"(a*(1)-+X)"], @"String is not bracketless.");
}

-(void)testSymbol
{
    NSString * stringToParse;
    KSMExpression * exp;
    NSString * symbol;
    NSString * correctSymbol;
    
    // Check the simplest case where the string to parse is easily identified as a terminal string
    stringToParse = @"x";
    exp = [[KSMExpression alloc] initWithString:stringToParse];
    symbol = [exp symbol];
    XCTAssertTrue([[symbol KSMfirstCharacter] isEqualToString:dollar], @"First character of symbol should be $");
    
    XCTAssertTrue([symbol length] > 1, @"Symbols must be at least two characters");
    correctSymbol = [self correctSymbolFromBareString:@"x"];
    XCTAssertTrue([symbol isEqualToString:correctSymbol], @"Badly formed symbol.");
    
    // More complex case where string to parse is a compound expression
    stringToParse = @"(2 + x) * (3 - y) / (z - 5)^78.3";
    exp = [[KSMExpression alloc] initWithString:stringToParse];
    symbol = exp.symbol;
    correctSymbol = [self correctSymbolFromBareString:@"(2+x)*(3-y)/(z-5)^78.3"];
    XCTAssertTrue([symbol isEqualToString:correctSymbol], @"Badly formed symbol.");
    
}

- (void)testArrayOfOperators
{
    KSMExpression * exp = [[KSMExpression alloc] initWithString:@"x"];
    NSArray * ops  = [exp arrayOfOperators];
    
    XCTAssertTrue(ops, @"The expression's operator array is nil.");
    XCTAssertTrue([ops count] > 0, @"The operator array is empty");
    NSString * badChars = @"abcdefghijklmnopqrstuvwxyz0123456789!@£$():;.,ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    for (NSString * opStr in ops) {
        XCTAssertTrue( ([opStr length] == 1), @"Operator of unexpected length.");
        XCTAssertFalse([opStr KSMcontainsCharactersInString:badChars], @"Operator is a fobidden character");
    }
}

- (void)testSubExpressions
{
    // Just simple tests to prove the existence of the subexpressions array. Its content will be examined in other tests that delve into the parsing of the original string
    KSMExpression * exp = [[KSMExpression alloc] initWithString:@"x"];
    NSDictionary * subExpressions = [exp subExpressions];
    XCTAssertTrue(subExpressions, @"Sub expressions dictionary is nil.");
    XCTAssertTrue([subExpressions count] == 0, @"No subexpressions expected for this case.");
}

- (void)testIsBracketSyntaxGood
{
    NSString * simpleGood = @"(a + b)";
    NSString * simpleBad = @")a + b)";
    XCTAssertTrue([KSMExpression isBracketSyntaxGood:simpleGood], @"The bracket ordering in %@ is good but was reported bad.", simpleGood);
    XCTAssertFalse([KSMExpression isBracketSyntaxGood:simpleBad], @"The bracket ordering in %@ is bad but was reported bad.", simpleBad);
}

- (void)testRangeOfHighestPrecedenceOperatorInString
{
    NSString * string;
    NSRange r;
    
    // choose an unusual string of operators with some of the standard operators out of their usual order
    NSArray * operators = @[@"£",@"+",@"/",@"*",@"-"];
    
    // singly bracketed string exercising all of the operators
    //         0123456789012345678901234567890123456789
    string = @"-a*b+d£z"; // range of £ is {7,1}
    
    r = [KSMExpression rangeOfHighestPrecedenceOperatorInString:string
                                                      operators:operators];

    XCTAssertTrue(r.location == 6, @"Range has incorrect location.");
    XCTAssertTrue(r.length == 1, @"Range has incorrect length.");
    
    //         0123456789012345678901234567890123456789
    string = @"-a*b+d+z";
    r = [KSMExpression rangeOfHighestPrecedenceOperatorInString:string
                                                      operators:operators];
    XCTAssertTrue(r.location == 4, @"Range has incorrect location.");
    XCTAssertTrue(r.length == 1, @"Range has incorrect length.");

    
    //         0123456789012345678901234567890123456789
    string = @"+a*b+d-z";
    r = [KSMExpression rangeOfHighestPrecedenceOperatorInString:string
                                                      operators:operators];
    XCTAssertTrue(r.location == 0, @"Range has incorrect location.");
    XCTAssertTrue(r.length == 1, @"Range has incorrect length.");

    //         0123456789012345678901234567890123456789
    string = @"-a*b-d+z";
    r = [KSMExpression rangeOfHighestPrecedenceOperatorInString:string
                                                      operators:operators];
    XCTAssertTrue(r.location == 6, @"Range has incorrect location.");
    XCTAssertTrue(r.length == 1, @"Range has incorrect length.");

    //         0123456789012345678901234567890123456789
    string = @"";
    r = [KSMExpression rangeOfHighestPrecedenceOperatorInString:string
                                                      operators:operators];
    XCTAssertTrue(r.location == NSNotFound, @"Range has incorrect location.");
    XCTAssertTrue(r.length == 0, @"Range has incorrect length.");
    
    // Finally, check exception is raised if the string isn't bracketless
    string = @"(-a*(b+c)-d+z)";
    XCTAssertThrows([KSMExpression rangeOfHighestPrecedenceOperatorInString:string
                                                                  operators:operators], @"Exception was expected but not thrown.");
}

- (void)testIsLeadingMinusRegularizedInString
{
    NSString * string;
    BOOL isRegular;
    
    // Show that strings without a leading minus signs detected as regularized
    string = @"(a-b+c*-e)";
    isRegular = [KSMExpression isLeadingMinusRegularizedInString:string];
    XCTAssertTrue(isRegular, @"String is regular.");
}

- (void)testRegularizeLeadingMinusInString
{
    NSString * string;
    NSString * regularizedString;

    // Show that strings without a leading minus signs are unaffected
    string = @"a-b+c*-e";
    regularizedString = [KSMExpression regularizeLeadingMinusInString:string];

    XCTAssertEquals(string, regularizedString, @"String should be unchanged.");

    string = @"-a-b+c*-e";
    regularizedString = [KSMExpression regularizeLeadingMinusInString:string];
    XCTAssertTrue([@"0-a-b+c*-e" isEqualToString:regularizedString], @"String should now be prefixed by '0-'");
    
    KSMExpression * e = [[KSMExpression alloc] initWithString:string];
    XCTAssertTrue([e.string isEqualToString:@"0-a-b+c*-e"], @"expression's string property wasn't regularised.");
    
    // Show that strings of the form -x, where x does not contain an operator, retain their form.
    string = @"a-b+c*-e";
    regularizedString = [KSMExpression regularizeLeadingMinusInString:string];
    
    XCTAssertEquals(string, regularizedString, @"String should be unchanged.");
    

}

- (void)testRangeInExpressionStringOfTokensAroundIndex
{
    // includes tests for both "before" and "after" index functions
    
    
    // Tests for "after"
    
    NSRange tokenRange;
    NSArray * operators = @[@"^",@"*",@"/",@"+",@"-" ];
    NSString * string;
    //         012345678901234567890
    string = @"(a123+b7)";
    tokenRange = [KSMExpression rangeInExpressionString:string
                              ofTokenFromIndex:5+1
                                   delimitedByoperators:operators];
    XCTAssertTrue(tokenRange.location == 6, @"Location is incorrect.");
    XCTAssertTrue(tokenRange.length == 2, @"Length is incorrect.");
    
    // demonstrate that an exception is raised if the character previous to the character at the index is not an operator, bracket, or beginning of string
    XCTAssertThrows([KSMExpression rangeInExpressionString:string
                                          ofTokenFromIndex:5+2
                                      delimitedByoperators:operators],
                    @"An exception should have been thrown.");
    
    // Tests for before
    
    tokenRange = [KSMExpression rangeInExpressionString:string
                    ofTokenPreviousToIndex:5-1
                                   delimitedByoperators:operators];
    XCTAssertTrue(tokenRange.location == 1, @"Location is incorrect.");
    XCTAssertTrue(tokenRange.length == 4, @"Length is incorrect.");

    // and check an exception is thrown if the index was incorrectly chosen to begin with
    XCTAssertThrows([KSMExpression rangeInExpressionString:string
                          ofTokenPreviousToIndex:5-2
                                      delimitedByoperators:operators],
                    @"An exception should have been thrown.");
}

- (void)testIsStringAnOperator
{
    NSArray * operators = @[@"^",@"*",@"/",@"+",@"-" ];
    NSString * string = @"*";
    XCTAssertTrue([KSMExpression isStringAnOperator:string
                                      operatorArray:operators],
                  @"'*' is an operator but was not identified as such.");
    
    string = @"**";
    XCTAssertFalse([KSMExpression isStringAnOperator:string
                                      operatorArray:operators],
                  @"'**' is not an operator but was identified as being one.");
    
    string = @"";
    XCTAssertFalse([KSMExpression isStringAnOperator:string
                                       operatorArray:operators],
                   @"An empty string is not an operator but was identified as being one.");
    
    string = nil;
    XCTAssertFalse([KSMExpression isStringAnOperator:string
                                       operatorArray:operators],
                   @"A nil string is not an operator but was identified as being one.");
    
    string = @"a";
    XCTAssertFalse([KSMExpression isStringAnOperator:string
                                       operatorArray:operators],
                   @"'a' is not an operator but was identified as being one.");
    
}

-( void)testIsStringBinaryExpression
{
    NSArray * operators = @[@"^",@"*",@"/",@"+",@"-" ];
    NSString * string;
    string = @"a+b";
    XCTAssertTrue([KSMExpression isStringBinaryExpression:string operators:operators], @"%@ is a binary expression but wasn't recognised as such.",string);
    
    // test some edge cases
    string = @"";
    XCTAssertFalse([KSMExpression isStringBinaryExpression:string operators:operators], @"The empty string is not a binary expression.");

    
    string = nil;
    XCTAssertFalse([KSMExpression isStringBinaryExpression:string operators:operators], @"The empty string is not a binary expression.");

    string = @"a+b+c";
    XCTAssertFalse([KSMExpression isStringBinaryExpression:string operators:operators], @"%@ is not a binary expression.", string);

    string = @"(a+(b+c))";
    XCTAssertFalse([KSMExpression isStringBinaryExpression:string operators:operators], @"%@ is not a binary expression.", string);

}

- (void)testStringFromOperatorsArray
{
    NSArray * operators = @[@"^",@"*",@"/",@"+",@"-" ];
    NSString * string;
    string = [KSMExpression stringFromOperatorsArray:operators];
    XCTAssertTrue([string isEqualToString:@"^*/+-"], @"Operators string is not correctly formed.");
}

- (void)testOperatorCountInString
{
    NSArray * operators = @[@"^",@"*",@"/",@"+",@"-" ];
    NSString * string = @"(a*b-c+f*g)";
    XCTAssertTrue([KSMExpression operatorCountInString:string
                                           operatorArray:operators] == 4, @"Operator count is wrong.");
}

- (void)testClothInBrackets
{
    NSString * string = @"a+b";
    string = [KSMExpression encloseInBrackets:string];
    XCTAssertTrue([string isEqualToString:@"(a+b)"], @"String was not clothed in brackets correctly.");
}

////////////////////////////////////////////////////////////////////////////////
// Utility functions to assist testing
////////////////////////////////////////////////////////////////////////////////

/*!
 * Utility function to help debug symbols
 * @Param string to represent with a symbol
 * @Returns symbol constructed from hash tag and symbol prefix character
 */
-(NSString *)correctSymbolFromBareString:(NSString*)originalString
{
    NSAssert(originalString, @"The string must not be nil");
    NSAssert([originalString length] > 0, @"The string must not be empty");
    NSUInteger hash = [originalString hash];
    NSString * correctSymbol = [NSString stringWithFormat:@"%@%ld",dollar,hash];
    return correctSymbol;
}



@end
