//
//  AMKeyboardButtonView.m
//  Amalie
//
//  Created by Keith Staines on 14/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMKeyboardButtonView.h"
#import "AMKeyboardKeyModel.h"
#import "AMKeyboardsViewController.h"

@interface AMKeyboardButtonView()
{
    __weak AMKeyboardsViewController    * _keyboardsViewController;
    __weak AMKeyboardKeyModel                * _keyboardKey;
}

@end

@implementation AMKeyboardButtonView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setShowsBorderOnlyWhileMouseInside:NO];
        [self setRefusesFirstResponder:NO];
        [self setAllowsMixedState:NO];
        [self setBordered:YES];
        [self setBezelStyle:NSShadowlessSquareBezelStyle];
    }
    return self;
}

-(void)setKeyboardKey:(AMKeyboardKeyModel *)keyboardKey
{
    _keyboardKey = keyboardKey;
    self.title = keyboardKey.name;
    self.toolTip = keyboardKey.englishName;
    [self setNeedsDisplay:YES];
}

-(AMKeyboardKeyModel*)keyboardKey
{
    return _keyboardKey;
}

-(BOOL)isOpaque
{
    return YES;
}

@end
