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

-(NSInteger)trayIndex
{
    // Sets have index 6
    return 6;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}

@end
