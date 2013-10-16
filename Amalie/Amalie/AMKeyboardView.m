//
//  AMKeyboardView.m
//  Amalie
//
//  Created by Keith Staines on 15/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMKeyboardView.h"

@implementation AMKeyboardView

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
	
    // Drawing code here.
}

-(BOOL)isFlipped
{
    return YES;
}

@end
