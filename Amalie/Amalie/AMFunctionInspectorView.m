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
-(void)expressionStringWasEdited
{
    [self reloadData];
}
-(void)reloadData
{
    AMDFunctionDef * functionDef = [self.delegate functionDef];
    self.nameField.stringValue = [functionDef.name string];
    [self.returnTypePopup selectItemWithTag:functionDef.returnType.integerValue];
    [self.argumentTable reloadData];
    self.expressionString.stringValue = self.delegate.expressionString;
}
@end
