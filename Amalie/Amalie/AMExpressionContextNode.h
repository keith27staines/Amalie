//
//  AMExpressionContextNode.h
//  Amalie
//
//  Created by Keith Staines on 27/01/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class KSMExpression;

#import <Foundation/Foundation.h>
#import "KSMConstants.h"
#import "AMExpressionDataSource.h"

/*! This class is intended to assist in the display of expression nodes. It algorithmically determines display options that cannot be determined directly from the expression node itself. Examples include whether an expression node requires brackets, or whether the operator in a binary expression is required. These properties depend not just on the expression node, but on the context in which the node appears. Brackets may or may not be required depending on the relative precedence of neighbouring operators, etc.
 */
@interface AMExpressionContextNode : NSObject

- (id)initWithExpression:(KSMExpression *)expression
                  parent:(AMExpressionContextNode*)parent
              asLeftNode:(BOOL)asLeftNode
             asRightNode:(BOOL)asRightNode
              dataSource:(id<AMExpressionDataSource>)dataSource
   hideRedundantBrackets:(BOOL)hideRedundantBrackets
    cascadeBracketHiding:(BOOL)cascadeRedundantBracketHiding;

/*! Properties this class is intended to derive algorithmically from the expression */
@property (readonly) BOOL requiresBrackets;
@property (readonly) BOOL requiresOperator;
-(NSString*)reconstructExpressionString;

/*! These properties may provide convenience, but they are also easily obtainable by interrogating the expression node iteself */
@property (weak,readonly) KSMExpression * expression;
@property (readonly) BOOL isUnary;
@property (readonly) BOOL isBinary;
@property (readonly) BOOL isLeftNode;
@property (readonly) BOOL isRightNode;
@property (readonly) NSString * operatorString;
@property (readonly) KSMOperatorType operatorType;
@property (weak,readonly) AMExpressionContextNode * parent;
@property (readonly) AMExpressionContextNode * leftChild;
@property (readonly) AMExpressionContextNode * rightChild;
@property BOOL hideRedundantBrackets;
@property BOOL cascadeRedundantBracketHiding;
@end
