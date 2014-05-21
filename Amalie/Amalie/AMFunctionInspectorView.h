//
//  AMFunctionInspectorView.h
//  Amalie
//
//  Created by Keith Staines on 19/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMArgumentListViewController;

#import <Cocoa/Cocoa.h>
#import "AMInspectorView.h"
#import "AMFunctionInspectorViewController.h"

@interface AMFunctionInspectorView : AMInspectorView

@property (weak) IBOutlet NSTableView *argumentTable;

@property IBOutlet AMFunctionInspectorViewController * delegate;

@property IBOutlet NSPopUpButton * returnTypePopup;

@property (weak) IBOutlet NSTextField *nameLabel;

@property (weak) IBOutlet NSTextField *nameField;

@property IBOutlet AMArgumentListViewController * argumentListViewController;

@property (weak) IBOutlet NSTextField *titleLabel;

@property (weak) IBOutlet NSTextField *functionTypeLabel;

@property (weak) IBOutlet NSTextField *argumentsLabel;

@property (weak) IBOutlet NSTextField *expressionLabel;

@property (weak) IBOutlet NSTableView *argumentsTable;

@property (weak) IBOutlet NSTextField *expressionString;

@end
