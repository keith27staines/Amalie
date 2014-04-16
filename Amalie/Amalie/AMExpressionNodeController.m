//
//  AMExpressionNodeController.m
//  Amalie
//
//  Created by Keith Staines on 15/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//



#import "AMExpressionNodeController.h"
#import "KSMExpression.h"
#import "KSMWorksheet.h"
#import "AMExpressionNodeView.h"
#import "AMNameProviderBase.h"

@interface AMExpressionNodeController() <AMExpressionNodeViewDelegate>
{
    KSMExpression * _expression;
    AMExpressionNodeView * _expressionNode;
}
@property KSMExpression * expression;
@end

@implementation AMExpressionNodeController

-(void)awakeFromNib
{
    self.expressionNode.expression = self.expression;
    [self.expressionNode setNeedsDisplay:YES];
}

#pragma mark - AMExpressionNodeViewDelegate -
-(id<AMNameProviding>)nameProvider
{
    return [AMNameProviderBase nameProviderWithDelegate:self.nameProviderDelegate];
}

#pragma mark - AMExpressionNodeController -
-(AMExpressionNodeView*)expressionNode
{
    if (!_expressionNode) {
        _expressionNode = [[AMExpressionNodeView alloc] initWithFrame:NSZeroRect
                                                              groupID:@""
                                                           expression:self.expression
                                                       scriptingLevel:0
                                                             delegate:self
                                                           dataSource:nil
                                                       displayOptions:nil
                                                          scaleFactor:1
                                                          contextNode:nil];
    }
    return _expressionNode;
}
-(void)setExpressionNode:(AMExpressionNodeView *)expressionNode
{
    _expressionNode = expressionNode;
    expressionNode.delegate = self;
}

-(KSMExpression*)expression
{
    if (!_expression) {
        _expression = [[KSMExpression alloc] initWithString:@"2*x"];
    }
    return _expression;
}
-(void)setExpression:(KSMExpression *)expression
{
    _expression = expression;
//    [self.expressionNode setExpression:self.expression];
//    [self.expressionNode setNeedsDisplay:YES];
}

@end
