//
//  AMArgumentTableRowView.h
//  Amalie
//
//  Created by Keith Staines on 22/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//
@class AMTextView;

#import <Cocoa/Cocoa.h>

@interface AMArgumentTableRowView : NSView

@property (weak) IBOutlet NSPopUpButton *valueTypePopup;


@property (weak) IBOutlet NSButton *showNameEditor;

@property (weak) IBOutlet AMTextView *argumentName;

@end
