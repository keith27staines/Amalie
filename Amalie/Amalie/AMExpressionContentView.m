//
//  AMExpressionContentView.m
//  Amalie
//
//  Created by Keith Staines on 05/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMExpressionContentView.h"

@implementation AMExpressionContentView

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
    NSLog(@"%@ - viewDidMoveToWindow",self.class);
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

@end
