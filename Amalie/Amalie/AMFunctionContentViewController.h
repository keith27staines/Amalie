//
//  AMFunctionContentViewController.h
//  Amalie
//
//  Created by Keith Staines on 03/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMDFunctionDef;
@class AMExpressionNodeView;
@class AMFunctionContentView;
@class AMTextView;
@class AMExpandingTextFieldView;

#import "AMContentViewController.h"
#import "AMExpressionNodeViewDelegate.h"
#import "AMExpressionDataSource.h"

@interface AMFunctionContentViewController : AMContentViewController
<NSTextFieldDelegate, NSPopoverDelegate, AMExpressionNodeViewDelegate, AMExpressionDataSource>

@property (weak) IBOutlet AMAmalieDocument * document;
@property (strong) IBOutlet NSPopover * editPopover;
@property (weak) AMExpandingTextFieldView * expressionStringView;
@property (weak) AMExpressionNodeView * expressionView;

@property (weak) AMFunctionContentView *contentView;

@property (strong, readonly) AMDFunctionDef * amdFunctionDef;

-(void)reloadData;

@property (readonly) BOOL isConstant;
@property (readonly) BOOL isVariable;

- (IBAction)showExpressionEditor:(id)sender;
@property (copy) NSString * expressionString;

@end
