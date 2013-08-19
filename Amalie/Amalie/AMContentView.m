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

}

@end

@implementation AMContentView

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
}

-(BOOL)isOpaque
{
    return YES;
}

-(void)populate
{
    // subclasses should override
}

@end
