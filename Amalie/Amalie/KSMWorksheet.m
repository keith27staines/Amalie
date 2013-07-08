//
//  KSMWorksheet.m
//  KSMath
//
//  Created by Keith Staines on 26/06/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMWorksheet.h"
#import "KSMExpressionBuilder.h"
#import "KSMExpressionEvaluator.h"
#import "KSMExpression.h"

@interface KSMWorksheet()
{
    KSMExpressionBuilder * _expressionBuilder;
    KSMExpressionEvaluator * _expressionEvaluator;
}

@property (strong, readwrite) KSMExpressionBuilder * builder;
@property (strong, readwrite) KSMExpressionEvaluator * evaluator;


@end

@implementation KSMWorksheet

- (id)init
{
    self = [super init];
    if (self) {
        _title = @"Untitled";
        _expressionsDictionary = [NSMutableDictionary dictionary];
        _variablesDictionary = [NSMutableDictionary dictionary];
        _builder = [[KSMExpressionBuilder alloc] initWithWorksheet:self];
        _evaluator = [[KSMExpressionEvaluator alloc] initWithWorksheet:self];
    }
    return self;
}

-(NSString*)registerExpression:(KSMExpression*)expression
{
    if (!expression) return nil;
    
    // Already registered?
    NSString * symbol = expression.symbol;
    if ( [self.expressionsDictionary objectForKey:symbol]) {
        // Already in dictionary so nothing to do
        return symbol;
    }
    
    // register the top level expression
    [self.expressionsDictionary setObject:expression forKey:symbol];
    if (expression.expressionType == KSMExpressionTypeVariable) {
        if (![self.variablesDictionary objectForKey:symbol]) {
            // add the variable identified by symbol and give it the value 0
            [self.variablesDictionary setObject:@(0) forKey:symbol];
        }
    }
    
    // register its subexpressions
    for (NSString * subsymbol in expression.subExpressions) {
        KSMExpression * subExpression = expression.subExpressions[subsymbol];
        [self registerExpression:subExpression];
        if (subExpression.expressionType == KSMExpressionTypeVariable) {
            if (![self.variablesDictionary objectForKey:subsymbol]) {
                // add the variable identified by symbol and give it the value 0
                [self.variablesDictionary setObject:@(0) forKey:subsymbol];
            }
        }
    }
    return symbol;
}

-(NSString*)buildAndRegisterExpressionFromString:(NSString*)string
{
    KSMExpression * expression = [self.builder buildExpressionFromString:string];
    return [self registerExpression:expression];
}

-(KSMExpression*)simplifiedExpressionFromExpression:(KSMExpression*)expression
{
    KSMExpression * simplifiedExpression = [self.evaluator simplifiedExpressionFromExpression:expression];
    [self registerExpression:simplifiedExpression];
    return simplifiedExpression;
}

-(BOOL)isExpressionWithSymbolRegistered:(NSString*)symbol;
{
    return ( [self.expressionsDictionary objectForKey:symbol] ) ? YES : NO;
}

-(KSMExpression*)expressionForKey:(NSString*)symbol;
{
    return [self.expressionsDictionary objectForKey:symbol];
}

-(KSMExpression*)expressionForSymbol:(NSString*)symbol
{
    return [self expressionForKey:symbol];
}

-(KSMExpression*)expressionForOriginalString:(NSString*)string
{
    for (NSString * symbol in self.expressionsDictionary) {
        KSMExpression * expression = [self.expressionsDictionary objectForKey:symbol];
        if ([expression.originalString isEqualToString:string])
            return expression;
    }
    return nil;
}

-(KSMExpression*)expressionForString:(NSString*)string
{
    for (NSString * symbol in self.expressionsDictionary) {
        KSMExpression * expression = [self.expressionsDictionary objectForKey:symbol];
        if ( [expression.string isEqualToString:string] )
            return expression;
    }
    return nil;
}

-(NSNumber*)variableForSymbol:(NSString*)symbol
{
    return self.variablesDictionary[symbol];
}

-(void)setValue:(NSNumber*)number forVariableWithSymbol:(NSString*)symbol
{
    self.variablesDictionary[symbol] = number;
}

@end
