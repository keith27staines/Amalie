//
//  KSMExpression.h
//  ExpressionBuilder
//
//  Created by Keith Staines on 17/06/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kOperatorsString;
extern NSString * const kBinaryOperatorsString;
extern NSString * const kAllowedCharacters;
extern NSString * const kLeftBrace;
extern NSString * const kRightBrace;
extern NSString * const kSpace;
extern NSString * const kEmpty;
extern NSString * const kSymbolPrefix;

extern NSString * const kPower;
extern NSString * const kMultiply;
extern NSString * const kDivide;
extern NSString * const kAdd;
extern NSString * const kSubtract;


typedef enum KSMExpressionType : NSInteger {
    KSMExpressionTypeUnrecognized = -1,
    KSMExpressionTypeVariable = 0,
    KSMExpressionTypeLiteral = 1,
    KSMExpressionTypeBinary = 2,
    KSMExpressionTypeCompound = 3
} KSMExpressionType;

//
typedef enum KSMExpressionValidity : NSInteger {
    KSMExpressionValidityValid = 0,
    KSMExpressionValidityInvalid = 1,
    KSMExpressionValidityInvalidZeroLength = 2,
    KSMExpressionValidityInvalidBracketSyntax = 4,
    KSMExpressionValidityInvalidOperatorSyntaxOrVariableName = 8
} KSMExpressionValidity;

/*!
 * The KSMExpression class represents a mathematical expression
 */
@interface KSMExpression : NSObject

/*!
 * Gets the string that the expression was initialised with.
 */
@property (readonly) NSString * originalString;

/*!
 * Gets the processed string after full-depth analysis.
 */
@property (readonly) NSString * string;

/*!
 * The original string, with white spaces removed. The black string will be the 
 * basis of the hash (and thus is used to build the symbol returned by the symbol
 * property).
 */
@property (readonly) NSString * blackString;


/*!
 * The original string, divested of white space and enclosing brackets
 */
@property (readonly) NSString * bareString;

/*!
 * Gets the array of operators that may be employed withing the expression.
 */
@property (readonly) NSArray * arrayOfOperators;

/*!
 * Gets the top-level sub-expressions appearing in the current instance.
 * @Returns The dictionary of subexpressions.
 */
@property (readonly) NSDictionary * subExpressions;

/*!
 * Gets the type of the expression, derived after analysis of the original string.
 */
@property (readonly) KSMExpressionType expressionType;

/*!
 * Gets the expression validity, derived after analysis of the original string.
 */
@property (readonly) KSMExpressionValidity validityType;

/*!
 * Gets the terminal status of the expression.
 */
@property (readonly) BOOL terminal;

/*!
 * Gets the syntactic validity of the expression.
 */
@property (readonly) BOOL valid;

/*! Returns an algebraic symbol ($xxxxx) which is generated from the string 
 * representation of the expression, and which can be used to uniquely identify 
 * this expression 
 */
@property (readonly) NSString * symbol;

@property (readonly) NSString * leftOperand;
@property (readonly) NSString * rightOperand;
@property (readonly) NSString * operator;
@property (readonly) BOOL       isBracketed;
@property (readonly) BOOL       hasAddedLogicalLeadingZero;

/*!
 * Do not use init.
 * Unit test coverage: Full.
 */
-(id)init;

/*! Designated constructor.
 * Unit test coverage: Full.
 * @Param string The string (which must not be nil or an exception will be 
 * raised) to be parsed into an expression.
 * @Returns An initialised object if string is not nil.
 */
-(id)initWithString:(NSString*)string;

/*!
 * Examines stringExpression to decide whether the bracket ordering makes sense
 * Unit test coverage: Good.
 * Param stringExpression The string to examine.
 * Returns NO if a logical problem with bracket ordering is detected - e.g, 
 * (a + b)*(c + d) makes sense but (a + b( * ) c + d) does not.
 * @Param stringExpression A string that is to be checked for bracket consistency
 */
+(BOOL)isBracketSyntaxGood:(NSString*)stringExpression;

/*!
 * Determines whether the string is of the form (x), where x can be any string
 * that contains no brackets.
 * Unit test coverage: Good.
 * @Param string
 * @Returns YES if the string is of the form (x), NO otherwise.
 */
+(BOOL)isBracketlessString:(NSString*)string;

/*!
 * Finds the range in the string of the highest precedence operator (precedence 
 * is determined by descending order in the array of operators). Where the 
 * highest precedence operator appears more than once, the the range of the 
 * left-most instance is returned.
 * Unit test coverage: Good.
 * @Param string The string to search. The string must represent a singly 
 * bracketed expression.
 * @Param operators An array of operators, in descending order of precedence.
 * @Returns The range of the highest precedence operator, or {NSNotFound, 0} if
 * string is nil, empty, or doesn't contain any operators.
 */
