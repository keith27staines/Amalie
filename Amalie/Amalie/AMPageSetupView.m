//
//  AMPageSetupView.m
//  Amalie
//
//  Created by Keith Staines on 20/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMPageSetupView.h"

@implementation AMPageSetupView

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

}

-(BOOL)isOpaque
{
    // Warning! Bug whereby textfields retain focus ring after losing focus if isOpaque = YES;
    return NO;
}

@end
