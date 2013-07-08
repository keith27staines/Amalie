//
//  KSMExpressionEvaluator.m
//  KSMath
//
//  Created by Keith Staines on 26/06/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMExpressionEvaluator.h"
#import "KSMWorksheet.h"
#import "KSMExpression.h"
#import "KSMPrimes.h"
#import "KSMPrimeDecomposition.h"
#import "NSString+KSMMath.h"

enum KSMBinaryType {
    KSMBinaryTypeInvalid                  = -1,
    KSMBinaryTypeIntegerAddition          = 1,
    KSMBinaryTypeIntegerSubtraction       = 2,
    KSMBinaryTypeIntegerMultiplication    = 3,
    KSMBinaryTypeIntegerDivision          = 4, // aka rational
    KSMBinaryTypeIntegerToIntegerPower    = 5,
    KSMBinaryTypeSurdAddition             = 6,
    KSMBinaryTypeSurdSubtraction          = 7,
    KSMBinaryTypeSurdMultiplication       = 8,
    KSMBinaryTypeSurdDivision             = 9,
    KSMBinaryTypeSurdToIntegerPower       = 10,
    KSMBinaryTypeSurdToSurdPower          = 11,
    KSMBinaryTypeIrrationalAddition       = 12,
    KSMBinaryTypeIrrationalSubtraction    = 13,
    KSMBinaryTypeIrrationalMultiplication = 14,
    KSMBinaryTypeIrrationalDivision       = 15,
    KSMBinaryTypeIrrationalToPower        = 16
};

@interface KSMExpressionEvaluator()
{
    __weak KSMWorksheet * _worksheet;
}

@end

@implementation KSMExpressionEvaluator

- (id)init
{
    [NSException raise:@"Use the desginated constructor." format:nil];
    return nil;
}

- (id)initWithWorksheet:(KSMWorksheet *)worksheet
{
    if (!worksheet) [NSException raise:@"The worksheet must not be nil." format:nil];
    
    self = [super init];
    if (self) {
        _worksheet = worksheet;
    }
    return self;
}

-(NSString*)buildAndRegisterExpressionFromString:(NSString*)string
{
    KSMExpression * expression = [[KSMExpression alloc] initWithString:string];
    return [self.worksheet registerExpression:expression];
}

-(KSMExpression*)simplifiedExpressionFromExpression:(KSMExpression*)expression
{
    // deal with non-binary cases first
    if (!expression.valid) {
        return expression;
    }

    switch (expression.expressionType) {
        case KSMExpressionTypeLiteral:
            return expression;
            
        case KSMExpressionTypeVariable:
            return expression;
            
        default:
            // Everything else is a binary expression that needs deeper processing
            break;
    }
    
    // For binary expressions we have to process left and right operands recursively
    KSMExpression * left;
    KSMExpression * right;
    [self getLeftOperandResult:&left
            rightOperandResult:&right
                fromExpression:expression];

    // If either of the left or right expressions are invalid, we can't simplify
    if (! ([left valid] && [right valid]) ) return expression;

    // Okay, everything valid, so we begin by simplifying the left and right expressions and then we attempt to simplify their binary composition
    KSMExpression * simpleLeft  = [self simplifiedExpressionFromExpression:left];
    KSMExpression * simpleRight = [self simplifiedExpressionFromExpression:right];
    NSString * operator = expression.operator;
    
    // Now, can we interpret both as integers? If iLeft and iRight both resolve into proper integers and not NANs, then we are dealing with the simplest case - i,e, expression involving an arithmetic operation between purely integer operands, so expressions like 2 * 4, or 7 / 2, etc.
    NSInteger iLeft = [self integerValueForLiteralOrVariableExpression:simpleLeft];
    NSInteger iRight =[self integerValueForLiteralOrVariableExpression:simpleRight];
    if ( ! (iLeft == NAN || iRight == NAN))
    {
        // Yes, we are dealing with an expression of the form intA * intB where here * stands for any arithmetic operator. The simplification in this sense is mostly trivial, with only intA / intB requiring genuine simplification (as opposed to arithmetic evaluation). Still, in order to keep this method as simple as possible, we will delegate the work to another method...
        return [self expressionSimplifyingLeftInteger:iLeft
                                             operator:operator
                                         rightInteger:iRight];
    }
    
    // Todo: could either keep things simple for now and just return the expression, effectively saying that we can't simplify expressions more complex that binary arithmetical operations on integer operands, or we take the next step and try to process int + rational fraction, rational fraction + rational fraction, etc
    
    // Keeping things simple for now...
    return expression;
}

