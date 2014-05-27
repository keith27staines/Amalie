//
//  AMArgumentTableRowView.m
//  Amalie
//
//  Created by Keith Staines on 22/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMArgumentTableRowView.h"

@implementation AMArgumentTableRowView

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
-(BOOL)acceptsFirstResponder {
    return YES;
}
-(BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
    return YES;
}
@end
