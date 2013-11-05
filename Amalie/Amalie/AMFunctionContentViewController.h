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
@class AMNameView;

#import "AMContentViewController.h"

@interface AMFunctionContentViewController : AMContentViewController <NSTextFieldDelegate>
{
    
    __weak NSTextField *_nameField;
    __weak NSTextField *_expressionStringView;
}

@property (weak) IBOutlet AMNameView *nameView;

@property (weak) IBOutlet NSTextField *expressionStringView;

@property (weak) IBOutlet AMExpressionNodeView * expressionView;

@property (strong) IBOutlet AMFunctionContentView *functionView;

@property (strong) IBOutlet NSPopover *editPopover;

@property (strong, readonly) AMDFunctionDef * amdFunctionDef;

- (IBAction)cancelPopover:(id)sender;
- (IBAction)showPopover:(NSButton *)sender;
- (IBAction)acceptEditPopover:(id)sender;
@end
