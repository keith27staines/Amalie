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
    KSMExpressionBuilder   * _expressionBuilder;
    KSMExpressionEvaluator * _expressionEvaluator;
    NSMutableDictionary * _referenceCountedObjects;
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
        _referenceCountedObjects = [NSMutableDictionary dictionary];
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

    NSString * symbol = expression.symbol;
    KSMReferenceCounter * refCounter;
    
    if ( ! [self isExpressionWithSymbolRegistered:symbol]) {
        // register the top level expression
        refCounter = [[KSMReferenceCounter alloc] initWithUUID:symbol];
        [_referenceCountedObjects setObject:refCounter forKey:symbol];
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
        }
        
    }
        
    // Expression already registered (even if it wasn't before), so just increment the reference count
    refCounter = [_referenceCountedObjects objectForKey:expression.symbol];
    [refCounter increment];
    
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

-(void)decrementReferenceCountForExpression:(KSMExpression*)expression
{
    KSMReferenceCounter * ref = [_referenceCountedObjects objectForKey:expression.symbol];
    [ref decrement];
}

#pragma mark - KSMReferenceCounterDelegate -
-(void)referenceCountReachedZero:(KSMReferenceCounter *)refCounter
{
    [_expressionsDictionary     removeObjectForKey:refCounter.uuid];
    [_variablesDictionary       removeObjectForKey:refCounter.uuid];
    [_referenceCountedObjects   removeObjectForKey:refCounter.uuid];
}



@end
