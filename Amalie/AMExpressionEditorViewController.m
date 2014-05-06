//
//  AMExpressionEditorViewController.m
//  Amalie
//
//  Created by Keith Staines on 06/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMExpressionEditorViewController.h"
#import "AMDExpression+Methods.h"
#import "AMAmalieDocument.h"

@interface AMExpressionEditorViewController ()
{
    __weak AMDExpression * _expression;
}
@end

@implementation AMExpressionEditorViewController

-(NSString *)nibName
{
    return @"AMExpressionEditorViewController";
}
-(AMDExpression *)expression
{
    return _expression;
}
-(void)setExpression:(AMDExpression *)expression
{
    _expression = expression;
}
-(void)reloadData
{
    self.expressionStringField.stringValue = self.expression.originalString;
}
- (IBAction)close:(id)sender {
    [self.document endExpressionEditor:self];
}
@end
