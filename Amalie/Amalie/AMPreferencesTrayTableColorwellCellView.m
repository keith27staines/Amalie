//
//  AMPreferencesTrayTableColorWellCellView.m
//  Amalie
//
//  Created by Keith Staines on 09/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMPreferencesTrayTableColorWellCellView.h"

NSUInteger const colorWellTag = 1;

@implementation AMPreferencesTrayTableColorWellCellView

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
    _colorWell = [self viewWithTag:colorWellTag];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    [super drawRect:dirtyRect];
}

@end
