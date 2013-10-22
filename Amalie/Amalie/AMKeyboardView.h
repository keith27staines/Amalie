//
//  AMKeyboardView.h
//  Amalie
//
//  Created by Keith Staines on 15/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMKeyboardsViewController;

#import <Cocoa/Cocoa.h>

@interface AMKeyboardView : NSView

@property (weak) IBOutlet AMKeyboardsViewController * keyboardsViewController;

-(void)updateKeyLabels;

@end
