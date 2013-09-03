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
#import "KSMFunction.h"
#import "KSMUserFunction.h"
#import "KSMStandardFunction1v.h"

@interface KSMWorksheet()
{
    KSMExpressionBuilder   * _expressionBuilder;
    KSMExpressionEvaluator * _expressionEvaluator;
    NSMutableDictionary    * _referenceCountedObjects;
}

@property (strong, readwrite) KSMExpressionBuilder * builder;
@property (strong, readwrite) KSMExpressionEvaluator * evaluator;
@property (strong, readonly) NSMutableDictionary * referenceCountedObjects;

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
        _functionsDictionary = [NSMutableDictionary dictionary];
        _builder = [[KSMExpressionBuilder alloc] initWithWorksheet:self];
        _evaluator = [[KSMExpressionEvaluator alloc] initWithWorksheet:self];
        [self registerStandardFunctions];
    }
    return self;
}

-(void)registerStandardFunctions
{
    NSArray * standardFunctions = [KSMStandardFunction1v standardFunctionsArray];
    for (KSMFunction * f in standardFunctions) {
        [self registerFunction:f];
    }
}

-(NSString*)registerExpression:(KSMExpression*)expression
{
    if (!expression) return nil;

    NSString * symbol = expression.symbol;
    KSMReferenceCounter * refCounter;
    
    if ( ! [self isObjectRegistered:expression]) {
        
        // register the top level expression
        refCounter = [[KSMReferenceCounter alloc] initWithUUID:symbol];
        self.referenceCountedObjects[symbol] = refCounter;
        self.expressionsDictionary[symbol] = expression;
        
        if (expression.expressionType == KSMExpressionTypeVariable) {
            if (![self.variablesDictionary objectForKey:symbol]) {
                // add the variable identified by symbol and give it the value 0
                self.variablesDictionary[symbol] = @(0);
            }
        }
        
        // register its subexpressions
        for (NSString * aSymbol in expression.subExpressions) {
            KSMExpression * subExpression = expression.subExpressions[aSymbol];
            [self registerExpression:subExpression];
        }
        
    }
        
    // Expression already registered (even if it wasn't before), so just increment the reference count
    refCounter = self.referenceCountedObjects[symbol];
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

-(NSNumber*)variableForSymbol:(NSString*)symbol
{
    return self.variablesDictionary[symbol];
}

-(KSMFunction*)functionForSymbol:(NSString*)symbol
{
    return self.functionsDictionary[symbol];
}

-(void)setValue:(NSNumber*)number forVariableWithSymbol:(NSString*)symbol
{
    self.variablesDictionary[symbol] = number;
}

-(void)decrementReferenceCountForObject:(id<KSMReferenceCountedObject>)object
{
    KSMReferenceCounter * ref = self.referenceCountedObjects[object.symbol];
    [ref decrement];
}

#pragma mark - KSMReferenceCounterDelegate -
-(void)referenceCountReachedZero:(KSMReferenceCounter *)refCounter
{
    [_expressionsDictionary     removeObjectForKey:refCounter.uuid];
    [_variablesDictionary       removeObjectForKey:refCounter.uuid];
    [_functionsDictionary       removeObjectForKey:refCounter.uuid];
    [_referenceCountedObjects   removeObjectForKey:refCounter.uuid];
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
        ref = [[KSMReferenceCounter alloc] initWithUUID:symbol];
        self.referenceCountedObjects[symbol] = ref;
        self.functionsDictionary[symbol] = function;
    }
        
    ref = self.referenceCountedObjects[symbol];
    [ref increment];
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
