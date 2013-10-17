//
//  AMKeyboardsAreaView.m
//  Amalie
//
//  Created by Keith Staines on 07/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMKeyboardsAreaView.h"

@implementation AMKeyboardsAreaView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(BOOL)autoresizesSubviews
{
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor colorWithCalibratedRed:0.3 green:0.3 blue:0.3 alpha:1] set];
    NSRectFill(dirtyRect);
    for (NSView * view in self.subviews) {
        NSRect intersection = NSIntersectionRect(dirtyRect, view.frame);
        if ( ! NSIsEmptyRect(intersection) ) {
            intersection = [view convertRect:intersection fromView:self];
            [view setNeedsDisplayInRect:intersection];
        }
    }
    
    NSPoint start = self.bounds.origin;
    NSPoint finish = NSMakePoint(self.bounds.size.width,start.y);
    [[NSColor blackColor] set];
    [NSBezierPath strokeLineFromPoint:start toPoint:finish];
}

-(BOOL)isFlipped
{
    return YES;
}

@end
