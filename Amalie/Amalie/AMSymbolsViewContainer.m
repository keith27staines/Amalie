//
//  AMSymbolsViewContainer.m
//  Amalie
//
//  Created by Keith Staines on 07/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMSymbolsViewContainer.h"

@implementation AMSymbolsViewContainer

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

-(void)resizeSubviewsWithOldSize:(NSSize)oldSize
{
    [super resizeSubviewsWithOldSize:oldSize];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor colorWithCalibratedRed:1 green:0.8 blue:0.8 alpha:1] set];
    NSRectFill(dirtyRect);
    for (NSView * view in self.subviews) {
        NSRect intersection = NSIntersectionRect(dirtyRect, view.frame);
        if ( ! NSIsEmptyRect(intersection) ) {
            [view setNeedsDisplay:YES];
        }
    }
}

@end
