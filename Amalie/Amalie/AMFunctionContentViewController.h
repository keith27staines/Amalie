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

@interface AMFunctionContentViewController : AMContentViewController
<NSTextFieldDelegate, AMExpressionNodeViewDelegate>


@property (weak) IBOutlet NSButton *popupButton;

@property (weak) IBOutlet AMTextView *nameView;

@property (weak) IBOutlet NSTextField *expressionStringView;
@property (weak) IBOutlet AMExpressionNodeView * expressionView;

@property (weak) IBOutlet AMFunctionContentView *contentView;

@property (strong) IBOutlet NSPopover *editPopover;

@property (strong, readonly) AMDFunctionDef * amdFunctionDef;


@property (readonly) BOOL isConstant;
@property (readonly) BOOL isVariable;

- (IBAction)cancelPopover:(id)sender;
- (IBAction)showPopover:(NSButton *)sender;
- (IBAction)acceptEditPopover:(id)sender;
@end
