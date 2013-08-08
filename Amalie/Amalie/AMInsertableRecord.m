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
#import "AMNameRules.h"

@interface AMInsertableRecord()
{
    NSMutableArray * _expressions;
}

@property (readonly) NSMutableArray * expressions;
@property (readonly) AMNameRules * nameRules;

@end

@implementation AMInsertableRecord


- (id)init
{
    [NSException raise:@"Use the designated initializer." format:nil];
    return nil;
}

- (id)initWithName:(NSAttributedString*)attributedName
         nameRules:(AMNameRules*)nameRules
              uuid:(NSString *)uuid
              type:(AMInsertableType)type
         mathSheet:(KSMWorksheet *)sheet
{
    self = [super init];
    if (self) {
        _attributedName = attributedName;
        if (!_attributedName) {
            _attributedName = [nameRules suggestNameForType:type];
        }
        _uuid = uuid;
        _type = type;
        _worksheet = sheet;
    
        [self setupExpressionArrayForType:type];
    }
    return self;
}

-(void)setupExpressionArrayForType:(AMInsertableType)type
{
    _expressions = [NSMutableArray array];
    NSUInteger expressions = 0;
    switch (type) {
        case AMInsertableTypeEquation:
            expressions = 1;
            break;
            
        default:
            expressions = 0;
            break;
    }
    
    NSString * symbol = [_worksheet buildAndRegisterExpressionFromString:@"x"];
    KSMExpression * expr = [_worksheet expressionForSymbol:symbol];
    for (NSUInteger i = 0; i < expressions; i++) {
        _expressions[i] = expr;
    }
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

-(BOOL)changeAttributedNameIfValid:(NSAttributedString*)proposedName
                             error:(NSError**)error
{
    BOOL isValid = [self.nameRules checkName:proposedName
                                 forType:self.type
                                   error:error];

    if (isValid) self.attributedName = proposedName;
    return isValid;
}

- (void)dealloc
{
    for (KSMExpression * expr in self.expressions) {
        [self.worksheet decrementReferenceCountForExpression:expr];
    }
    _expressions = nil;
}
@end
