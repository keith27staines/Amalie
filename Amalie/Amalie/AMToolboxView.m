//
//  AMToolboxView.m
//  Amalie
//
//  Created by Keith Staines on 04/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMToolboxView.h"

@implementation AMToolboxView

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
    NSColor * darkGrey  = [NSColor colorWithCalibratedRed:0.25 green:0.25 blue:0.25 alpha:1.0];
    NSColor * lightGrey = [NSColor colorWithCalibratedRed:0.30 green:0.30 blue:0.30 alpha:1.0];
    NSArray * colors = @[darkGrey, lightGrey];
    NSGradient * gradient = [[NSGradient alloc] initWithColors:colors];
    [gradient drawInRect:self.bounds angle:0];
    NSPoint start = self.bounds.origin;
    NSPoint finish = NSMakePoint(start.x, self.bounds.size.height);
    [[NSColor blackColor] set];
    [NSBezierPath strokeLineFromPoint:start toPoint:finish];
}

@end
