//
//  AMFunctionInspectorView.m
//  Amalie
//
//  Created by Keith Staines on 19/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMFunctionInspectorView.h"
#import "AMFunctionInspectorViewController.h"
#import "AMDFunctionDef+methods.h"
#import "AMNamedObject.h"

@implementation AMFunctionInspectorView

-(void)viewDidMoveToSuperview
{
    [self.delegate setupValuePopup:self.returnTypePopup];
}
-(void)reloadData
{
    [self reloadFunctionName];
    [self reloadReturnType];
    [self reloadArgumentTable];
    [self reloadExpressionString];
}
-(void)reloadFunctionName {
    self.nameField.stringValue = [self.functionDef.name string];
}
-(AMDFunctionDef*)functionDef {
    return [self.delegate functionDef];
}
-(void)reloadReturnType {
    [self.returnTypePopup selectItemWithTag:self.functionDef.returnType.integerValue];
}
-(void)reloadArgumentTable {
    [self.argumentTable reloadData];
}
-(void)reloadExpressionString {
    self.expressionString.stringValue = self.delegate.expressionString;
}
@end
