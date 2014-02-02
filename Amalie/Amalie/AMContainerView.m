//
//  AMContainerView.m
//  Amalie
//
//  Created by Keith Staines on 01/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMContainerView.h"

@implementation AMContainerView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}
-(BOOL)isOpaque
{
    return YES;
}
-(BOOL)isFlipped
{
    return YES;
}
- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    [[NSColor colorWithCalibratedRed:0.95 green:0.95 blue:0.95 alpha:1] set];
    NSRectFill(self.bounds);
}


@end
