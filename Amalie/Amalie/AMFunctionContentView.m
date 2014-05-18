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
#import "AMArgumentListViewController.h"
#import "AMDFunctionDef.h"
#import "AMExpandingTextFieldView.h"

@interface AMFunctionContentView()
{
    AMExpressionNodeView * _expressionView;
    AMExpandingTextFieldView          * _expressionStringView;
    AMArgumentListView   * _argumentListView;
    AMTextView           * _nameView;
    NSButton             * _propertiesButton;
    NSButton             * _expressionEditorButton;
    NSMutableArray       * _dynamicConstraints;
}

@end


@implementation AMFunctionContentView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}
-(void)awakeFromNib
{
    // Expression content view stuff - refactor to super
    _expressionView = [[AMExpressionNodeView alloc] init];
    _expressionStringView = [[AMExpandingTextFieldView alloc] init];
    [_expressionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_expressionStringView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_expressionStringView];
    [self addSubview:_expressionView];
    [self addExpressionEditorButton];
    
    // function content additions
    _nameView = [[AMTextView alloc] init];
    _argumentListView = (AMArgumentListView*)self.argumentListViewController.view;
    [_nameView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_argumentListView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_nameView];
    [self addSubview:_argumentListView];
    [self addFunctionPropertiesButton];
}
-(NSMutableDictionary*)metricsDictionary
{
    CGFloat nameWidth   = fmaxf(self.nameView.intrinsicContentSize.width,12);
    CGFloat nameHeight  = fmaxf(self.nameView.intrinsicContentSize.height, 12);
    CGFloat argsWidth   = fmaxf(self.argumentListView.intrinsicContentSize.width,12);
    CGFloat argsHeight  = fmaxf(self.argumentListView.intrinsicContentSize.height,12);
    CGFloat space       = self.expressionView.standardSpace;
    CGFloat narrowSpace = self.expressionView.narrowSpace;
    return [@{@"argsWidth"      : @(argsWidth),
              @"argsHeight"     : @(argsHeight),
              @"nameWidth"      : @(nameWidth),
              @"nameHeight"     : @(nameHeight),
              @"space"          : @(space) ,
              @"narrowSpace"    : @(narrowSpace)} mutableCopy];

}
/*!
 *  Returns a dictionary of variable bindings suitable for use in autlolayout visual format language
 *  The bindings are:
 *  expression       = self.expressionView
 *  expressionString = self.expressionStringView
 *  name             = self.nameView
 *  args             = self.argumentListView
 *  expressionEditorButton = self.expressionEditorButton
 *  propertiesButton       = self.propertiesButton
 *  @return a dictionary of variable bindings
 */
-(NSMutableDictionary*)viewsDictionary
{
    NSView * expression = self.expressionView;
    expression.identifier = @"expression";
    NSView * expressionString = self.expressionStringView;
    expressionString.identifier = @"expressionString";
    NSView * name = self.nameView;
    name.identifier = @"name";
    NSView * args = self.argumentListView;
    args.identifier = @"args";
    NSView * expressionEditorButton = self.expressionEditorButton;
    expressionEditorButton.identifier = @"expressionEditorButton";
    NSView * propertiesButton = self.propertiesButton;
    propertiesButton.identifier = @"propertiesButton";
    return [NSDictionaryOfVariableBindings(expression,
                                           expressionString,
                                           name,
                                           args,
                                           expressionEditorButton,
                                           propertiesButton) mutableCopy];
}
-(void)setNeedsUpdateConstraints:(BOOL)flag
{
    [super setNeedsUpdateConstraints:flag];
}
-(void)updateConstraints
{
    [super updateConstraints];
    if (!self.isPreparedForDynamicConstraints) {
        return;
    }
    if (!_dynamicConstraints) {
        _dynamicConstraints = [NSMutableArray array];
    }
    if (_dynamicConstraints.count > 0) {
        [self removeConstraints:_dynamicConstraints];
        [_dynamicConstraints removeAllObjects];
    }
    // Expression constraints... (refactor to super?)
    NSDictionary * views = [self viewsDictionary];
    NSDictionary * metrics = [self metricsDictionary];
    [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20@750)-[expression]-(>=20@1000)-|" options:0 metrics:metrics views:views]];

    [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[expression]-(<=20@750)-|" options:0 metrics:metrics views:views]];
    
    [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20@750)-[expressionString(>=40)][expressionEditorButton]-(>=20@1000)-|" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:views]];
    
    [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[expressionEditorButton]-(<=20@750)-|" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:views]];
    
    [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20@750)-[expression]-[expressionString]-(20@750)-|" options:NSLayoutFormatAlignAllLeft metrics:metrics views:views]];

    // function content specific constraints
    NSLog(@"Args width = %@",metrics[@"argsWidth"]);
    [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[name]-(narrowSpace)-[args]-[expression]" options:NSLayoutFormatAlignAllBaseline metrics:metrics views:views]];
    
    [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[name]" options:0 metrics:metrics views:views]];
    
    [_dynamicConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[propertiesButton]-(>=8)-[expressionString]" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:views]];
    
    [self addConstraints:_dynamicConstraints];
}
-(void)addExpressionEditorButton
{
    NSButton * button = [[NSButton alloc] init];
    button.title = @"...";
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button setButtonType:NSMomentaryPushButton]; // button clicks in and out but doesn't change image
    [button setBordered:YES];
    [button setBezelStyle:NSSmallSquareBezelStyle];
    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(22)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(22)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
    [self addSubview:button];
    _expressionEditorButton = button;
}
-(void)addFunctionPropertiesButton
{
    NSButton * button = [[NSButton alloc] init];
    button.title = @"";
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button setButtonType:NSMomentaryPushButton]; // button clicks in and out but doesn't change image
    [button setBordered:YES];
    [button setBezelStyle:NSCircularBezelStyle];
    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(22)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(22)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
    [self addSubview:button];
    _propertiesButton = button;
}
-(void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}
-(BOOL)isFlipped
{
    return YES;
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
