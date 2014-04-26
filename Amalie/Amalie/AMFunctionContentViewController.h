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

#import "AMContentViewController.h"
#import "AMExpressionNodeViewDelegate.h"
#import "AMExpressionDataSource.h"

@interface AMFunctionContentViewController : AMContentViewController
<NSTextFieldDelegate, NSPopoverDelegate, AMExpressionNodeViewDelegate, AMExpressionDataSource>

@property (weak) IBOutlet AMAmalieDocument * document;

@property (weak) IBOutlet NSButton *popupButton;

@property (weak) IBOutlet AMTextView *nameView;

@property (weak) IBOutlet NSTextField *expressionStringView;
@property (weak) IBOutlet AMExpressionNodeView * expressionView;

@property (weak) IBOutlet AMFunctionContentView *contentView;

@property (strong) IBOutlet NSPopover *editPopover;

- (IBAction)showPopover:(NSButton *)sender;

@property (strong, readonly) AMDFunctionDef * amdFunctionDef;

-(void)reloadData;

@property (readonly) BOOL isConstant;
@property (readonly) BOOL isVariable;

@end
