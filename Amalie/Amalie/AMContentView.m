//
//  AMContentView.m
//  Amalie
//
//  Created by Keith Staines on 23/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMContentView.h"

@interface AMContentView()
{
    __weak KSMExpression * _expression;
}

@end

@implementation AMContentView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    
    return self;
}

-(void)setExpression:(KSMExpression *)expression
{
    _expression = expression;
    [self setNeedsDisplay:YES];
}

-(KSMExpression*)expression
{
    return _expression;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

@end
