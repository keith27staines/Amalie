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
#import "AMExpressionFormatContextNode.h"

NSString * const kAMDemoExpressionMathStyle = @"4*Aj^2*e^(2*xi^2)";

@interface AMExpressionNodeController() <AMExpressionNodeViewDelegate,AMExpressionNodeViewDataSource, AMExpressionDataSource>
{
    KSMMathSheet         * _mathSheet;
    id<AMNameProviding>    _nameProvider;
    KSMExpression        * _expression;
    AMExpressionNodeView * _expressionNodeView;
    NSString             * _expressionString;
}
@property (readonly) KSMExpression * expression;
@property (weak) id<AMNameProviderDelegate> nameProviderDelegate;
@property (readonly) KSMMathSheet * mathSheet;
@property (readonly) id<AMNameProviding>nameProvider;
@property (copy, readonly) NSString * expressionString;
@property (readonly) AMExpressionFormatContextNode * contextNode;
@end

@implementation AMExpressionNodeController

-(void)awakeFromNib
{

}

#pragma mark - AMExpressionNodeViewDelegate -
-(id<AMNameProviding>)nameProvider
{
    if ([self.delegate respondsToSelector:@selector(expressionNodeControllerWantsNameProvider:)]) {
            _nameProvider = [self.delegate expressionNodeControllerWantsNameProvider:self];
    }
    if (!_nameProvider) {
        _nameProvider = [AMMathSheetNameProvider nameProviderWithDelegate:self.nameProviderDelegate mathSheet:self.mathSheet];
    }
    return _nameProvider;
}
#pragma mark - AMExpressionNodeViewDataSource -
-(KSMExpression *)view:(NSView *)view requiresExpressionForSymbol:(NSString *)symbol
{
    return [self.mathSheet expressionForSymbol:symbol];
}
#pragma mark - AMExpressionNodeController -
-(AMExpressionNodeView*)expressionNodeView
{
    if (!_expressionNodeView) {
        _expressionNodeView = [[AMExpressionNodeView alloc] initWithFrame:NSZeroRect
                                                              groupID:@""
                                                           expression:self.expression
                                                       scriptingLevel:0
                                                             delegate:self
                                                           dataSource:self
                                                       displayOptions:nil
                                                          scaleFactor:1
                                                          contextNode:self.contextNode];
    }
    return _expressionNodeView;
}
-(AMExpressionFormatContextNode*)contextNode
{
    return [[AMExpressionFormatContextNode alloc] initWithExpression:self.expression parent:nil asLeftNode:NO asRightNode:NO dataSource:self hideRedundantBrackets:YES cascadeBracketHiding:YES];
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
    [self reloadData];
}
-(void)reloadData
{
    [self.expressionNodeView resetWithgroupID:@""
                               expression:self.expression
                           scriptingLevel:0
                                 delegate:self
                               dataSource:self
                           displayOptions:nil
                              scaleFactor:1
                              contextNode:self.contextNode];
    [self.expressionNodeView setNeedsDisplay:YES];
}
-(KSMMathSheet *)mathSheet
{
    if ([self.delegate respondsToSelector:@selector(expressionNodeControllerWantsMathsSheet:)]) {
        return [self.delegate expressionNodeControllerWantsMathsSheet:self];
    } else {
        if (!_mathSheet) {
            if (!_mathSheet) {
                _mathSheet = [[KSMMathSheet alloc] init];
            }
        }
    }
    return _mathSheet;
}
#pragma mark - AMExpressionDataSource
-(KSMExpression *)expressionForSymbol:(NSString *)symbol
{
    return [self.mathSheet expressionForSymbol:symbol];
}

@end
