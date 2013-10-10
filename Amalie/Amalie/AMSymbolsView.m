//
//  AMSymbolsView.m
//  Amalie
//
//  Created by Keith Staines on 10/10/2013.
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

-(BOOL)translatesAutoresizingMaskIntoConstraints
{
    return NO;
}


-(void)resizeWithOldSuperviewSize:(NSSize)oldSize
{
    self.frame = self.superview.bounds;
}

-(void)viewDidMoveToSuperview
{
    [self setFrame:[self superview].bounds];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor greenColor] set];
    NSRectFill(dirtyRect);
}

@end
