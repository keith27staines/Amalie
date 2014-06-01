//
//  AMKeyboardEditorContainerView.m
//  Amalie
//
//  Created by Keith Staines on 31/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMKeyboardEditorContainerView.h"
#import "AMKeyboardConstants.h"
#import "AMKeyboardsViewController.h"
#import "AMKeyboardView.h"
#import "AMKeyboards.h"
#import "AMKeyboardView.h"
#import "AMKeyboard.h"

@interface AMKeyboardEditorContainerView()
{
    @protected
    AMKeyboardView * _keyboardView;
    AMKeyboardsViewController * _keyboardsController;
}
@property (weak) IBOutlet NSPopUpButton * keyboardSelector;
-(IBAction)keyboardSelector:(NSPopUpButton*)sender;
- (void)selectKeyboard: (AMKeyboardIndex)keyboardIndex;
@property IBOutlet AMKeyboardsViewController * keyboardsController;
@property (readonly) AMKeyboardView * keyboardView;
@property (weak) IBOutlet NSControl * controlAboveKeyboard;
@end

@implementation AMKeyboardEditorContainerView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}
-(void)viewDidMoveToWindow
{
    [self loadKeyboardSelectorPopup];
    [self selectKeyboard:AMKeyboardIndexNone];
}
- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(AMKeyboardsViewController*)keyboardsController
{
    if (!_keyboardsController) {
        _keyboardsController = [[AMKeyboardsViewController alloc] init];
    }
    return _keyboardsController;
}
-(void)setKeyboardsController:(AMKeyboardsViewController *)keyboardsController
{
    _keyboardsController = keyboardsController;
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

-(AMKeyboardView *)keyboardView
{
    if (!_keyboardView) {
        _keyboardView = self.keyboardsController.keyboardView;
        [_keyboardView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_keyboardView];
    }
    return _keyboardView;
}

-(void)selectKeyboard:(AMKeyboardIndex)keyboardIndex
{
    [self.keyboardSelector selectItemAtIndex:keyboardIndex];
    [self.keyboardView reloadData];
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

@end
