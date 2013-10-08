//
//  AMSymbolsView.m
//  Amalie
//
//  Created by Keith Staines on 07/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMSymbolsView.h"

@implementation AMSymbolsView

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
    [[NSColor colorWithCalibratedRed:1 green:0.5 blue:0.5 alpha:1] set];
    NSRectFill(dirtyRect);
}

@end
