//
//  AMKeyboardsViewController.m
//  Amalie
//
//  Created by Keith Staines on 10/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "AMKeyboardConstants.h"
#import "AMKeyboardsViewController.h"
#import "AMKeyboardKeyModel.h"
#import "AMKeyboardView.h"
#import "AMKeyboards.h"
#import "AMKeyboard.h"
#import "AMKeyboardButtonView.h"
#import "AMKeyboardKeyModel.h"

@interface AMKeyboardsViewController ()
{
    NSArray                  * _keyButtons;
    NSArrayController        * _arrayController;
    __weak NSCollectionView  * _collectionView;
}
@end

@implementation AMKeyboardsViewController


-(NSString *)nibName
{
    return @"AMKeyboardsView";
}

-(NSBundle *)nibBundle
{
    return [NSBundle mainBundle];
}

-(AMKeyboardView *)keyboardView
{
    return (AMKeyboardView*)self.view;
}
-(void)selectKeyboard:(AMKeyboardIndex)keyboardIndex
{
    AMKeyboard * keyboard = [[AMKeyboards sharedKeyboards] keyboardWithIndex:keyboardIndex];
    self.keyButtons = [keyboard allKeys];
    [self.keyboardView reloadData];
}

-(NSUInteger)numberOfKeys
{
    return self.keyButtons.count;
}

-(AMKeyboardKeyModel*)keyForIndex:(NSUInteger)index
{
    return self.keyButtons[index];
}

- (IBAction)keyButtonPressed:(AMKeyboardButtonView *)sender
{
    id firstResponder = self.keyboardView.window.firstResponder;
    if (!firstResponder) return;
    if ( [firstResponder isKindOfClass:[NSTextView class]] ) {
        AMKeyboardKeyModel * keyboardKey = sender.keyboardKey;
        NSTextView * textView = (NSTextView *)firstResponder;
        [textView insertText:keyboardKey.name];
    }
}
@end
