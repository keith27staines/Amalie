//
//  AMInsertableGraph2DView.m
//  Amalie
//
//  Created by Keith Staines on 12/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMInsertableGraph2DView.h"

@implementation AMInsertableGraph2DView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(NSString*)trayItemKey
{
    return kAMGraph2DKey;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}

@end
