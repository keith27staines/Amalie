//
//  AMFunctionPropertiesView.m
//  Amalie
//
//  Created by Keith Staines on 23/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMFunctionPropertiesView.h"
#import "AMDFunctionDef+Methods.h"
#import "AMDName.h"
#import "AMArgumentListViewController.h"
#import "AMArgumentListView.h"

@interface AMFunctionPropertiesView()
@property (weak, readonly) AMDFunctionDef * functionDef;
@end

@implementation AMFunctionPropertiesView

-(void)viewDidMoveToSuperview
{
    [self.delegate setupValuePopup:self.returnTypePopup];
    AMArgumentListView *argView;
    argView = [self argumentListView];
    [argView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:argView];
    [self updateConstraints];
}
-(void)reloadData
{
    self.nameLabel.attributedStringValue = self.functionDef.name.attributedString;
    self.nameField.stringValue = self.functionDef.name.string;
    [self.returnTypePopup selectItemWithTag:self.functionDef.returnType.integerValue];
    [self.argumentTable reloadData];
    [[self argumentListView] reloadData];
    [self setNeedsDisplay:YES];
}
-(AMDFunctionDef*)functionDef
{
    return [self.delegate functionDef];
}
-(void)updateConstraints
{
    [super updateConstraints];
    NSView * argView = [self argumentListView];
    NSView * argTable = [self argumentTableContainer];
    NSView * nameField = self.nameField;
    NSView * nameLabel = self.nameLabel;
    NSDictionary * views = NSDictionaryOfVariableBindings(argView,argTable,nameField,nameLabel);
    NSArray * constraints;
    constraints =  [NSLayoutConstraint constraintsWithVisualFormat:@"H:[nameLabel]-[argView]-(>=20)-|"
                                                           options:NSLayoutFormatAlignAllBaseline
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
