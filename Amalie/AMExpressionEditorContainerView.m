//
//  AMExpressionEditorContainerView.m
//  Amalie
//
//  Created by Keith Staines on 06/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMExpressionEditorContainerView.h"
#import "AMExpressionNodeContainerView.h"


@interface AMExpressionEditorContainerView()
{
    BOOL _staticConstraitsAdded;
}


@property (weak) IBOutlet NSControl * controlAboveKeyboard;



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
    [super viewDidMoveToWindow];
    [self constrainExpressionNodeContainerView];
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

- (IBAction)zoomSlider:(NSSlider *)sender {
    CGFloat mag = sender.floatValue /4.0;
    [self.expressionScrollView setMagnification:mag];
}
@end
