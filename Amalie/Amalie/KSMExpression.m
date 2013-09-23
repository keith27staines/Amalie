//
//  KSMExpression.m
//  ExpressionBuilder
//
//  Created by Keith Staines on 17/06/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMExpression.h"
#import "NSString+KSMMath.h"
#import "KSMSymbolProvider.h"
#import "KSMReferenceCounter.h"

NSString * const kOperatorsString = @"^*/+-∧∘";
NSString * const kBinaryOperatorsString = @"^*/+-∧∘";
NSString * const kAllowedCharacters = @"$abcdefghijklmnopqrtsuvwxyz0123456789_";
NSString * const kLeftBrace = @"(";
NSString * const kRightBrace = @")";
NSString * const kSpace = @" ";
NSString * const kEmpty = @"";
NSString * const kSymbolPrefix = @"$";

NSString * const kPower = @"^";
NSString * const kMultiply = @"*";
NSString * const kDivide = @"/";
NSString * const kAdd = @"+";
NSString * const kSubtract = @"-";
NSString * const kVectorMultiply = @"∧";
NSString * const kScalarMultiply = @"∘";

@interface KSMExpression()
{
    NSString * _symbol;
    NSString * _originalString;
    NSString * _blackString;
    NSString * _string;
    NSArray * _operatorsArray;
    NSMutableDictionary * _subExpressions;
    NSUInteger _targetBracketCount;
    KSMExpressionType _expressionType;
    KSMReferenceCounter * _referenceCounter;
}

@property (readwrite) KSMExpressionType expressionType;
@property (readwrite) NSString * blackString;
@property (readwrite) NSString * string;
@property (readwrite) KSMExpressionValidity validityType;
@property (readwrite) NSString * leftOperand;
@property (readwrite) NSString * rightOperand;
@property (readwrite) NSString * operator;
@property (readwrite) BOOL       isBracketed;
@property (readwrite) BOOL       hasAddedLogicalLeadingZero;

@end

@implementation KSMExpression

-(NSString *)bareString
{
    NSString * blackCopy = [self.blackString copy];
    return [KSMExpression stripEnclosingBrackets:blackCopy];
}

-(BOOL)terminal
{
    if (self.expressionType == KSMExpressionTypeVariable ||
        self.expressionType == KSMExpressionTypeLiteral ||
        self.expressionType == KSMExpressionTypeBinary)
    {
        return YES;
    }
    return NO;
}

// Use initWithString
-(id)init
{
    // Raise an exception - we want the user to use a different constructor.
    [NSException raise:@"Use initWithString" format:nil];
    return nil;
}

