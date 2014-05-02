//
//  AMFunctionPropertiesView.h
//  Amalie
//
//  Created by Keith Staines on 23/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMArgumentListViewController, AMFunctionPropertiesViewController;

#import <Cocoa/Cocoa.h>
#import "AMFunctionPropertiesViewDelegate.h"

@interface AMFunctionPropertiesView : NSView

@property (weak) IBOutlet NSTableView *argumentTable;

@property IBOutlet id<AMFunctionPropertiesViewDelegate>delegate;

@property IBOutlet NSPopUpButton * returnTypePopup;

@property (weak) IBOutlet NSTextField *nameLabel;

@property (weak) IBOutlet NSTextField *nameField;

@property IBOutlet AMArgumentListViewController * argumentListViewController;

-(void)reloadData;

@end
