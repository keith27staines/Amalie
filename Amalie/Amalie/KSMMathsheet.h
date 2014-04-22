//
//  KSMMathSheet.h
//  KSMath
//
//  Created by Keith Staines on 26/06/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class KSMExpression;
@class KSMExpressionBuilder;
@class KSMExpressionEvaluator;
@class KSMFunction;
@class KSMFunctionArgumentList;
@class KSMFunctionArgument;

#import <Foundation/Foundation.h>
#import "KSMReferenceCounter.h"
#import "KSMReferenceCountedObject.h"
#import "KSMMathValue.h"

@interface KSMMathSheet : NSObject <KSMReferenceCounterDelegate>

@property (strong, readonly) KSMExpressionBuilder   * builder;
@property (strong, readonly) KSMExpressionEvaluator * evaluator;
@property (strong, readonly) NSMutableDictionary    * expressionsDictionary;
@property (strong, readonly) NSMutableDictionary    * functionsDictionary;

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
 * mathSheet's store.
 */
-(NSString*)buildAndRegisterExpressionFromString:(NSString*)string;

/*!
 * Returns a simplified expression obtained by evaluating and composing all
 * subexpressions of the receiver.
 * @Param expression The expression to evaluate.
 * @Returns The simplified expression
 */
-(KSMExpression*)simplifiedExpressionFromExpression:(KSMExpression*)expression;

/*!
 Decrements the internal reference count for the specified object. The
 object will be deleted when the reference count reaches zero. Call this
 method when a particular instance of the object is to be removed from
 the mathSheet. Note that registerExpression and buildAndRegisterExpression both
 automatically increment the reference count, whether or not the expression being
 registered already exists. Thus there is no need for an explicit method to 
 increment the reference count. Also note that this reference count is not the 
 standard objective C reference count.
 @Param expression The expression whose reference count is to be decremented.
 */
-(void)decrementReferenceCountForObject:(id<KSMReferenceCountedObject>)object;

-(BOOL)isObjectRegistered:(id<KSMReferenceCountedObject>)symbol;
-(KSMExpression*)expressionForSymbol:(NSString*)symbol;
-(KSMFunction*)functionForSymbol:(NSString*)symbol;
-(KSMMathValue*)variableForSymbol:(NSString*)symbol;
-(KSMMathValue*)variableForName:(NSString*)name;

-(KSMExpression*)expressionForOriginalString:(NSString*)string;
-(KSMExpression*)expressionForString:(NSString*)string;
-(KSMFunction*)functionForName:(NSString*)name;
-(BOOL)isKnownObjectName:(NSString*)name;

-(void)setValue:(KSMMathValue*)number forVariableWithSymbol:(NSString*)symbol;

/*!
 Creates and registers a function with a fully specified argument list, return 
 type, and expression (rule). 
 @Param name The name of the function to build and register. If the expression
 is already registered, an error is returned and no new function is built.
 @Param argumentList The named arguments that the function requires as inputs. 
 @Param returnType The type of value that the function returns.
 @Param expression The algebraic rule used to compute the function's value from
 the inputs. If the expression is not already registered with the mathSheet it
 will be registered during the construction process. The rule can use any 
 argument from the argument list, and any other constant or variable already 
 explicitly registered with the mathSheet or implicitly, as part of the expression
 rule.
 @Param error Error will only be populated if the construction of the function 
 fails. The reasons for failure are: (1) A function of the required name already
 exists; (2) The name is invalid.
 @Return The value of the function as computed using the expression rule, using 
 values currently explicitly assigned in the argument list and other constants 
 and variable values from the mathSheet.
 */
-(KSMFunction*)buildAndRegisterUserFunctionWithName:(NSString*)name
                                       argumentList:(KSMFunctionArgumentList*)arguments
                                         returnType:(KSMValueType)type
                                         expression:(KSMExpression*)expression
                                              error:(NSError**)error;

@end
