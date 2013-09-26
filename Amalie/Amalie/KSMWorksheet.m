//
//  KSMWorksheet.m
//  KSMath
//
//  Created by Keith Staines on 26/06/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMWorksheet.h"
#import "KSMExpressionEvaluator.h"
#import "KSMMathValue.h"
#import "KSMMathValueHolder.h"
#import "KSMExpression.h"
#import "KSMFunction.h"
#import "KSMUserFunction.h"
#import "KSMStandardFunction1v.h"

@interface KSMWorksheet()
{
    KSMExpressionEvaluator * _expressionEvaluator;
    NSMutableDictionary    * _referenceCountedObjects;
}

@property (strong, readonly) NSMutableDictionary     * variablesDictionary;
@property (strong, readwrite) KSMExpressionEvaluator * evaluator;
@property (strong, readonly) NSMutableDictionary     * referenceCountedObjects;

@end

@implementation KSMWorksheet

- (id)init
{
    self = [super init];
    if (self) {
        _referenceCountedObjects = [NSMutableDictionary dictionary];
        _expressionsDictionary = [NSMutableDictionary dictionary];
        _variablesDictionary = [NSMutableDictionary dictionary];
        _functionsDictionary = [NSMutableDictionary dictionary];
        _evaluator = [[KSMExpressionEvaluator alloc] initWithWorksheet:self];
    }
    return self;
}

-(NSString*)registerExpression:(KSMExpression*)expression
{
    if (!expression) return nil;

    NSString * symbol = expression.symbol;
    KSMReferenceCounter * refCounter;
    
    if ( ! [self isObjectRegistered:expression]) {
        
        // register the top level expression
        
        // create a reference counter for the expression (after initialization, the reference counter will then have a reference count of 1).
        refCounter = [KSMReferenceCounter referenceCounterForObject:expression delegate:self];
        
        self.referenceCountedObjects[symbol] = refCounter;
        self.expressionsDictionary[symbol] = expression;
        
        if (expression.expressionType == KSMExpressionTypeVariable) {
            if (![self.variablesDictionary objectForKey:symbol]) {
                // add the variable identified by symbol and give it default value
                KSMMathValueHolder * holder = [[KSMMathValueHolder alloc] initWithName:expression.bareString symbol:expression.symbol];
                self.variablesDictionary[symbol] = holder;
            }
        }
        
        // register its subexpressions
        for (NSString * aSymbol in expression.subExpressions) {
            KSMExpression * subExpression = expression.subExpressions[aSymbol];
            [self registerExpression:subExpression];
        }
        
    } else {
        
        // Expression was already registered so just increment the reference count
        refCounter = self.referenceCountedObjects[symbol];
        [refCounter increment];
    }
    
    return symbol;
}


-(NSString*)buildAndRegisterExpressionFromString:(NSString*)string
{
    KSMExpression * expression = [[KSMExpression alloc] initWithString:string];
    return [self registerExpression:expression];
}

-(KSMExpression*)simplifiedExpressionFromExpression:(KSMExpression*)expression
{
    KSMExpression * simplifiedExpression = [self.evaluator simplifiedExpressionFromExpression:expression];
    [self registerExpression:simplifiedExpression];
    return simplifiedExpression;
}

-(BOOL)isObjectRegistered:(id<KSMReferenceCountedObject>)object
{
    return ( self.referenceCountedObjects[object.symbol] ) ? YES : NO;
}

-(KSMExpression*)expressionForKey:(NSString*)symbol;
{
    KSMExpression * expr = self.expressionsDictionary[symbol];
    if (!expr) {
        NSLog(@"Failed to locate expression for key %@",symbol);
    }
    return expr;
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


-(KSMExpression*)expressionForSymbol:(NSString*)symbol
{
    KSMExpression * expr = [self expressionForKey:symbol];
    if (!expr) {
        NSLog(@"Failed to locate expression for key %@",symbol);
    }
    return expr;
}

-(KSMMathValue*)variableForSymbol:(NSString*)symbol
{
    KSMMathValueHolder * holder = self.variablesDictionary[symbol];
    return holder.mathValue;
}

-(KSMMathValue*)variableForName:(NSString*)name
{
    for (NSString * symbol in self.variablesDictionary) {
        KSMMathValueHolder * holder = self.variablesDictionary[symbol];
        if ([holder.name isEqualToString:name]) {
            return holder.mathValue;
        }
    }
    return nil;
}

-(KSMFunction*)functionForSymbol:(NSString*)symbol
{
    return self.functionsDictionary[symbol];
}

-(void)setValue:(KSMMathValue*)mathValue forVariableWithSymbol:(NSString*)symbol
{
    KSMMathValueHolder * holder = self.variablesDictionary[symbol];
    holder.mathValue = mathValue;
}

-(void)decrementReferenceCountForObject:(id<KSMReferenceCountedObject>)object
{
    KSMReferenceCounter * ref = self.referenceCountedObjects[object.symbol];
    [ref decrement];
}

#pragma mark - KSMReferenceCounterDelegate -
-(void)referenceCountReachedZero:(KSMReferenceCounter *)refCounter
{
    [_expressionsDictionary     removeObjectForKey:refCounter.symbol];
    [_variablesDictionary       removeObjectForKey:refCounter.symbol];
    [_functionsDictionary       removeObjectForKey:refCounter.symbol];
    [_referenceCountedObjects   removeObjectForKey:refCounter.symbol];
}


#pragma mark - Functions -

-(KSMFunction*)buildAndRegisterUserFunctionWithName:(NSString*)name
                                           argumentList:(KSMFunctionArgumentList*)arguments
                                             returnType:(KSMValueType)type
                                             expression:(KSMExpression*)expression
                                                  error:(NSError**)error
{
    KSMFunction * f = _functionsDictionary[name];
    if (f)
    {
        NSLog(@"Error - a function with the specified name already exists and will continue to be used.");
        return nil;
    }
    
    f = [[KSMUserFunction alloc] initWithName:name
                             argumentList:arguments
                               returnType:type
                               expression:expression
                                worksheet:self];
    [self registerFunction:f];
    
    return f;
}

-(NSString*)registerFunction:(KSMFunction*)function
{
    NSString * symbol = function.symbol;
    KSMReferenceCounter * ref;
    
    if (!self.referenceCountedObjects[symbol]) {
        ref = [[KSMReferenceCounter alloc] initWithObject:function delegate:self];
        self.referenceCountedObjects[symbol] = ref;
        self.functionsDictionary[symbol] = function;
    } else {
        ref = self.referenceCountedObjects[symbol];
        [ref increment];        
    }
        
    return symbol;
}

-(KSMFunction*)functionForName:(NSString*)name
{
    for (NSString *symbol in self.functionsDictionary) {
        KSMFunction * f = self.functionsDictionary[symbol];
        if ([f.name isEqualToString:name]) {
            return f;
        }
    }
    return nil;
}

@end
