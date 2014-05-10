//
//  AMKeyboardsViewController.h
//  Amalie
//
//  Created by Keith Staines on 10/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMKeyboardKeyModel;
@class AMKeyboardView;
@class AMKeyboardButtonView;

#import <Cocoa/Cocoa.h>
#import "AMKeyboardConstants.h"

@interface AMKeyboardsViewController : NSViewController

@property (strong) NSArray * keyButtons;

@property (weak,readonly) AMKeyboardView * keyboardView;

- (IBAction)keyButtonPressed:(AMKeyboardButtonView *)sender;

-(NSUInteger)numberOfKeys;
-(AMKeyboardKeyModel*)keyForIndex:(NSUInteger)index;
-(void)selectKeyboard:(AMKeyboardIndex)keyboardIndex;
@end
