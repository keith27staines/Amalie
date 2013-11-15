//
//  AMExpressionContentView.m
//  Amalie
//
//  Created by Keith Staines on 05/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMExpressionContentView.h"
#import "AMExpressionNodeView.h"

@implementation AMExpressionContentView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(BOOL)translatesAutoresizingMaskIntoConstraints
{
    return NO;
}

-(void)viewDidMoveToWindow
{
    [super viewDidMoveToWindow];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}

-(void)setDatasource:(id<AMContentViewDataSource>)datasource
{
    [super setDatasource:datasource];
    self.expressionView.datasource = self.datasource;
}

-(void)setGroupID:(NSString *)groupID
{
    [super setGroupID:groupID];
    self.expressionView.groupID = groupID;
}

@end
