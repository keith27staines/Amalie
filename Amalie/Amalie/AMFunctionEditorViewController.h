//
//  AMFunctionEditorViewController.h
//  Amalie
//
//  Created by Keith Staines on 04/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMFunctionContentViewController;
@class AMArgumentListViewController;
@class AMDFunctionDef;
@class AMAmalieDocument;

#import <Cocoa/Cocoa.h>

@interface AMFunctionEditorViewController : NSViewController <NSPopoverDelegate, NSTableViewDelegate, NSControlTextEditingDelegate, NSTableViewDataSource>

- (IBAction)addArgument:(NSButton *)sender;
- (IBAction)removeArgument:(NSButton *)sender;
- (IBAction)valueTypePopupChanged:(NSPopUpButton *)sender;

@property (weak) IBOutlet NSTableView *argumentTable;
@property (weak) IBOutlet AMFunctionContentViewController * functionContentViewController;
@property (weak) IBOutlet AMArgumentListViewController * argumentListViewController;
@property (weak) IBOutlet NSView *functionEditorView;
@property (weak) IBOutlet NSPopUpButton *returnTypePopup;
@property (weak) IBOutlet NSPopUpButton *argumentTypePopup;
@property (weak) IBOutlet AMAmalieDocument * document;

@property BOOL popoverShowing;

@end
