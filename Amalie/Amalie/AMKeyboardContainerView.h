//
//  AMKeyboardContainerView.h
//  Amalie
//
//  Created by Keith Staines on 10/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMKeyboardsViewController;
@class AMKeyboardView;

#import <Cocoa/Cocoa.h>

@interface AMKeyboardContainerView : NSView

@property (weak) IBOutlet AMKeyboardsViewController * keyboardsViewController;

@property (weak) IBOutlet AMKeyboardView *keyboardView;

-(void)reloadKeys;

@end