-(NSInteger)integerValueForLiteralOrVariableExpression:(KSMExpression*)expression
{
    NSString * string = expression.string;
    switch (expression.expressionType) {
        case KSMExpressionTypeLiteral:
            return interpretDoubleAsInteger([string doubleValue]);

        case KSMExpressionTypeVariable:
        {
            NSNumber * n = self.worksheet.variablesDictionary[expression.symbol];
            return interpretDoubleAsInteger([n doubleValue]);
        }
        default:
            break;
    }
    return NAN;
}

-(double)doubleValueForExpression:(KSMExpression*)expression
{
    if (!expression) return 0;
    if (!expression.valid) return NAN;
    if (expression.expressionType == KSMExpressionTypeLiteral)
        return [expression.string doubleValue];
    if (expression.expressionType == KSMExpressionTypeVariable) {
        NSNumber * n = self.worksheet.variablesDictionary[expression.symbol];
        return [n doubleValue];
    }
    
    KSMExpression * leftExpression;
    KSMExpression * rightExpression;
    NSString * operator = expression.operator;
    [self getLeftOperandResult:&leftExpression
            rightOperandResult:&rightExpression
                fromExpression:expression];
    double leftValue = [self doubleValueForExpression:leftExpression];
    double rightValue = [self doubleValueForExpression:rightExpression];
    
    if ([operator isEqualToString:kPower])      return pow(leftValue, rightValue);
    if ([operator isEqualToString:kMultiply])   return leftValue * rightValue;
    if ([operator isEqualToString:kDivide])     return leftValue / rightValue;
    if ([operator isEqualToString:kAdd])        return leftValue + rightValue;
    if ([operator isEqualToString:kSubtract])   return leftValue - rightValue;
    return NAN;
}

-(void)getLeftOperandResult:(KSMExpression**)leftExpression
         rightOperandResult:(KSMExpression**)rightExpression
             fromExpression:(KSMExpression*)expression
{
    NSString * leftSymbol = expression.leftOperand;
    NSString * rightSymbol = expression.rightOperand;
    KSMExpression * leftExpr = [self.worksheet.expressionsDictionary objectForKey:leftSymbol];
    KSMExpression * rightExpr = [self.worksheet.expressionsDictionary objectForKey:rightSymbol];
    
    *leftExpression  = [self simplifiedExpressionFromExpression:leftExpr];
    *rightExpression = [self simplifiedExpressionFromExpression:rightExpr];
    
    return;
}

-(KSMExpression*)expressionSimplifyingLeftInteger:(NSInteger)left
                                         operator:(NSString*)operator
                                     rightInteger:(NSInteger)right
{
    NSString * sResult;
    
    // Division is simplified by dividing both numerator and denominator by their gcd 
    if ([operator isEqualToString:kDivide]) {
        double result = (double)left / (double)right;
        if ( (result - (long)result) == 0) {
            // The second integer is a divisor of the first, so we can just do the division
            return [[KSMExpression alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)result]];
        }
        
        NSInteger g = gcd(left, right);
        left = left / g;
        right = right / g;
        NSString * sLeft = [NSString stringWithFormat:@"%ld", left];
        NSString * sRight = [NSString stringWithFormat:@"%ld", right];
        sResult = [sLeft stringByAppendingString:kDivide];
        sResult = [sResult stringByAppendingString:sRight];
        return [[KSMExpression alloc] initWithString:sResult];
    }
    
    // all other operations are much simpler...
    NSInteger iResult = NAN;
    if ([operator isEqualToString:kPower])      iResult = pow(left, right);
    if ([operator isEqualToString:kMultiply])   iResult = left * right;
    if ([operator isEqualToString:kAdd])        iResult = left + right;
    if ([operator isEqualToString:kSubtract])   iResult = left - right;
    sResult = [NSString stringWithFormat:@"%ld",iResult];
    return [[KSMExpression alloc] initWithString:sResult];
}

-(NSString*)stringByExpandingSymbolsInExpression:(KSMExpression*)expression
{
    NSString * str = expression.string;
    NSRange rangeOfSymbol;
    rangeOfSymbol = [KSMExpressionEvaluator rangeOfFirstSymbolInString:str operators:expression.arrayOfOperators];
    while ( rangeOfSymbol.location != NSNotFound ) {
        
        str = [self stringBySubstitutingValueForSymbol:rangeOfSymbol inString:str];
        rangeOfSymbol = [KSMExpressionEvaluator rangeOfFirstSymbolInString:str operators:expression.arrayOfOperators];
    }
    
    return str;
}

