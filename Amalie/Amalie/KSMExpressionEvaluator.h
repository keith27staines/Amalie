//
//  KSMExpressionEvaluator.h
//  KSMath
//
//  Created by Keith Staines on 26/06/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class KSMExpression, KSMMathSheet, KSMNumber, KSMMathValue, KSMFunctionArgumentList;

#import <Foundation/Foundation.h>

@interface KSMExpressionEvaluator : NSObject

@property (weak) KSMMathSheet * mathSheet;

/*!
 * This initializer will always throw an exception. Use the designated
 * initializer instead.
 * @Returns Never returns, always throws an exception.
 */
- (id)init;

/*!
 * Designated initializer.
 * Initialises a KSMExpressionEvaluator with its parent mathsheet. The expression
 * evaluator will use backing stores provided by the mathsheet (to register the
 * expressions and variables it builds).
 * @Param mathSheet The parent mathSheet (must not be nil or an exception will
 * be thrown). The mathsheet is referenced by a weak pointer.
 * @Return An initialized object
 */
- (id)initWithMathSheet:(KSMMathSheet*)mathSheet;

/*!
 * Returns a simplified expression obtained by evaluating and composing all
 * subexpressions of the receiver.
 * @Param expression The expression to evaluate.
 * @Returns The simplified expression
 */
-(KSMExpression*)simplifiedExpressionFromExpression:(KSMExpression*)expression;


-(NSString*)stringByExpandingSymbolsInExpression:(KSMExpression*)expression;


-(KSMMathValue*)evaluateExpression:(KSMExpression*)expression
                    usingArguments:(KSMFunctionArgumentList*)arguments;

-(void)getLeftOperandResult:(KSMExpression**)leftExpression
         rightOperandResult:(KSMExpression**)rightExpression
             fromExpression:(KSMExpression*)expression;


@end
