//
//  AMExpressionEditorContainerView.m
//  Amalie
//
//  Created by Keith Staines on 06/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMExpressionEditorContainerView.h"
#import "AMKeyboardsViewController.h"

@interface AMExpressionEditorContainerView()
{
    NSView * _keyboardView;
}
@property (weak) IBOutlet AMKeyboardsViewController * keyboardsController;
@property (readonly) NSView * keyboardView;
@property (weak) IBOutlet NSControl * controlAboveKeyboard;
@property (weak) IBOutlet NSControl * controlBelowKeyboard;
-(IBAction)toggleKeyboard:(id)sender;

@property NSMutableArray * dynamicallyAddedConstraints;
@end


@implementation AMExpressionEditorContainerView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}
- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}
-(IBAction)toggleKeyboard:(id)sender {
    [self.keyboardView setHidden:!self.keyboardView.isHidden];
    [self updateConstraints];
}
-(NSView *)keyboardView
{
    if (!_keyboardView) {
        _keyboardView = self.keyboardsController.view;
        [_keyboardView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_keyboardView];
        [_keyboardView setHidden:YES];
    }
    return _keyboardView;
}
-(void)updateConstraints
{
    [super updateConstraints];
    if (self.dynamicallyAddedConstraints) {
        [self removeConstraints:self.dynamicallyAddedConstraints];
    }

    if (self.keyboardView.isHidden) {
        self.dynamicallyAddedConstraints = [NSMutableArray array];
        NSView * above = self.controlAboveKeyboard;
        NSView * below = self.controlBelowKeyboard;
        [self.dynamicallyAddedConstraints addObject:[NSLayoutConstraint constraintWithItem:above attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:below attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    } else {
        NSView * above = self.controlAboveKeyboard;
        NSView * below = self.controlBelowKeyboard;
        NSView * kb = self.keyboardView;
        NSDictionary * views = NSDictionaryOfVariableBindings(above,below,kb);
        self.dynamicallyAddedConstraints = [[NSLayoutConstraint constraintsWithVisualFormat:@"V:[above]-[kb]-[below]" options:0 metrics:nil views:views] mutableCopy];
        [self.dynamicallyAddedConstraints addObjectsFromArray:[[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=20)-[kb]-(>=20)-|" options:0 metrics:nil views:views] mutableCopy]];
    }
    [self addConstraints:self.dynamicallyAddedConstraints];
}

@end
