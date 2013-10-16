//
//  AMKeyboardsViewController.h
//  Amalie
//
//  Created by Keith Staines on 10/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMKeyboardKeyModel;
@class AMKeyPadContainerView;
@class AMKeyboardButtonView;

typedef enum AMKeyboardIndex : NSUInteger {
    AMKeyboardIndexGreekSmall   = 0,
    AMKeyboardIndexGreekCapital = 1,
} AMKeyboardIndex;


#import <Cocoa/Cocoa.h>

@interface AMKeyboardsViewController : NSViewController


@property (strong) NSArray * keyButtons;

@property (weak) IBOutlet NSPopUpButton *keyboardSelector;

- (IBAction)keyboadSelectorChanged:(NSPopUpButton *)sender;


@property (weak) IBOutlet AMKeyPadContainerView * keyPadContainerView;

- (IBAction)keyButtonPressed:(AMKeyboardButtonView *)sender;

-(NSUInteger)numberOfKeys;
-(AMKeyboardKeyModel*)keyForIndex:(NSUInteger)index;

@end
