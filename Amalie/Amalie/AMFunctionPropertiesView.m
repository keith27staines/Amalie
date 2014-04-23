//
//  AMFunctionPropertiesView.m
//  Amalie
//
//  Created by Keith Staines on 23/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMFunctionPropertiesView.h"
#import "AMArgumentListViewController.h"
#import "AMArgumentListView.h"

@implementation AMFunctionPropertiesView


-(void)awakeFromNib
{
    AMArgumentListView *argView;
    argView = [self argumentListView];
    argView.delegate = self.argumentListViewController;
    [argView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:argView];
    [self updateConstraints];
}
-(void)reloadData
{
    [[self argumentListView] reloadData];
}
-(void)updateConstraints
{
    [super updateConstraints];
    NSView * argView = [self argumentListView];
    NSView * argTable = [self argumentTableContainer];
    NSDictionary * views = NSDictionaryOfVariableBindings(argView,argTable);
    NSArray * constraints;
    constraints =  [NSLayoutConstraint constraintsWithVisualFormat:@"V:[argView]-25.0-[argTable]"
                                                           options:NSLayoutFormatAlignAllLeft
                                                           metrics:nil
                                                             views:views];
    
    [self addConstraints:constraints];
    constraints =  [NSLayoutConstraint constraintsWithVisualFormat:@"H:[argView(argTable)]"
                                                           options:0
                                                           metrics:nil
                                                             views:views];
    [self addConstraints:constraints];
}
-(AMArgumentListView*)argumentListView
{
    return (AMArgumentListView*)[self.argumentListViewController view];
}
-(NSView*)argumentTableContainer
{
    NSView * tableContainer = nil;
    for (NSView * view in self.subviews) {
        if ([view.identifier isEqualToString:@"argumentTableContainer"]) {
            tableContainer = view;
            break;
        }
    }
    NSAssert(tableContainer, @"Argument table was not found");
    return tableContainer;
}
@end
