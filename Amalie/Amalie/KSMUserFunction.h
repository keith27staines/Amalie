//
//  KSMUserFunction.h
//  Amalie
//
//  Created by Keith Staines on 30/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMFunction.h"

@interface KSMUserFunction : KSMFunction
@property (weak, readonly) KSMExpression * expression;
@property (weak, readonly) KSMMathSheet  * mathSheet;

/*!
 The designated initializer.
 @Param name The name of the function.
 @Param argumentList A KSMArgumentList defining the names and values of the function's inputs.
 @Param returnType The type of result that the function will return.
 @Param expression The expression that defines the function's rule.
 @Param mathSheet The parent mathSheet that hosts the function.
 @Return The initialized object.
 */
-(id)initWithName:(NSString*)name
     argumentList:(KSMFunctionArgumentList *)argumentList
       returnType:(KSMValueType)returnType
       expression:(KSMExpression*)expression
        mathSheet:(KSMMathSheet *)mathSheet;

@end
