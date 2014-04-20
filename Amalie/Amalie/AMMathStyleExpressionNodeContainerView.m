//
//  AMMathStyleExpressionNodeContainerView.m
//  Amalie
//
//  Created by Keith Staines on 18/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMMathStyleExpressionNodeContainerView.h"

@implementation AMMathStyleExpressionNodeContainerView

-(void)drawRect:(NSRect)dirtyRect
{
    [[NSColor colorWithCalibratedRed:0.9 green:0.9 blue:0.9 alpha:1] set];
    NSRectFill(self.bounds);
    [[NSColor blackColor] set];
    [NSBezierPath strokeRect:self.bounds];
}

@end
