//
//  AMKeyboardContainerView.m
//  Amalie
//
//  Created by Keith Staines on 10/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "AMKeyboardContainerView.h"
#import "AMKeyboardButtonView.h"
#import "AMKeyboardsViewController.h"
#import "AMKeyboardKeyModel.h"
#import "AMKeyboardView.h"

@interface AMKeyboardContainerView()
{
    __weak AMKeyboardsViewController * _keyboardsViewController;
    __weak AMKeyboardView            * _keyboardView;
}

@end


@implementation AMKeyboardContainerView

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
    self.keyboardView.keyboardsViewController = self.keyboardsViewController;
    NSSize requiredSize = self.keyboardView.intrinsicContentSize;
    requiredSize.height = requiredSize.height * 1.5;
    requiredSize.width = requiredSize.width * 1.1;
    [self setFrameSize:requiredSize];
    [self centreView:self.keyboardView inContainerView:self];
}

-(void)centreView:(NSView*)view inContainerView:(NSView*)container
{
    // centre in superview without changing my size
    NSSize containerSize = container.bounds.size;
    NSSize viewSize = view.frame.size;
    NSPoint viewOrigin = view.frame.origin;
    viewOrigin.x = (containerSize.width - viewSize.width) / 2.0;
    viewOrigin.y = (containerSize.height - viewSize.height)/2.0;
    [view setFrameOrigin:viewOrigin];
}

-(BOOL)autoresizesSubviews
{
    return NO;
}

-(void)resizeWithOldSuperviewSize:(NSSize)oldSize
{
    
    [self centreView:self inContainerView:self.superview];
    [self centreView:self.keyboardView inContainerView:self];
}

-(BOOL)isFlipped
{
    return YES;
}

-(BOOL)translatesAutoresizingMaskIntoConstraints
{
    return NO;
}

-(void)reloadKeys
{
    [self.keyboardView reloadKeys];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor colorWithCalibratedRed:0.3
                               green:0.3
                                blue:0.3
                               alpha:1] set];
    NSRectFill(dirtyRect);
}

@end
