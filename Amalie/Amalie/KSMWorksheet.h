//
//  KSMWorksheet.h
//  KSMath
//
//  Created by Keith Staines on 26/06/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class KSMExpression;
@class KSMExpressionBuilder;
@class KSMExpressionEvaluator;

#import <Foundation/Foundation.h>

@interface KSMWorksheet : NSObject

@property (copy, readwrite) NSString* title;
@property (strong, readonly) KSMExpressionBuilder * builder;
@property (strong, readonly) KSMExpressionEvaluator * evaluator;
@property (strong, readonly) NSMutableDictionary * variablesDictionary;
@property (strong, readonly) NSMutableDictionary * expressionsDictionary;

/*!
 * Registers the expression in the receiver's store. The
 * expression, and if the expression represents a variable, then the variable as
 * well, will be registered, as will all subexpressions and variables.
 * @Param expression The expression to register
 * @Returns The symbol now associated with the expression. The symbol is the
 * key required to find the expression in the receiver's dictionary.
 */
-(NSString*)registerExpression:(KSMExpression*)expression;

/*!
 * Builds a KSMExpression from the supplied string and registers the string in
 * the receiver's store.
 * @Param string The string to build into an expression.
 * @Returns The symbol now associated with the expression in the parent
 * worksheet's store.
 */
-(NSString*)buildAndRegisterExpressionFromString:(NSString*)string;

/*!
 * Returns a simplified expression obtained by evaluating and composing all
 * subexpressions of the receiver.
 * @Param expression The expression to evaluate.
 * @Returns The simplified expression
 */
-(KSMExpression*)simplifiedExpressionFromExpression:(KSMExpression*)expression;

-(BOOL)isExpressionWithSymbolRegistered:(NSString*)symbol;
-(KSMExpression*)expressionForSymbol:(NSString*)symbol;
-(KSMExpression*)expressionForOriginalString:(NSString*)string;
-(KSMExpression*)expressionForString:(NSString*)string;
-(NSNumber*)variableForSymbol:(NSString*)symbol;
-(void)setValue:(NSNumber*)number forVariableWithSymbol:(NSString*)symbol;

@end
