//
//  AMExpressionEditorContainerView.m
//  Amalie
//
//  Created by Keith Staines on 06/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMExpressionEditorContainerView.h"
#import "AMExpressionNodeContainerView.h"
#import "AMKeyboardConstants.h"
#import "AMKeyboardsViewController.h"
#import "AMKeyboardView.h"
#import "AMKeyboards.h"
#import "AMKeyboardView.h"
#import "AMKeyboard.h"

@interface AMExpressionEditorContainerView()
{
    AMKeyboardView * _keyboardView;
    BOOL _staticConstraitsAdded;
}
@property (weak) IBOutlet AMKeyboardsViewController * keyboardsController;

@property (readonly) AMKeyboardView * keyboardView;

@property (weak) IBOutlet NSControl * controlAboveKeyboard;
-(IBAction)keyboardSelector:(NSPopUpButton*)sender;

@property (weak) IBOutlet NSPopUpButton * keyboardSelector;

@property NSMutableArray * dynamicallyAddedConstraints;

- (IBAction)zoomSlider:(NSSlider *)sender;

@property (weak) IBOutlet NSSlider *zoomSlider;
@property (weak) IBOutlet NSScrollView *expressionScrollView;


@property (weak) IBOutlet AMExpressionNodeContainerView *expressionNodeContainerView;

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
-(void)viewDidMoveToWindow
{
    [self constrainExpressionNodeContainerView];
    [self loadKeyboardSelectorPopup];
    [self selectKeyboard:AMKeyboardIndexNone];
}
-(void)constrainExpressionNodeContainerView
{
    if (_staticConstraitsAdded) {
        return;
    }
    _staticConstraitsAdded = YES;
    NSView * view = self.expressionNodeContainerView;
    
    NSDictionary * views = NSDictionaryOfVariableBindings(view);
    NSArray * constraints;
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(<=0)-[view]-(<=0)-|" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(<=0)-[view]-(<=0)-|" options:0 metrics:nil views:views];
    [self addConstraints:constraints];

//    NSLayoutConstraint * constraint;
//    constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
//    [self addConstraint:constraint];
//    
//    constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
//    [self addConstraint:constraint];
//    
//    constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
//    [constraint setPriority:NSLayoutPriorityDragThatCannotResizeWindow];
//    [self addConstraint:constraint];
//    
//    constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
//    [constraint setPriority:NSLayoutPriorityDragThatCannotResizeWindow];
//    [self addConstraint:constraint];
}
-(void)loadKeyboardSelectorPopup
{
    [self.keyboardSelector removeAllItems];
    AMKeyboards * sharedKeyboards = [AMKeyboards sharedKeyboards];
    for (AMKeyboard * kb in sharedKeyboards.keyboards) {
        [self.keyboardSelector addItemWithTitle:kb.name];
    }
}
-(IBAction)keyboardSelector:(NSPopUpButton*)sender {
    [self.keyboardsController selectKeyboard:sender.indexOfSelectedItem];
    [self updateConstraints];
}
-(void)selectKeyboard:(AMKeyboardIndex)keyboardIndex
{
    [self.keyboardSelector selectItemAtIndex:keyboardIndex];
    [self.keyboardView reloadData];
}
-(AMKeyboardView *)keyboardView
{
    if (!_keyboardView) {
        _keyboardView = self.keyboardsController.keyboardView;
        [_keyboardView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_keyboardView];
    }
    return _keyboardView;
}
-(void)updateConstraints
{
    [super updateConstraints];
    if (self.dynamicallyAddedConstraints) {
        [self removeConstraints:self.dynamicallyAddedConstraints];
    }
    NSView * controlAboveKB = self.controlAboveKeyboard;
    NSView * kb = self.keyboardView;
    NSDictionary * views = NSDictionaryOfVariableBindings(controlAboveKB,kb);
    if ([self.keyboardSelector indexOfSelectedItem] == AMKeyboardIndexNone) {
        [kb setHidden:YES];
        self.dynamicallyAddedConstraints = [NSMutableArray array];
        NSView * controlAboveKB = self.controlAboveKeyboard;
        NSDictionary * views = NSDictionaryOfVariableBindings(controlAboveKB);
        self.dynamicallyAddedConstraints = [[NSLayoutConstraint constraintsWithVisualFormat:@"V:[controlAboveKB]-|" options:0 metrics:nil views:views] mutableCopy];
    } else {
        [kb setHidden:NO];
        self.dynamicallyAddedConstraints = [[NSLayoutConstraint constraintsWithVisualFormat:@"V:[controlAboveKB]-[kb]-|" options:0 metrics:nil views:views] mutableCopy];
        [self.dynamicallyAddedConstraints addObjectsFromArray:[[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[kb]-(20)-|" options:0 metrics:nil views:views] mutableCopy]];
    }
    [self addConstraints:self.dynamicallyAddedConstraints];
    
}

- (IBAction)zoomSlider:(NSSlider *)sender {
    CGFloat mag = sender.floatValue /4.0;
    [self.expressionScrollView setMagnification:mag];
}
@end
