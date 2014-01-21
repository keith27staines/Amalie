//
//  AMEquationContentView.m
//  Amalie
//
//  Created by Keith Staines on 03/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMEquationContentView.h"
#import "AMExpressionNodeView.h"
#import "AMNameView.h"

@implementation AMEquationContentView

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
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

-(BOOL)autoresizesSubviews
{
    return NO;
}

-(void)viewDidMoveToWindow
{
    [super viewDidMoveToWindow];
}

-(void)setDatasource:(id<AMContentViewDataSource>)datasource
{
    [super setDatasource:datasource];
    self.nameView.dataSource = self.datasource;
}

-(void)setGroupID:(NSString *)groupID
{
    [super setGroupID:groupID];
    self.expressionView.groupID = groupID;
    self.nameView.groupID = groupID;
}


@end
