//
//  KSMExpressionBuilder.h
//  KSMath
//
//  Created by Keith Staines on 26/06/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * A factory class for building expressions and registering them in a dictionary.
 */
@class KSMExpression;
@class KSMWorksheet;

@interface KSMExpressionBuilder : NSObject

@property (weak) KSMWorksheet * worksheet;

/*!
 * This initializer will always throw an exception. Use the designated 
 * initializer instead.
 * @Returns Never returns, always throws an exception.
 */
- (id)init;

/*!
 * Designated initializer.
 * Initialises a KSMExpressionBuilder with its parent worksheet. The expression 
 * builder will use backing stores provided by the worksheet (to register the
 * expressions and variables it builds).
 * @Param worksheet The parent worksheet (must not be nil or an exception will 
 * be thrown). The worksheet is referenced by a weak pointer.
 * @Return An initialized object
 */
- (id)initWithWorksheet:(KSMWorksheet*)worksheet;

/*!
 * Builds a KSMExpression from the supplied string and registers the string in 
 * the parent worksheet's store.
 * @Param string The string to build into an expression.
 * @Returns The symbol now associated with the expression in the parent 
 * worksheet's store.
 */
-(KSMExpression*)buildExpressionFromString:(NSString*)string;


@end
