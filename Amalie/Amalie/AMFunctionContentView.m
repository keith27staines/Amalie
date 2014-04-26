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

-(NSMutableArray *)dynamicConstraints
{
    if (!_dynamicConstraints) {
        _dynamicConstraints = [NSMutableArray array];
    }
    return _dynamicConstraints;
}

-(void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}
-(void)removeDynamicConstraints
{
    [self removeConstraints:self.dynamicConstraints];
    [self.dynamicConstraints removeAllObjects];
}
-(void)updateConstraints
{
    [super updateConstraints];
    [self removeDynamicConstraints];
    
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
    if (self.argumentListView) {

        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[nameView(nameWidth)]-narrow-[argumentsView(argsWidth)]-space-[expressionView]" options:NSLayoutFormatAlignAllBaseline metrics:metrics views:views];
    } else {
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[nameView(>=nameWidth)]-space-[expressionView]" options:NSLayoutFormatAlignAllBaseline metrics:metrics views:views];
    }
    [self.dynamicConstraints addObjectsFromArray:constraints];
    [self addConstraints:constraints];
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
