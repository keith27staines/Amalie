//
//  AMFunctionPropertiesViewController.h
//  Amalie
//
//  Created by Keith Staines on 04/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMFunctionContentViewController;
@class AMArgumentListViewController;
@class AMDFunctionDef;

#import <Cocoa/Cocoa.h>
#import "AMFunctionPropertiesViewDelegate.h"
#import "AMNameProviding.h"

extern NSString * const AMFunctionPropertiesDidEndEditingNotification;


@interface AMFunctionPropertiesViewController : NSViewController <AMFunctionPropertiesViewDelegate>

@property (weak) IBOutlet NSTextField *nameLabel;

@property (weak) IBOutlet AMArgumentListViewController * argumentListViewController;

@property (weak) IBOutlet NSPopUpButton *returnTypePopup;
@property (weak) IBOutlet NSPopUpButton *argumentTypePopup;
@property (weak) IBOutlet id<AMNameProviding> nameProvider;

- (IBAction)addArgument:(NSButton *)sender;
- (IBAction)removeArgument:(NSButton *)sender;
- (IBAction)valueTypePopupChanged:(NSPopUpButton *)sender;
- (IBAction)editingFinishedButtonClicked:(id)sender;

@property BOOL popoverShowing;
@property (weak) AMDFunctionDef * functionDef;

-(void)reloadData;

@end
