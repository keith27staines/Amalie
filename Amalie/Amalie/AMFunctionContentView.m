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
#import "AMDFunctionDef.h"

@interface AMFunctionContentView()
{
    __weak AMArgumentListView * _argumentListView;
    NSMutableArray * _dynamicConstraints;
}
@property (readonly) NSMutableArray * dynamicConstraints;
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
-(void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}
-(void)removeDynamicConstraints
{
    if (_dynamicConstraints) {
        [self removeConstraints:_dynamicConstraints];
        [_dynamicConstraints removeAllObjects];
    }
}
-(void)updateConstraints
{
    [super updateConstraints];
    [self removeDynamicConstraints];
    [self addConstraints:[self dynamicConstraints]];
}
-(BOOL)isFlipped
{
    return YES;
}
-(NSArray*)dynamicConstraints{
    if (!_dynamicConstraints) {
        _dynamicConstraints = [NSMutableArray array];
        AMTextView * nameView = self.nameView;
        AMExpressionNodeView * expressionView = self.expressionView;
        AMArgumentListView * argumentsView = self.argumentListView;
        NSDictionary * views;
        NSDictionary * metrics;
        CGFloat nameWidth = fmaxf(nameView.intrinsicContentSize.width,12);
        CGFloat argsWidth = fmaxf(argumentsView.intrinsicContentSize.width,12);
        CGFloat space     = expressionView.standardSpace;
        CGFloat narrowSpace = expressionView.narrowSpace;
        views = NSDictionaryOfVariableBindings(nameView, argumentsView, expressionView);
        metrics = @{ @"argsWidth": @(argsWidth),
                     @"nameWidth": @(nameWidth),
                     @"space"    : @(space) ,
                     @"narrow"   : @(narrowSpace)};
        NSArray * constraints;
        [argumentsView setHidden:NO];
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[nameView(nameWidth)]-narrow-[argumentsView(argsWidth)]-(space@750)-[expressionView]" options:NSLayoutFormatAlignAllBaseline metrics:metrics views:views];
        [_dynamicConstraints addObjectsFromArray:constraints];
    }
    return _dynamicConstraints;
}

-(void)setDataSource:(id<AMContentViewDataSource>)dataSource
{
    [super setDataSource:dataSource];
}

-(void)setGroupID:(NSString *)groupID
{
    [super setGroupID:groupID];
    self.expressionView.groupID = groupID;
}
-(void)setArgumentListView:(AMArgumentListView *)argumentListView
{
    _argumentListView = argumentListView;
    [self setNeedsUpdateConstraints:YES];
    [self setNeedsDisplay:YES];
}
-(AMArgumentListView *)argumentListView
{
    return _argumentListView;
}


@end
