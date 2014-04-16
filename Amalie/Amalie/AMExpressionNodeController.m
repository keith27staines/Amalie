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
#import "AMWorksheetNameProvider.h"

@interface AMExpressionNodeController() <AMExpressionNodeViewDelegate,AMExpressionNodeViewDatasource>
{
    KSMWorksheet * _worksheet;
    KSMExpression * _expression;
    AMExpressionNodeView * _expressionNode;
}
@property (readonly) KSMExpression * expression;
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
    return [AMWorksheetNameProvider nameProviderWithDelegate:self.nameProviderDelegate worksheet:self.worksheet];
}
#pragma mark - AMExpressionNodeViewDatasource -
-(KSMExpression *)view:(NSView *)view requiresExpressionForSymbol:(NSString *)symbol
{
    return [self.worksheet expressionForSymbol:symbol];
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
                                                           dataSource:self
                                                       displayOptions:nil
                                                          scaleFactor:1
                                                          contextNode:nil];
    }
    return _expressionNode;
}
-(void)setExpressionNode:(AMExpressionNodeView *)expressionNode
{
    _expressionNode = expressionNode;
    expressionNode.delegate   = self;
    expressionNode.dataSource = self;
}

-(KSMExpression*)expression
{
    if (!_expression) {
        NSString * symbol = [self.worksheet buildAndRegisterExpressionFromString:@"2*x"];
        _expression = [self.worksheet expressionForSymbol:symbol];
    }
    return _expression;
}
-(KSMWorksheet *)worksheet
{
    if (!_worksheet) {
        _worksheet = [[KSMWorksheet alloc] init];
    }
    return _worksheet;
}

@end
