//
//  AMExpressionContextNode.m
//  Amalie
//
//  Created by Keith Staines on 27/01/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMExpressionContextNode.h"
#import "KSMExpression.h"

@interface AMExpressionContextNode()
{
    __weak AMExpressionContextNode * _parent;
    AMExpressionContextNode * _leftChild;
    AMExpressionContextNode * _rightChild;
    BOOL _hideRedundantBrackets;
    BOOL _cascadeRedundantBracketHiding;
    BOOL _isLeftNode;
    BOOL _isRightNode;
    BOOL _requiresBrackets;
    NSString * _reconstructedString;
}
@property (readonly) id<AMExpressionDataSource>dataSource;
@property BOOL bracketStatusDetermined;
@end

@implementation AMExpressionContextNode

- (id)initWithExpression:(KSMExpression *)expression
                  parent:(AMExpressionContextNode*)parent
              asLeftNode:(BOOL)asLeftNode
             asRightNode:(BOOL)asRightNode
              dataSource:(id<AMExpressionDataSource>)dataSource
   hideRedundantBrackets:(BOOL)hideRedundantBrackets
    cascadeBracketHiding:(BOOL)cascadeRedundantBracketHiding
{
    self = [super init];
    _dataSource = dataSource;
    if (self) {
        _expression = expression;
        _parent = parent;
        _isLeftNode = asLeftNode;
        _isRightNode = asRightNode;
        _hideRedundantBrackets = hideRedundantBrackets;
        _cascadeRedundantBracketHiding = cascadeRedundantBracketHiding;
        _bracketStatusDetermined = NO;
        if (self.isBinary) {
            BOOL hideChildBrackets = NO;
            if (cascadeRedundantBracketHiding && hideRedundantBrackets) {
                hideChildBrackets = YES;
            }
            _leftChild = [[AMExpressionContextNode alloc] initWithExpression:[self expressionForSymbol:expression.leftOperand] parent:self asLeftNode:YES asRightNode:NO dataSource:self.dataSource hideRedundantBrackets:hideChildBrackets cascadeBracketHiding:cascadeRedundantBracketHiding];
            _rightChild = [[AMExpressionContextNode alloc] initWithExpression:[self expressionForSymbol:expression.rightOperand] parent:self asLeftNode:NO asRightNode:YES dataSource:self.dataSource hideRedundantBrackets:hideChildBrackets cascadeBracketHiding:cascadeRedundantBracketHiding];
        }
        [self reconstructedString];
    }
    return self;
}

-(BOOL)hideRedundantBrackets
{
    return _hideRedundantBrackets;
}
-(void)setHideRedundantBrackets:(BOOL)hideRedundantBrackets
{
    _hideRedundantBrackets = hideRedundantBrackets;
    if (self.cascadeRedundantBracketHiding) {
        self.leftChild.cascadeRedundantBracketHiding = YES;
        self.leftChild.hideRedundantBrackets = hideRedundantBrackets;
        self.rightChild.cascadeRedundantBracketHiding = YES;
        self.rightChild.hideRedundantBrackets = hideRedundantBrackets;
    }
}
-(BOOL)isUnary
{
    return self.expression.isUnary;
}
-(BOOL)isBinary
{
    return !self.isUnary;
}
-(KSMOperatorType)operatorType
{
    return [KSMExpression operatorTypeFromString:self.operatorString];
}
-(NSString*)operatorString
{
    return self.expression.operator;
}
-(KSMExpression*)expressionForSymbol:(NSString*)symbol
{
    KSMExpression * expr;
    expr = [_dataSource expressionForSymbol:symbol];
    
    NSAssert(expr, @"No expression known for symbol %@.",symbol);
    
    return expr;
}

-(NSString*)reconstructedString
{
    if (_reconstructedString) {
        return _reconstructedString;
    }
    NSString * r;
    if (self.expression.isUnary) {
        r = self.expression.bareString;
    } else {
        NSString * left = [self.leftChild reconstructedString];
        NSString * right = [self.rightChild reconstructedString];
        if ([self.expression hasAddedLogicalLeadingZero]) {
            r = [NSString stringWithFormat:@"%@%@",self.operatorString,right];
        } else {
            r = [NSString stringWithFormat:@"%@%@%@",left,self.operatorString,right];
        }
    }
    if (self.expression.isBracketed) {
        r = [NSString stringWithFormat:@"(%@)",r];
    }
    _reconstructedString = r;
    return _reconstructedString;
}