+(NSRange)rangeOfHighestPrecedenceOperatorInString:(NSString*)string
                                        operators:(NSArray*)operatorsArray;

/*!
 * Determines whether the leading minus is regularised (i.e, appears as part of
 * a binary expression.
 * @Param string The string to check.
 * @Returns YES if the string is nil, has less than three characters, has no
 * minuses, or if the leading minus is preceeded by a term; NO if the string is
 * of the form -x... where x is any string.
 */
+(BOOL)isLeadingMinusRegularizedInString:(NSString*)string;

/*!
 * Converts strings of the form -x to 0-x, where x is any string expression.
 * The effect is to convert the leading minus, which is acting as a sign, into 
 * an equivalent binary operation, 0 - x.
 * Unit test coverage: Good.
 * @Param string The string to regularize.
 * @Returns an arithmetically equivalent, now regularised string.
 */
+(NSString*)regularizeLeadingMinusInString:(NSString*)string;

/*!
 * Locates the token whose last character is at the index position (that
 * character should either be the last character in a string or be succeeded by
 * an operator or a left bracket) and returns the token's range. An exception is
 * raised if these requirements on index are not met.
 * Unit test coverage: Good.
 * @Param string The string to parse.
 * @Param index The index of the character that immediately follows the required 
 * token. This character must be either an operator or a right brace.
 * @Param operatorsArray array of all operators possibly used in the expression
 * @Returns The range of the token.
 */
+(NSRange)rangeInExpressionString:(NSString*)string
           ofTokenPreviousToIndex:(NSUInteger)index
             delimitedByoperators:(NSArray*)operatorsArray;

/*!
 * Locates the token whose first character is at the index position (that
 * character should either be the first character in a string or be preceeded by
 * an operator or a left bracket) and returns the token's range. An exception is
 * raised if these requirements on index are not met.
 * Unit test coverage: Good.
 * @Param string The string to parse.
 * @Param index The index of the character that immediately preceeds the 
 * required token. This character must be either an operator or a left brace.
 * @Param operatorsArray array of all operators possibly used in the expression
 * @Returns The range of the token.
 */
+(NSRange)rangeInExpressionString:(NSString*)string
        ofTokenFromIndex:(NSUInteger)index
             delimitedByoperators:(NSArray*)operatorsArray;

/*!
 * Determines whether the specified string is equal to any one of the operator
 * characters provided in the operators array.
 * Unit test coverage: Good.
 * @Param string A string containing the character to check against the operators
 * @Param operators An array containing all of the operators (each op is a single
 * character string).
 * @Returns YES if the string is an operator, no otherwise. Nil and empty strings
 * return NO
 */
+(BOOL)isStringAnOperator:(NSString*)string operatorArray:(NSArray*)operators;

/*!
 * Determines whether the string is a binary expression, including the operator
 * itself and its left and right arguments or tokens.
 * Unit test coverage: Good.
 * @Param string The string to parse.
 * @Param operators An array containing the operators represented by single 
 * character strings.
 * @Returns YES if the string represents a binary expression, NO otherwise.
 */
+(BOOL)isStringBinaryExpression:(NSString*)string operators:(NSArray*)operators;

/*!
 * Constructs and returns a string containing one character for each of the 
 * operators.
 * Unit test coverage: Good.
 * @Param operatorsArray The array of operators. Each element of the array holds
 * a single character string representing the operator (e.g, *, +, - etc).
 * @Returns A string containing one character for each operator.
 */
+(NSString*)stringFromOperatorsArray:(NSArray*)operatorsArray;

/*!
 * Determines the number of operators that appear in the specified string.
 * Unit test coverage: Good.
 * @Param string The string to parse.
 * @operators An array of single character strings, each one representing an 
 * operator.
 * @Returns The number of operators in the string. For example, a string 
 * "a+b*c+d" has an operator count of 3.
 */
+(NSUInteger)operatorCountInString:(NSString*)string
                     operatorArray:(NSArray*)operators;

/*!
 * Encloses the string in brackets not already enclosed.
 * @Param string The string to cloth in brackets.
 * @Returns The string now enclosed in brackets.
 */
+(NSString*)encloseInBrackets:(NSString *)string;

/*!
 * Remove outermost brackets if they enclose entire expression.
 * @Param string The string to declothe (if necessary).
 * @Returns The string now declothed of enclosing brackets.
 */
+(NSString*)stripEnclosingBrackets:(NSString*)string;

/*!
 * Determines whether the entire expression is enclosed in brackets.
 * @Param string The string to examine.
 * @Returns YES if the string is fully enclosed by outer brackets, otherwise no.
 */
+(BOOL)isEnclosedInBrackets:(NSString*)string;

@end
