//
//  AMDIndexedExpression+Methods.h
//  Amalie
//
//  Created by Keith Staines on 07/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMDIndexedExpression.h"

@interface AMDIndexedExpression (Methods)

+(AMDIndexedExpression*)makeIndexedExpression;

+(AMDIndexedExpression*)makeIndexedExpressionWithIndex:(NSUInteger)index;

+(AMDIndexedExpression*)makeIndexedExpressionWithIndex:(NSUInteger)index expression:(AMDExpression*)expression;

@end
