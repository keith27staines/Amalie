//
//  AMExpressionNodeController.m
//  Amalie
//
//  Created by Keith Staines on 15/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//



#import "AMExpressionNodeController.h"
#import "KSMExpression.h"
#import "KSMMathSheet.h"
#import "AMExpressionNodeView.h"
#import "AMMathSheetNameProvider.h"
#import "AMExpressionFormatContextNode.h"
#import "AMExpressionDataSource.h"

NSString * const kAMDemoExpressionMathStyle = @"4*Aj^2*e^(2*xi^2)";

@interface AMExpressionNodeController() <AMExpressionNodeViewDelegate,AMExpressionNodeViewDataSource, AMExpressionDataSource>
{
    KSMMathSheet * _mathSheet;
    KSMExpression * _expression;
    AMExpressionNodeView * _expressionNode;
    NSString * _expressionString;
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
    return [AMMathSheetNameProvider nameProviderWithDelegate:self.nameProviderDelegate mathSheet:self.mathSheet];
}
#pragma mark - AMExpressionNodeViewDataSource -
-(KSMExpression *)view:(NSView *)view requiresExpressionForSymbol:(NSString *)symbol
{
    return [self.mathSheet expressionForSymbol:symbol];
}
#pragma mark - AMExpressionNodeController -
-(AMExpressionNodeView*)expressionNode
{
    if (!_expressionNode) {
        AMExpressionFormatContextNode * context = [self makeExpressionContextNodeWithExpression:self.expression];
        _expressionNode = [[AMExpressionNodeView alloc] initWithFrame:NSZeroRect
                                                              groupID:@""
                                                           expression:self.expression
                                                       scriptingLevel:0
                                                             delegate:self
                                                           dataSource:self
                                                       displayOptions:nil
                                                          scaleFactor:1
                                                          contextNode:context];
    }
    return _expressionNode;
}
-(AMExpressionFormatContextNode*)makeExpressionContextNodeWithExpression:(KSMExpression*)expr
{
    return [[AMExpressionFormatContextNode alloc] initWithExpression:expr parent:nil asLeftNode:NO asRightNode:NO dataSource:self hideRedundantBrackets:YES cascadeBracketHiding:YES];
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
        NSString * symbol = [self.mathSheet buildAndRegisterExpressionFromString:self.expressionString];
        _expression = [self.mathSheet expressionForSymbol:symbol];
    }
    return _expression;
}

-(NSString *)expressionString
{
    if (!_expressionString) {
        _expressionString = kAMDemoExpressionMathStyle;
    }
    return _expressionString;
}
-(void)setExpressionString:(NSString *)expressionString
{
    _expressionString = expressionString;
    _expression = nil;  // force expression to be remade
    [self.expressionNode resetWithgroupID:@""
                               expression:self.expression
                           scriptingLevel:0
                                 delegate:self
                               dataSource:self
                           displayOptions:nil
                              scaleFactor:1
                              contextNode:nil];
    [self.expressionNode setNeedsDisplay:YES];
}
-(KSMMathSheet *)mathSheet
{
    if (!_mathSheet) {
        _mathSheet = [[KSMMathSheet alloc] init];
    }
    return _mathSheet;
}
#pragma mark - AMExpressionDataSource
-(KSMExpression *)expressionForSymbol:(NSString *)symbol
{
    return [self.mathSheet expressionForSymbol:symbol];
}

@end
