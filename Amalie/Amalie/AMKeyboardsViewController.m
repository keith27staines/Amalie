//
//  AMKeyboardsViewController.m
//  Amalie
//
//  Created by Keith Staines on 10/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "AMKeyboardsViewController.h"
#import "AMKeyboardKeyModel.h"
#import "AMKeyboardContainerView.h"
#import "AMKeyboards.h"
#import "AMKeyboard.h"

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

-(void)awakeFromNib
{
    [self.keyboardSelector removeAllItems];
    
    AMKeyboards * sharedKeyboards = [AMKeyboards sharedKeyboards];
    for (AMKeyboard * kb in sharedKeyboards.keyboards) {
        [self.keyboardSelector addItemWithTitle:kb.name];
    }
    
    [self.keyboardSelector selectItemAtIndex:AMKeyboardIndexGreekSmall];
    [self selectKeyboard:AMKeyboardIndexGreekSmall];
}

-(void)selectKeyboard:(AMKeyboardIndex)keyboardIndex
{
    AMKeyboard * keyboard = [[AMKeyboards sharedKeyboards] keyboardWithIndex:keyboardIndex];
    self.keyButtons = [keyboard allKeys];
    [self.keyboardContainerView reloadKeys];
}

-(NSUInteger)numberOfKeys
{
    return self.keyButtons.count;
}

-(AMKeyboardKeyModel*)keyForIndex:(NSUInteger)index
{
    return self.keyButtons[index];
}

- (IBAction)keyboadSelectorChanged:(NSPopUpButton *)sender
{
    [self selectKeyboard:sender.indexOfSelectedItem];
}

- (IBAction)keyButtonPressed:(NSButton *)sender {
}
@end