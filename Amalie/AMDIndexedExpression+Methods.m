//
//  AMDIndexedExpression+Methods.m
//  Amalie
//
//  Created by Keith Staines on 07/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMDIndexedExpression+Methods.h"
#import "AMDExpression+Methods.h"
#import "NSManagedObject+SharedDataStore.h"
#import "NSString+KSMMath.h"
#import "KSMExpression.h"
#import "AMDataStore.h"

static NSString * const kAMDENTITYNAME = @"AMDIndexedExpressions";

@implementation AMDIndexedExpression (Methods)

+(AMDIndexedExpression*)makeIndexedExpression
{
    return [self makeIndexedExpressionWithIndex:0];
}

+(AMDIndexedExpression*)makeIndexedExpressionWithIndex:(NSUInteger)index
{
    AMDIndexedExpression * iexpr = [NSEntityDescription insertNewObjectForEntityForName:kAMDENTITYNAME inManagedObjectContext:self.moc];
    iexpr.index = @(index);
    iexpr.expression = [AMDExpression makeExpression];
    return iexpr;
}


+(AMDIndexedExpression*)makeIndexedExpressionWithIndex:(NSUInteger)index expression:(AMDExpression*)expression
{
    AMDIndexedExpression * iexpr = [self makeIndexedExpressionWithIndex:index];
    iexpr.expression = expression;
    return iexpr;
}
@end
