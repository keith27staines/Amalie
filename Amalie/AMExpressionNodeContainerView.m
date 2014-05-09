//
//  AMExpressionNodeContainerView.m
//  Amalie
//
//  Created by Keith Staines on 08/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMExpressionNodeContainerView.h"
#import "AMExpressionNodeView.h"
@interface AMExpressionNodeContainerView()
{
    AMExpressionNodeView * _expressionNodeView;
}

@end

@implementation AMExpressionNodeContainerView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}
-(void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] set];
    NSRectFill(self.bounds);
}
-(BOOL)isFlipped
{
    return YES;
}

-(AMExpressionNodeView *)expressionNodeView
{
    return _expressionNodeView;
}
-(void)setExpressionNodeView:(AMExpressionNodeView *)expressionNodeView
{
    if (expressionNodeView == _expressionNodeView) {
        return;
    }
    
    [_expressionNodeView removeFromSuperview];
    _expressionNodeView = expressionNodeView;
    [_expressionNodeView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_expressionNodeView];
    NSDictionary * views = NSDictionaryOfVariableBindings(_expressionNodeView);
    NSArray * constraints;
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=20)-[_expressionNodeView]-(>=20)-|" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=20)-[_expressionNodeView]-(>=20)-|" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    
    [self setNeedsUpdateConstraints:YES];
    [self setNeedsDisplay:YES];
}

@end
