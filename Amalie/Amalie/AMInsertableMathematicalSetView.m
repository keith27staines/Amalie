//
//  AMInsertableMathematicalSetView.m
//  Amalie
//
//  Created by Keith Staines on 12/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMInsertableMathematicalSetView.h"

@implementation AMInsertableMathematicalSetView

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
    return kAMMathematicalSetKey;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}

@end
