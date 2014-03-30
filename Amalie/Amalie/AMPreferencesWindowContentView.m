//
//  AMPreferencesWindowContentView.m
//  Amalie
//
//  Created by Keith Staines on 30/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMPreferencesWindowContentView.h"

@implementation AMPreferencesWindowContentView


-(void)drawRect:(NSRect)dirtyRect
{
    NSRect insetRect = NSInsetRect(self.bounds, 20, 20);
    [[NSColor whiteColor] set];
    NSRectFill(insetRect);
    [[NSColor darkGrayColor] set];
    [NSBezierPath strokeRect:insetRect];
}
@end
