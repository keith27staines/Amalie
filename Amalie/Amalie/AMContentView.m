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
    [self.datasource populateView:self];
}

@end
