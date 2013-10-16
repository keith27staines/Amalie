//
//  AMKeyboardButtonView.h
//  Amalie
//
//  Created by Keith Staines on 14/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMKeyboardsViewController;
@class AMKeyboardKeyModel;

#import <Cocoa/Cocoa.h>

@interface AMKeyboardButtonView : NSButton

@property (weak) AMKeyboardsViewController * keyboardsViewController;
@property (weak) AMKeyboardKeyModel * keyboardKey;


@end