// Designated constructor
-(id)initWithString:(NSString*)string
{
    self = [super init];
    if (self) {
        if (!string) [NSException raise:@"The string is nil." format:nil];
        
        // The original string, exactly as presented to us.
        _originalString = [string copy];
        
        // _string is our working string, and will be modified during processing
        _string = [string stringByReplacingOccurrencesOfString:kSpace
                                                    withString:kEmpty];
        

        // Record the bare string, with spaces removed. The bare string will be the basis of the hash (and thus is used to build the symbol, as returned by the symbol property).
        _blackString = [_string copy];
        
        _operatorsArray = [KSMExpression operatorsArray];
        _leftOperand    = nil;
        _rightOperand   = nil;
        _operator       = nil;
        [self analyse];
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@<%@>%@",[super description],self.symbol, self.stringMakingSymbol];
}

+(NSArray*)operatorsArray
{
    return @[kPower, kMultiply, kDivide, kAdd, kSubtract, kScalarMultiply, kVectorMultiply];
}

+(KSMOperatorType)operatorTypeFromString:(NSString *)operator
{
    if ([operator isEqualToString:kPower])          return KSMOperatorTypePower;
    if ([operator isEqualToString:kAdd])            return KSMOperatorTypePower;
    if ([operator isEqualToString:kSubtract])       return KSMOperatorTypePower;
    if ([operator isEqualToString:kMultiply])       return KSMOperatorTypePower;
    if ([operator isEqualToString:kDivide])         return KSMOperatorTypePower;
    if ([operator isEqualToString:kScalarMultiply]) return KSMOperatorTypePower;
    if ([operator isEqualToString:kVectorMultiply]) return KSMOperatorTypePower;
    
    NSLog(@"Operator %@ is not recognised.",operator);
    return KSMOperatorTypeUnrecognized;
}

-(NSString *)symbol
{
    if (!_symbol) {
        KSMSymbolProvider * symbolProvider = [KSMSymbolProvider sharedSymbolProvider];
        _symbol = [symbolProvider symbolForString:[self stringMakingSymbol]];
    }
    return _symbol;
}

-(KSMReferenceCounter *)referenceCounter
{
    return _referenceCounter;
}

-(void)setReferenceCounter:(KSMReferenceCounter *)referenceCounter
{
    if (!_referenceCounter) {
        _referenceCounter = referenceCounter;
    } else {
        NSAssert(referenceCounter == _referenceCounter, @"Attempt was made to change the receiver's reference counter.");
    }
}

-(NSString*)stringMakingSymbol
{
    if (self.expressionType == KSMExpressionTypeVariable) {
        return self.bareString;
    } else {
        return self.blackString;
    }
}

-(BOOL)valid
{
    return  (self.validityType < KSMExpressionValidityInvalid);
}

+(NSString*)encloseInBrackets:(NSString *)string
{
    // If the expression is already fully enclosed, there is nothing to do.
    if ([KSMExpression isEnclosedInBrackets:string]) return string;
    
    // add ( as a prefix and ) as a postfix
    return [NSString stringWithFormat:@"%@%@%@",
              kLeftBrace,
              string,
              kRightBrace];
}

-(void)analyse
{
    
    // Empty string cannot be a legal expression
    if (!self.string || [self.string length] == 0) {
        self.expressionType = KSMExpressionTypeUnrecognized;
        self.validityType = KSMExpressionValidityInvalidZeroLength;
        return;
    }
    
    // String must have valid bracket syntax if we are to analyse it
    if ( ![self isBracketSyntaxGood]) {
        self.expressionType = KSMExpressionTypeUnrecognized;
        self.validityType = KSMExpressionValidityInvalidBracketSyntax;
        return;
    }
    
    // Ensure that there are NO outer brackets and that any leading minus signs are regularised - i.e, -a -> 0-a
    self.isBracketed = [KSMExpression isEnclosedInBrackets:self.string];
    self.string = [KSMExpression stripEnclosingBrackets:self.string];
    self.string = [self regularizeLeadingMinus];
    [self determineExpressionType];
    
    // If we are a variable or a number, we're done.
    if (self.expressionType == KSMExpressionTypeLiteral ||
        self.expressionType == KSMExpressionTypeVariable) return;
    
    // We are a compound expression, so create a dictionary and populate with strings corresponding to first-level subexpressions
    [self createExpressionDictionary];
    [self replaceBracketedSubstringsWithSymbols];
    
    // Our string is now bracketless, i.e the current form is x, where x is an expression with no explicit brackets but with at least one operator. We make sure x conforms to the usual rules of arithmetic
    if (![self validateBracketlessArithmeticExpression]) {
        self.validityType = KSMExpressionValidityInvalidOperatorSyntaxOrVariableName;
        self.expressionType = KSMExpressionTypeUnrecognized;
        return;
    }
    
    // We now have a bracketless string that is arithmetically valid. We now need to reduce the compound expression to binary subexpressions. We do this by finding the highest precedence operator in the string and replacing its binary expression (which is itself and its left and right arguments) with a symbol, and repeating until all we have left is a binary expression
    [self reduceCompoundExpressionToBinaryOrUnary];
    
    // We're done
    return;
    
    //TODO: add code to verify and evaluate content of complex brackets eg (sin(x) +exp(y)^2)
    
    //TODO: add code to veryify and evaluate content of brackets of multi-variable functions eg (dist(x,y))
}

-(KSMExpressionType)determineExpressionType
{
    _symbol = nil; // Because what we are doing here may change the symbol. This only matters if the symbol is inspected (and hence set) before this method was called.
    
    NSUInteger operatorCount = [KSMExpression operatorCountInString:self.string
                                                      operatorArray:self.arrayOfOperators];
    if (operatorCount > 1) {
        self.expressionType = KSMExpressionTypeCompound;
        return _expressionType;
    }
    
    if (operatorCount == 1) {
        self.expressionType = KSMExpressionTypeBinary;
        return _expressionType;
    }
    
    // OperatorCount is exactly 0 so we are a constant or variable
    if ([self.string KSMvalidName]) {
        self.expressionType = KSMExpressionTypeVariable;
        return _expressionType;
    }
    
    // we are if we are a pure number
    if ([self.string KSMpureNumber]) {
        self.expressionType = KSMExpressionTypeLiteral;
        return _expressionType;
    }
    
    // Other cases can only arise if the string is invalid
    self.expressionType = KSMExpressionTypeUnrecognized;
    return _expressionType;
}

+(NSString*)stripEnclosingBrackets:(NSString*)string
{
    // If we aren't enclosed in brackets, there is nothing to remove
    if (![KSMExpression isEnclosedInBrackets:string]) return string;
    
    // string is enclosed in its outermost brackets so remove them
    NSRange unclothedRange = NSMakeRange(1, [string length]-2);
    NSString * unclothedString = [string substringWithRange:unclothedRange];
    return unclothedString;
}

+(BOOL)isEnclosedInBrackets:(NSString*)string
{
    // If the outermost characters are not brackets the entire expression is not enclosed in brackets
    if ( !( [[string KSMfirstCharacter] isEqualToString:kLeftBrace] &&
           [[string KSMlastCharacter]  isEqualToString:kRightBrace] ) )
        return NO;
    
    // Must still allow for cases like (a+b)*(c+d) where the outermost characters are brackets but the entire expression isn't bracketed.
    NSInteger openBracketCount = 0;
    NSString * character;
    for (int i = 0; i < [string length]; i++) {
        NSRange r = NSMakeRange(i, 1);
        character = [string substringWithRange:r];
        
        if ([character isEqualToString:kLeftBrace]) openBracketCount++;
        if ([character isEqualToString:kRightBrace]) openBracketCount--;
        
        // If the bracket count reaches zero before the end of the string then the string isn't entirely closed in brackets.
        if ( openBracketCount == 0 && i < [string length] - 1) return NO;
    }
    
    return YES;
}

-(BOOL)reduceCompoundExpressionToBinaryOrUnary
{
    NSAssert([self isBracketless], @"This method requires the string to be singly bracketed.");
    
    // First check to see if we are already unary (i.e, simpler than binary)
    if ( [self.string KSMpureNumber] ) {
        self.expressionType = KSMExpressionTypeLiteral;
        return YES;
    }
    
    if ( [self.string KSMvalidName] ) {
        self.expressionType = KSMExpressionTypeVariable;
        return YES;
    }
    
    // We are at least a binary expression and possibly more complex than that. So we iteratively reduce the complexity of the expression, operator by operator, until we are a binary expression.
    while ( ! [KSMExpression isStringBinaryExpression:self.string
                                         operators:self.arrayOfOperators] ) {
        // reduce complexity by substituting highest precedence (taking left-most first to tie-break) operator
        [self replaceHighestPrecedenceOperatorWithSubExpression];
    }
    
    // We are now reduced to a binary expression
    self.expressionType = KSMExpressionTypeBinary;
    
    // record the operator type
    NSUInteger operatorIndex = [self rangeOfHighestPrecedenceOperator].location;
    self.operator = [self.string substringWithRange:NSMakeRange(operatorIndex, 1)];

    // ensure that both operands of the binary expression are represented by KSMExpressions
    NSRange leftRange = [self rangeOfPreviousTokenToIndex:operatorIndex - 1];
    NSRange rightRange = [self rangeOfNextTokenFromIndex:operatorIndex + 1];
    
    // substrings representing left and right terms (one or both might not  yet be symbols so we have to check and convert to an expression any term not yet represented by an expression
    NSString * leftSymbol = [self.string substringWithRange:leftRange];
    NSString * rightSymbol = [self.string substringWithRange:rightRange];

    // substitute symbols working from right to avoid messing up ranges
    if ( ! [KSMExpression isSymbol:rightSymbol] ) {
        // right term is not a symbol
        rightSymbol = [self createSymbolAndExpressionEquivalentToSubstring:rightSymbol];
        self.string = [self.string stringByReplacingCharactersInRange:rightRange
                                                           withString:rightSymbol];
    }
    if ( ! [KSMExpression isSymbol:leftSymbol] ) {
        // left term is not a symbol
        leftSymbol = [self createSymbolAndExpressionEquivalentToSubstring:leftSymbol];
        self.string = [self.string stringByReplacingCharactersInRange:leftRange
                                                           withString:leftSymbol];
    }

    self.leftOperand = leftSymbol;
    self.rightOperand = rightSymbol;
    
    return YES;
}

+(BOOL)isSymbol:(NSString*)string
{
    return ([[string KSMfirstCharacter] isEqualToString:kSymbolPrefix]) ? YES : NO;
}

-(BOOL)replaceHighestPrecedenceOperatorWithSubExpression
{
    NSAssert([self isBracketless], @"This method requires the string to be singly bracketed.");

    // Find highest precedence operator
    NSRange r = [self rangeOfHighestPrecedenceOperator];
    if (r.location == NSNotFound) return NO;
    
    // find tokens either side of operator
    NSRange rightTokenRange = [self rangeOfNextTokenFromIndex:r.location+1];
    NSRange leftTokenRange = [self rangeOfPreviousTokenToIndex:r.location-1];
    
    // The substring spanning the range of the left token, operator, and right token is a binary expression which we can replace in the current string with a symbol
    NSRange binaryRange = NSMakeRange(leftTokenRange.location, rightTokenRange.location + rightTokenRange.length - leftTokenRange.location);
    
    NSString * binaryString = [self.string substringWithRange:binaryRange];
    NSString * symbol;
    symbol = [self createSymbolAndExpressionEquivalentToSubstring:binaryString];
    
    self.string = [self.string stringByReplacingOccurrencesOfString:binaryString
                                                         withString:symbol];
    return YES;
}

+(NSRange)rangeOfHighestPrecedenceOperatorInString:(NSString*)string
                                        operators:(NSArray*)operatorsArray
{
    NSRange notFound = NSMakeRange(NSNotFound, 0);
    
    if (!string) return notFound;
    if ([string length] == 0) return notFound;
 
    if ( ![KSMExpression isBracketlessString:string] ) {
        [NSException raise:@"This method requires the string to be singly bracketed." format:nil];
    }
    
    NSRange r = notFound;
    for (NSString * op in operatorsArray) {
        r = [string rangeOfString:op];
        if (r.location != NSNotFound) {
            break;
        }
    }
    return r;
}

-(NSRange)rangeOfHighestPrecedenceOperator
{
    return [KSMExpression rangeOfHighestPrecedenceOperatorInString:self.string
                                                        operators:self.arrayOfOperators];
}

+(NSString*)regularizeLeadingMinusInString:(NSString*)string
{
    if ([KSMExpression isLeadingMinusRegularizedInString:string])
        return string;
    
    // convert -... to 0-...
    return [NSString stringWithFormat:@"0%@",[string substringFromIndex:0]];
}

+(BOOL)isLeadingMinusRegularizedInString:(NSString*)string
{
    if (!string) return YES;
    if ([string length] < 1) return YES;
    
    NSString * firstChar = [string substringWithRange:NSMakeRange(0, 1)];
    return ( ![firstChar isEqualToString:kSubtract] );
}

-(BOOL)isLeadingMinusRegularized
{
    return [KSMExpression isLeadingMinusRegularizedInString:self.string];
}

/// convert expressions like (-a + b) into (0 - a + b)
-(NSString*)regularizeLeadingMinus
{
    if ( ![KSMExpression isLeadingMinusRegularizedInString:self.string] ) {
        self.hasAddedLogicalLeadingZero = YES;
        return [KSMExpression regularizeLeadingMinusInString:self.string];
    }
    return self.string;
}

/*! 
 * Validates that the current string is of the form "x", where x is a valid
 * arithmetic expression with no explicit brackets (Outer brackets are implicit).
 */
-(BOOL)validateBracketlessArithmeticExpression
{
    // if we aren't singly bracketed, we have an immediate fail.
    if (![self isBracketless]) return NO;
    
    // Unregularised minus signs are a fail
    if (![self isLeadingMinusRegularized]) return NO;
    
    // Possibly an empty string, which we treat as invalid
    if (self.string.length == 0) return NO;
    
    // Variables or pure numbers are valid
    if ( [self.string KSMpureNumber]) return YES;
    if ( [self.string KSMvalidName]) return YES;
    
    /* Having elimintated other possibilites, the format should now be 
     * a1 . a2 . a3...  * aN where . stands for ANY
     * operator and ai represents any expression that is either a valid 
     * algebraic variable name or else a purely numerical quantity
     */
    
    // check that variables alternate with operators
    NSUInteger index = 0;
    BOOL operatorExpected = NO;
    NSRange tokenRange;
    NSString * token;

    while (index < [self.string length]) {
        
        if (operatorExpected) {
            // token is expected to be an operator
            tokenRange = NSMakeRange(index, 1);
            token = [self.string substringWithRange:tokenRange];
            if ( ![self isStringAnOperator:token] ) return NO;
        } else {
            // token is expected to be a variable or a number
            tokenRange = [self rangeOfNextTokenFromIndex:index];
            token = [self.string substringWithRange:tokenRange];
            if ( !( [token KSMvalidName]  || [token KSMpureNumber] ) )
                return NO;
        }
        
        // swap between search for operator and variable
        operatorExpected = !operatorExpected;
        
        index+=[token length];
    }
    
    // looks like a good expression
    return YES;
}

+(NSRange)rangeInExpressionString:(NSString*)string
           ofTokenPreviousToIndex:(NSUInteger)index
             delimitedByoperators:(NSArray*)operatorsArray
{
    
    // checks index must be the last character in the string, OR the next character must be be an operator or be a right brace.
    if (index != 0) {
        NSString * nextChar = [string substringWithRange:NSMakeRange(index+1,1)];
        if ( ![nextChar isEqualToString:kRightBrace]) {
            if ( ! [KSMExpression isStringAnOperator:nextChar
                                    operatorArray:operatorsArray]) {
                // Can't process this as we are starting mid-token
                [NSException raise:@"Index must be end of string or the index of an operator or a right bracket." format:nil];
            }
        }
    }
    
    // Read backward until we reach an op or a "(" bracket    
    NSString * operatorsString = [KSMExpression stringFromOperatorsArray:operatorsArray];
    NSString * testChars = [operatorsString stringByAppendingString:kLeftBrace];
    
    NSRange r;
    NSString * prevChar;
    NSUInteger tokenLength = 1;
    NSInteger i = index;
    while (i >= 0) {
        r = NSMakeRange(i, 1);
        prevChar = [string substringWithRange:r];
        if ([prevChar KSMcontainsCharactersInString:testChars])
            break;
        i--;
        tokenLength++;
    }
    
    return NSMakeRange(++i, --tokenLength);
}

+(NSRange)rangeInExpressionString:(NSString*)string
        ofTokenFromIndex:(NSUInteger)index
             delimitedByoperators:(NSArray*)operatorsArray
{
    // checks index must be the first character in the string, OR the previous character must be be an operator or be a left brace.
    if (index != 0) {
        NSString * prevChar = [string substringWithRange:NSMakeRange(index-1,1)];
        if ( ![prevChar isEqualToString:kLeftBrace]) {
            if ( ! [KSMExpression isStringAnOperator:prevChar
                                    operatorArray:operatorsArray]) {
                // Can't process this as we are starting mid-token
                [NSException raise:@"Index must be zero or the index of an operator or a left bracket." format:nil];
            }
        }
    }
    
    // read forward until we reach an op or a ")" bracket or reach the end
    NSString * operatorsString = [KSMExpression stringFromOperatorsArray:operatorsArray];
    NSString * testChars = [operatorsString stringByAppendingString:kRightBrace];
    
    NSRange r;
    NSString * nextChar;
    NSUInteger tokenLength = 0;
    NSUInteger i = index;
    while (i < [string length]) {
        r = NSMakeRange(i, 1);


        nextChar = [string substringWithRange:r];
        if ([nextChar KSMcontainsCharactersInString:testChars])
            break;
        
        i++;
        tokenLength++;
    
    }
    
    return NSMakeRange(index, tokenLength);

}

-(NSRange)rangeOfPreviousTokenToIndex:(NSUInteger)index
{
    return [KSMExpression rangeInExpressionString:self.string
                           ofTokenPreviousToIndex:index
                             delimitedByoperators:self.arrayOfOperators];
}

-(NSRange)rangeOfNextTokenFromIndex:(NSUInteger)index
{
    return [KSMExpression rangeInExpressionString:self.string
                        ofTokenFromIndex:index
                             delimitedByoperators:self.arrayOfOperators];
}

+(BOOL)isStringAnOperator:(NSString *)string operatorArray:(NSArray *)operators
{
    if (!string) return NO;
    if ([string length] != 1) return NO;
    
    NSString * opString = [KSMExpression stringFromOperatorsArray:operators];
    return ( [opString KSMcontainsCharactersInString:string]? YES: NO );
}

-(BOOL)isStringAnOperator:(NSString*)string
{
    return [KSMExpression isStringAnOperator:string
                               operatorArray:self.arrayOfOperators];
}

+(BOOL)isBracketlessString:(NSString*)string
{
    // outer brackets around string are implicit (because we've already explicitly removed them!), so we actually check for ZERO bracket count.
    if ([string KSMnumberOfOccurencesOfString:kLeftBrace]  > 0)  return NO;
    if ([string KSMnumberOfOccurencesOfString:kRightBrace] > 0)  return NO;
    return YES;
}

-(BOOL)isBracketless
{
    return [KSMExpression isBracketlessString:self.string];
}

+(BOOL)isStringBinaryExpression:(NSString*)string operators:(NSArray*)operators
{
    
    // Binary expressions are singly bracketed
    if (![KSMExpression isBracketlessString:string]) return NO;
    
    // Binary expressions have exactly one operator
    if ([KSMExpression operatorCountInString:string
                               operatorArray:operators] != 1) return NO;
    
    // Determine the position of the operator (which, since it is the only operator, must be the highest precedence operator in the expression)
    NSRange operatorRange;
    operatorRange = [KSMExpression rangeOfHighestPrecedenceOperatorInString:string
                                                                  operators:operators];
    if (operatorRange.location == NSNotFound) return NO;
    
    // Attempt to find the token on the left
    NSRange leftTokenRange;
    leftTokenRange = [KSMExpression rangeInExpressionString:string
                           ofTokenPreviousToIndex:operatorRange.location-1
                                       delimitedByoperators:operators];
    if (leftTokenRange.location == NSNotFound) return NO; // left operand missing
    
    
    // Attempt to find the token on the right of the operator
    NSRange rightTokenRange;
    rightTokenRange = [KSMExpression rangeInExpressionString:string
                            ofTokenFromIndex:operatorRange.location+1 delimitedByoperators:operators];
    if (rightTokenRange.location == NSNotFound) return NO;
    
    // For the string to be a binary expression, we require that the first character of the left token be the first character in the string (i.e, at index 0), and the last character of the right token be the last character in the string.
    if (leftTokenRange.location != 0) return NO;
    if ( (rightTokenRange.location + rightTokenRange.length) != [string length])
        return NO;
    
    // Both tokens found. Singly bracketed. Contains exactly one operator, everything in the right position, hence we are a binary expression
    
    return YES;
}

-(BOOL)isBinaryExpression
{
    return [KSMExpression isStringBinaryExpression:self.string
                                         operators:self.arrayOfOperators];
}

+(NSString *)stringFromOperatorsArray:(NSArray *)operatorsArray
{
    NSString * str = kEmpty;
    for (NSString * op in operatorsArray) {
        str = [str stringByAppendingString:op];
    }
    return str;
}

+(NSUInteger)operatorCountInString:(NSString*)string operatorArray:(NSArray*)operators
{
    NSUInteger opCount = 0;
    for (NSString * op in operators) {
        opCount += [string KSMnumberOfOccurencesOfString:op];
    }
    return opCount;
}

-(void)createExpressionDictionary
{
    _subExpressions = [NSMutableDictionary dictionary];
    
    NSUInteger location = NSNotFound;
    NSUInteger length = 0;
    NSString * character;
    NSString * substring;
    NSInteger openBracketCount = 0;
    for (int i = 0; i < [self.string length]; i++) {
        NSRange r = NSMakeRange(i, 1);
        character = [self.string substringWithRange:r];
        
        if ([character isEqualToString:kLeftBrace]){
            openBracketCount++;
            if (openBracketCount == 1) {
                location = i;
                length = 0;
            }
        }
        
        if (location != NSNotFound) length++;
        
        if ([character isEqualToString:kRightBrace]) {
            openBracketCount--;
            if (openBracketCount == 0) {
                NSRange range = NSMakeRange(location, length);
                substring = [_string substringWithRange:range];
                [self createSymbolAndExpressionEquivalentToSubstring:substring];
                location = NSNotFound;
            }
        }
    }
}

-(void)replaceBracketedSubstringsWithSymbols
{
    for (NSString * key in self.subExpressions) {
        KSMExpression * expression = [self.subExpressions objectForKey:key];
        NSString * originalString = [expression originalString];
        self.string = [self.string stringByReplacingOccurrencesOfString:originalString
                                                             withString:key];
    }
}

-(NSString*)createSymbolAndExpressionEquivalentToSubstring:(NSString*)substring
{
    if (!_subExpressions) _subExpressions = [NSMutableDictionary dictionary];
    KSMExpression * subExpression = [[KSMExpression alloc] initWithString:substring];
    NSString * symbol = [subExpression symbol];
    [_subExpressions setObject:subExpression forKey:symbol];
    return symbol;
}

+(BOOL)isBracketSyntaxGood:(NSString*)stringExpression
{
    NSInteger openBracketCount = 0;
    NSString * character;
    for (int i = 0; i < [stringExpression length]; i++) {
        NSRange r = NSMakeRange(i, 1);
        character = [stringExpression substringWithRange:r];
        
        if ([character isEqualToString:kLeftBrace]) openBracketCount++;
        if ([character isEqualToString:kRightBrace]) openBracketCount--;
        
        // Are brackets out of order? e.g  )(
        if (openBracketCount < 0) return NO;
    }
    
    // check to see if all brackets are closed
    if (openBracketCount > 0) return NO;
    
    // All checks ok
    return YES;
}

-(BOOL)isBracketSyntaxGood
{
    // Private method
    return [KSMExpression isBracketSyntaxGood:self.string];
}

-(NSArray*)arrayOfOperators
{
    return @[kPower, kMultiply, kDivide, kAdd, kSubtract];
}

-(NSMutableDictionary *)subExpressions
{
    if (!_subExpressions) {
        _subExpressions = [NSMutableDictionary dictionary];
    }
    return _subExpressions;
}

-(void)dealloc
{
    if (self.referenceCounter) {
        [self.referenceCounter objectIsDeallocating:self];
    }
}


@end
