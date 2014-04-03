//
//  AMUserPreferencesWindowContentView.m
//  Amalie
//
//  Created by Keith Staines on 30/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMUserPreferencesWindowContentView.h"

@implementation AMUserPreferencesWindowContentView


-(void)drawRect:(NSRect)dirtyRect
{
    NSRect insetRect = NSInsetRect(self.bounds, 19, 19);
    [[NSColor whiteColor] set];
    NSRectFill(insetRect);
    [[NSColor darkGrayColor] set];
    [NSBezierPath strokeRect:insetRect];
}
@end
