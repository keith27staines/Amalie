//
//  AMInspectorView.m
//  Amalie
//
//  Created by Keith Staines on 19/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMInspectorView.h"

@implementation AMInspectorView

-(BOOL)isOpaque {
    return YES;
}
-(BOOL)isFlipped {
    return YES;
}
- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    [[NSColor colorWithCalibratedRed:0.9 green:0.9 blue:0.9 alpha:1] set];
    NSRectFill(dirtyRect);
}

-(void)reloadData {
    NSLog(@"%@ did not override reloadData",self.class);
}
@end
