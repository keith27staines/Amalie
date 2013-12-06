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
#import "AMPreferences.h"


@interface AMArgumentListViewController ()
{
    __weak AMDArgumentList * _argumentList;
    __weak AMArgumentListView * _argumentListView;
}

@property (weak, readonly) AMArgumentListView * argumentListView;

@end


@implementation AMArgumentListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"AMArgumentListView" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}
-(AMArgumentListView*)argumentListView
{
    return (AMArgumentListView*)self.view;
}

-(void)awakeFromNib
{
    self.argumentListView.leftBrace.stringValue = @"(";
    self.argumentListView.rightBrace.stringValue = @")";
    [self applyUserPreferences];
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

-(NSUInteger)displayStringCount
{
    return self.argumentList.arguments.count;
}

-(NSAttributedString *)displayStringForIndex:(NSUInteger)index
{
    return [self.argumentList argumentAtIndex:index].name.attributedString;
}

-(void)applyUserPreferences
{
    NSFont * font = [AMPreferences standardFont];
    self.argumentListView.textField.font = font;
    self.argumentListView.leftBrace.font = font;
    self.argumentListView.rightBrace.font = font;
}

@end
