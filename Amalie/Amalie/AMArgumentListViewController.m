//
//  AMArgumentListViewController.m
//  Amalie
//
//  Created by Keith Staines on 08/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMArgumentListViewController.h"
#import "AMDArgumentList+Methods.h"
#import "AMDArgument+Methods.h"
#import "AMDName+Methods.h"
#import "AMUserPreferences.h"
#import "AMPersistedObjectWithArgumentsNameProvider.h"
#import "AMAmalieDocument.h"


@interface AMArgumentListViewController ()
{
    __weak AMDArgumentList * _argumentList;
    __weak AMArgumentListView * _argumentListView;
}

@property (weak, readonly) AMArgumentListView * argumentListView;
@property (weak) AMPersistedObjectWithArgumentsNameProvider * namer;
@end


@implementation AMArgumentListViewController

-(NSString *)nibName
{
    return @"AMArgumentListView";
}
-(AMArgumentListView*)argumentListView
{
    return (AMArgumentListView*)self.view;
}
-(void)reloadData
{
    [[self argumentListView] reloadData];
}
-(void)setArgumentList:(AMDArgumentList *)argumentList
{
    _argumentList = argumentList;
    [self.argumentListView reloadData];
}

-(AMDArgumentList *)argumentList
{
    return _argumentList;
}

#pragma mark - AMArgumentListViewDelegate -

-(NSFont*)bracesFontAtScriptingLevel:(NSUInteger)scriptingLevel
{
    return [self.nameProvider fontForSymbolsAtScriptinglevel:scriptingLevel];
}

-(NSUInteger)displayStringCount
{
    return self.argumentList.arguments.count;
}

-(NSAttributedString *)displayStringForIndex:(NSUInteger)index
                            atScriptingLevel:(NSUInteger)scriptingLevel
{
    NSAttributedString * aString = [self.argumentList argumentAtIndex:index].name.attributedString;
    return [self.nameProvider attributedStringByModifying:aString toSuperscriptLevel:scriptingLevel];
}


























@end
