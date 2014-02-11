//
//  AMContentView.m
//  Amalie
//
//  Created by Keith Staines on 23/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMContentView.h"
#import "AMContentViewDataSource.h"

@interface AMContentView()
{
    __weak id<AMContentViewDataSource> _datasource;
}

@end

@implementation AMContentView

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
}

-(BOOL)isOpaque
{
    return YES;
}

-(id<AMContentViewDataSource>)datasource
{
    return _datasource;
}

-(void)setDatasource:(id<AMContentViewDataSource>)datasource
{
    _datasource = datasource;
}

-(void)viewDidMoveToWindow
{
    // This is getting called unexpectedly on closing an app without saving.
    // Need to guard against trying to repopulate a no longer fully valid object
    if (self.window && self.superview) {
        [self.datasource populateView:self];
    }
}

-(void)updateConstraints
{
    [super updateConstraints];
    [self.superview setNeedsUpdateConstraints:YES];
}

@end
