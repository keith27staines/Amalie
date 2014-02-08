//
//  AMCenteringView.m
//  Amalie
//
//  Created by Keith Staines on 06/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMCenteringView.h"
#import "AMWorksheetView.h"

@implementation AMCenteringView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)awakeFromNib
{

}

- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor colorWithCalibratedRed:0.65 green:0.72 blue:0.51 alpha:1] set];
    NSRectFill(dirtyRect);
}

-(BOOL)isOpaque
{
    return NO;
}

-(BOOL)isFlipped
{
    return YES;
}

@end
