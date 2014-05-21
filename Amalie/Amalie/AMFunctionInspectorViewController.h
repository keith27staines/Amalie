//
//  AMFunctionInspectorViewController.h
//  Amalie
//
//  Created by Keith Staines on 18/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMFunctionContentViewController;
@class AMArgumentListViewController;
@class AMDFunctionDef;

#import <Cocoa/Cocoa.h>
#import "AMInspectorViewController.h"
#import "AMFunctionPropertiesViewDelegate.h"

@interface AMFunctionInspectorViewController : AMInspectorViewController
<AMFunctionPropertiesViewDelegate>

@property (weak) IBOutlet NSPopUpButton *argumentTypePopup;
@property (readonly) id<AMNameProviding> nameProvider;
@property (copy,readonly) NSString * expressionString;
- (IBAction)valueTypePopupChanged:(NSPopUpButton *)sender;

@property (weak) IBOutlet AMArgumentListViewController * argumentListViewController;

@property (weak, readonly) AMDFunctionDef * functionDef;

- (IBAction)showNameEditor:(id)sender;

- (IBAction)addArgument:(id)sender;

- (IBAction)removeArgument:(id)sender;

- (IBAction)showExpressionEditor:(id)sender;


@end
