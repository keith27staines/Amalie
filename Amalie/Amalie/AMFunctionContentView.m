//
//  AMFunctionContentView.m
//  Amalie
//
//  Created by Keith Staines on 03/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMFunctionContentView.h"
#import "AMExpressionNodeView.h"
#import "AMArgumentListView.h"

@interface AMFunctionContentView()
{
    
}

@end


@implementation AMFunctionContentView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)updateConstraints
{
    [super updateConstraints];
    
    NSArray * constraints;
    AMTextView * nameView = self.nameView;
    AMExpressionNodeView * expressionView = self.expressionView;
    AMArgumentListView * argumentsView = self.argumentListView;
    NSDictionary * views;
    NSDictionary * metrics;
    CGFloat nameWidth = fmaxf(nameView.intrinsicContentSize.width,12);
    CGFloat argsWidth = fmaxf(argumentsView.intrinsicContentSize.width,12);
    CGFloat space     = expressionView.standardSpace;
    
    if (self.argumentListView) {
        views = NSDictionaryOfVariableBindings(nameView, argumentsView, expressionView);
        metrics = @{ @"argsWidth": @(argsWidth),
                     @"nameWidth": @(nameWidth),
                     @"space"    : @(space) };
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[nameView(nameWidth)][argumentsView(argsWidth)]-space-[expressionView]" options:NSLayoutFormatAlignAllBaseline metrics:metrics views:views];
    } else {
        views = NSDictionaryOfVariableBindings(nameView, expressionView);
        metrics = @{ @"nameWidth": @(nameWidth), @"space": @(space) };
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[nameView(>=nameWidth)]-space-[expressionView]" options:NSLayoutFormatAlignAllBaseline metrics:metrics views:views];
    }
    [self addConstraints:constraints];
}

-(void)setDatasource:(id<AMContentViewDataSource>)datasource
{
    [super setDatasource:datasource];
}

-(void)setGroupID:(NSString *)groupID
{
    [super setGroupID:groupID];
    self.expressionView.groupID = groupID;
}


@end