-(NSString*)stringBySubstitutingValueForSymbol:(NSRange)symbolRange inString:(NSString*)string
{
    if (symbolRange.location == NSNotFound) return string;
    
    NSString * symbol = [string substringWithRange:symbolRange];
    
    // If the symbol represents a variable, we look up its value
    
    KSMExpression * subExpression = self.worksheet.expressionsDictionary[symbol];
    NSString * substituteString = nil;
    switch (subExpression.expressionType) {
        case KSMExpressionTypeLiteral:
            substituteString = subExpression.string;
            break;
            
        case KSMExpressionTypeVariable:
        {
            NSNumber * n = self.worksheet.variablesDictionary[symbol];
            double d = [n doubleValue];
            NSInteger i = interpretDoubleAsInteger(d);
            if (i == NAN)
                substituteString = [NSString stringWithFormat:@"%f",d];
            else
                substituteString = [NSString stringWithFormat:@"%ld",i];
        
            break;
        }
        case KSMExpressionTypeBinary:
            substituteString = [NSString stringWithFormat:@"(%@)",subExpression.string];
            break;
        
        default:
            break;
    }
    
    return [string stringByReplacingCharactersInRange:symbolRange withString:substituteString];
}

+(NSRange)rangeOfFirstSymbolInString:(NSString*)string operators:(NSArray*)operatorsArray
{
    NSRange rangeOfSymbolPrefix = [string rangeOfString:kSymbolPrefix];
    
    // deal with case that there are no symbols in the string
    if (rangeOfSymbolPrefix.location == NSNotFound)
        return NSMakeRange(NSNotFound, 0);
    
    // read forward until we reach an op or a ")" bracket or reach the end
    NSString * operatorsString = [KSMExpression stringFromOperatorsArray:operatorsArray];
    NSString * testChars = [operatorsString stringByAppendingString:kRightBrace];
    
    NSRange r;
    NSString * nextChar;
    NSUInteger symbolLength = 0;
    NSUInteger index = rangeOfSymbolPrefix.location;
    NSUInteger i = index;
    while (i < [string length]) {
        r = NSMakeRange(i, 1);
        nextChar = [string substringWithRange:r];
        if ([nextChar KSMcontainsCharactersInString:testChars])
            break;
        
        i++;
        symbolLength++;
    }
    return NSMakeRange(index, symbolLength);
}


#pragma mark - C Helper functions -

/*!
 * If the double has no fractional part (in otherwords, can be interpreted as an
 * integer with no loss of precision, then this function returns that double. If
 * the fractional part is non-zero, then NAN is returned.
 * @Param d The double to investigate.
 * @Return An integer exactly equivalent to d if d has no fractional part, 
 * otherwise returns the integer NAN.
 */
NSInteger interpretDoubleAsInteger(double d)
{
    return ( (d - (NSInteger)d)==0 ) ? (NSInteger)d : NAN;
}

/*!
 * Calculates the lowest common multiple of two integers, a and b.
 * @Param a The first of the two integers.
 * @Param b The second of the two integers.
 * @Return The lowest common multiple of the two integers.
 */
NSInteger lcm(NSInteger a, NSInteger b)
{
    // Relies on theorem stating that lcm(a,b) * gmd(a,b) = a * b
    NSInteger g = gcd(a, b);
    return a * b / g;
}

/*!
 * Calculates the greatest common divisor of two integers, a and b.
 * @Param a The first of the two integers.
 * @Param b The second of the two integers.
 * @Return The greatest common divisor of the two integers.
 */
NSInteger gcd(NSInteger a, NSInteger b)
{
    KSMPrimeDecomposition * aPrimes = [[KSMPrimeDecomposition alloc] initWithInteger:a];
    KSMPrimeDecomposition * bPrimes = [[KSMPrimeDecomposition alloc] initWithInteger:b];
    
    KSMPrimeDecomposition * shortestDecomposition;
    KSMPrimeDecomposition * longestDecomposition;
    
    if (aPrimes.primeCount <= bPrimes.primeCount) {
        shortestDecomposition = aPrimes;
        longestDecomposition = bPrimes;
    } else {
        shortestDecomposition = bPrimes;
        longestDecomposition = aPrimes;
    }
    
    NSInteger gcd = 1;
    for (NSInteger i = 0; i < [shortestDecomposition primeCount]; i++) {
        NSUInteger primeNumber = [shortestDecomposition primeAtIndex:i];
        NSUInteger power1 = [shortestDecomposition primePowerAtIndex:i];
        NSUInteger power2 = [longestDecomposition primePowerAtIndex:i];
        NSUInteger lowestPower = MIN(power1, power2);
        gcd *= pow( (double)primeNumber, (double)lowestPower );
    }
    return gcd;
}



@end
