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

-(void)viewDidMoveToSuperview
{
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:NSViewFrameDidChangeNotification
                        object:self.worksheetView
                         queue:[NSOperationQueue mainQueue]
                    usingBlock:^(NSNotification * note){
        [self resizeAndCenter];
    }];
    [self resizeAndCenter];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor colorWithCalibratedRed:0.7 green:0.8 blue:1 alpha:.2] set];
    NSRectFill(dirtyRect);
}

-(void)resizeWithOldSuperviewSize:(NSSize)oldSize
{
    [self resizeAndCenter];
}
-(BOOL)autoresizesSubviews
{
    return NO;
}

-(void)resizeAndCenter
{
    [self setFrameSize:[self intrinsicContentSize]];
    
    // Centre the worksheet if the worksheet is smaller, else make the origins coincide
    CGFloat worksheetOriginY = 0.0;
    CGFloat worksheetOriginX = 0.0;
    CGFloat myHeight = self.frame.size.height;
    CGFloat myWidth  = self.frame.size.width;
    CGFloat worksheetHeight = self.worksheetView.frame.size.height;
    CGFloat worksheetWidth  = self.worksheetView.frame.size.width;
    if (myHeight > worksheetHeight) {
        worksheetOriginY = (myHeight - worksheetHeight)/2.0;
    } else {
        worksheetOriginY = 0.0;
    }
    if (myWidth > worksheetWidth) {
        worksheetOriginX = (myWidth - worksheetWidth) / 2.0;
    } else {
        worksheetOriginX = 0.0;
    }
    [self.worksheetView setFrameOrigin:NSMakePoint(worksheetOriginX, worksheetOriginY)];
}


-(NSSize)intrinsicContentSize
{
    NSSize size = self.worksheetView.intrinsicContentSize;
    if (size.width < self.superview.bounds.size.width) {
        size.width = self.superview.bounds.size.width;
    }
    if (size.height < self.superview.bounds.size.height) {
        size.height = self.superview.bounds.size.height;
    }
    return size;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
