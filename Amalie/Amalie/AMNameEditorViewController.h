//
//  AMNameEditorViewController.h
//  Amalie
//
//  Created by Keith Staines on 28/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMTextView;

#import <Cocoa/Cocoa.h>
#import "AMKeyboardEditorViewController.h"
#import "AMNameProviding.h"

@interface AMNameEditorViewController : AMKeyboardEditorViewController <NSTextFieldDelegate>

@property (weak) IBOutlet AMTextView *nameDisplay;


@property (weak) IBOutlet NSTextField *nameField;


@end
