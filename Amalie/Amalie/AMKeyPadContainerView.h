//
//  AMAMKeyPadContainerView.h
//  Amalie
//
//  Created by Keith Staines on 10/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMKeyboardsViewController;

#import <Cocoa/Cocoa.h>

@interface AMKeyPadContainerView : NSView

@property (weak) IBOutlet AMKeyboardsViewController * keyboardsViewController;

@property (weak) IBOutlet NSView *keyPad;

-(void)reloadKeys;

@end
