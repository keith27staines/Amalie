//
//  AMInsertableRecord.m
//  Amalie
//
//  Created by Keith Staines on 23/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMInsertableRecord.h"
#import "KSMWorksheet.h"
#import "KSMExpression.h"

@interface AMInsertableRecord()
{
    NSMutableArray * _expressions;
}

@property (readonly) NSMutableArray * expressions;

@end

@implementation AMInsertableRecord


- (id)init
{
    [NSException raise:@"Use the designated initializer." format:nil];
    return nil;
}

- (id)initWithName:(NSString*)name
              uuid:(NSString *)uuid
              type:(AMInsertableType)type
         mathSheet:(KSMWorksheet *)sheet
{
    self = [super init];
    if (self) {
        _name = name;
        _uuid = uuid;
        _type = type;
        _worksheet = sheet;
        NSString * symbol = [_worksheet buildAndRegisterExpressionFromString:@"x"];
        _expressions = [NSMutableArray array];
        KSMExpression * e = [_worksheet expressionForSymbol:symbol];
        _expressions[0] = e;
    }
    return self;
}

-(NSMutableArray*)expressions
{
    return _expressions;
}

-(NSUInteger)expressionCount
{
    return [self.expressions count];
}

-(KSMExpression*)expressionForIndex:(NSUInteger)index
{
    return self.expressions[index];
}

-(BOOL)setExpression:(KSMExpression*)expr forIndex:(NSUInteger)index
{
    if (index < self.expressionCount) {
        self.expressions[index] = expr;
        return YES;
    }
    return NO;
}

-(KSMExpression*)expressionFromString:(NSString *)string atIndex:(NSUInteger)index
{
    if (index < self.expressionCount) {
        
        // Remove the expression that already exists at the specified index
        KSMExpression * oldExpr = [self expressionForIndex:index];
        if (oldExpr) {
            [self.worksheet decrementReferenceCountForExpression:oldExpr];
        }
        
        NSString * symbol = [self.worksheet buildAndRegisterExpressionFromString:string];
        KSMExpression * newExpr = [self.worksheet expressionForSymbol:symbol];
        
        if ( ! [self setExpression:newExpr forIndex:index] ) {
            [self.worksheet decrementReferenceCountForExpression:newExpr];
            return nil;
        }
        return newExpr;
    }
    return nil;
}

- (void)dealloc
{
    for (KSMExpression * expr in self.expressions) {
        [self.worksheet decrementReferenceCountForExpression:expr];
    }
    _expressions = nil;
}
@end