-(BOOL)requiresBrackets
{
    if (self.bracketStatusDetermined) {
        return _requiresBrackets;
    }
    self.bracketStatusDetermined = YES;
    
    if (!self.expression.isBracketed) {
        // No requirement for bracket at all
        _requiresBrackets = NO;
        return NO;
    }
    
    // From here on, the expression is known to be marked as bracketed but the brackets may be redundant.
    
    if (!self.hideRedundantBrackets) {
        // Expression is marked as bracketed and we aren't asked to hide redundant brackets
        _requiresBrackets = YES;
        return YES;
    }
    
    // From here on, the expression is marked as bracketed and we are asked to hide redundant brackets, so the job now is to determine redundancy...
    
    if (self.expression.isUnary) {
        // Brackets round a unary expression are always redundant
        _requiresBrackets = NO;
        return NO;
    }
    
    // Top-level expressions never require brackets
    if (!self.parent) {
        _requiresBrackets = NO;
        return NO;
    }
    
    // From here on, we are dealing with various levels of binary sub-expressions
    if ([self.operatorString isEqualTo:@"+"]) {
        NSLog(@"Follow this");
    }
    if ( [self isMyOperatorLowerPrecedenceThanNeighbours] ) {
        _requiresBrackets = YES;
        return YES; // Precedence of neighbouring operators makes my brackets essential
    } else {
        _requiresBrackets = NO;
        return NO; // Precedence of neighbouring operators makes my brackets redundant
    }
    _requiresBrackets = YES;
    NSAssert(NO, @"BAD LOGIC");
    return YES;
}

-(NSInteger)precedenceForOperatorType:(KSMOperatorType)opType
{
    switch (opType) {
        case KSMOperatorTypeAdd:return 0;
        case KSMOperatorTypeSubtract:return 0;
        case KSMOperatorTypeMultiply:return 1;
        case KSMOperatorTypeDivide:return 1;
        case KSMOperatorTypePower:return 0;
        case KSMOperatorTypeScalarMultiply:return 2;
        case KSMOperatorTypeVectorMultiply:return 3;
        case KSMOperatorTypeUnrecognized:return NSIntegerMax;
    }
}

/*! Returns the node that encloses the current node from the left - i.e, such that the current node is the right node of a binary */
-(AMExpressionContextNode*)leftEnclosing
{
    if (!self.parent) {
        return nil;
    }
    if (self.isRightNode) {
        return self.parent;
    }
    return [self.parent leftEnclosing];
}
/*! Returns the node that encloses the current node from the right - i.e, such that the current node is the left node of a binary */
-(AMExpressionContextNode*)rightEnclosing
{
    if (!self.parent) {
        return nil;
    }
    if (self.isLeftNode) {
        return self.parent;
    }
    return [self.parent rightEnclosing];
}
-(KSMOperatorType)leftOperatorType
{
    AMExpressionContextNode * leftEnclosing = [self leftEnclosing];
    if (leftEnclosing) {
        return [leftEnclosing operatorType];
    } else {
        return KSMOperatorTypeUnrecognized;
    }
}
-(KSMOperatorType)rightOperatorType
{
    AMExpressionContextNode * rightEnclosing = [self rightEnclosing];
    if (rightEnclosing) {
        return [rightEnclosing operatorType];
    } else {
        return KSMOperatorTypeUnrecognized;
    }
}
/*! Assumes the current node is binary */
-(BOOL)isMyOperatorLowerPrecedenceThanNeighbours
{
    NSInteger myPrecedence = [self operatorPrecedenceForNode:self];
    NSInteger leftPrecedence = [self operatorPrecedenceForNode:[self leftEnclosing]];
    NSInteger rightPrecedence = [self operatorPrecedenceForNode:[self rightEnclosing]];
    return (myPrecedence < leftPrecedence || myPrecedence < rightPrecedence);
}

-(NSInteger)operatorPrecedenceForNode:(AMExpressionContextNode*)node
{
    if (node) {
        return [self precedenceForOperatorType:node.operatorType];
    } else {
        return [self precedenceForOperatorType:KSMOperatorTypeUnrecognized];
    }
}

-(BOOL)requiresOperator
{
    if (self.isUnary) {
        return NO;
    }
    switch (self.operatorType) {
        case KSMOperatorTypeAdd:            return YES;
        case KSMOperatorTypeSubtract:       return YES;
        case KSMOperatorTypeMultiply:
        {
            if (self.leftChild.expression.expressionType == KSMExpressionTypeLiteral &&
                self.rightChild.expression.expressionType == KSMExpressionTypeLiteral) {
                // For example, 2 x 3 can't be written 2.3 or 23
                return YES;
            }
            if (self.rightChild.expression.expressionType == KSMExpressionTypeLiteral) {
                // For example, 2pi*3, not 2pi3
                return YES;
            }
            // For example in, 2*x = 2x, x*y = xy, etc, the multiply sign can be omitted
            return NO;
        }
        case KSMOperatorTypeDivide:         return YES;
        case KSMOperatorTypeVectorMultiply: return YES;
        case KSMOperatorTypeScalarMultiply: return YES;
        case KSMOperatorTypePower:          return NO;
        case KSMOperatorTypeUnrecognized:   return YES;
    }
}

@end
