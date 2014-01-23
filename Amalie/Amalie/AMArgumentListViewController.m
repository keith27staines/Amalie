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
#import "AMNameProvider.h"


@interface AMArgumentListViewController ()
{
    __weak AMDArgumentList * _argumentList;
    __weak AMArgumentListView * _argumentListView;
}

@property (weak, readonly) AMArgumentListView * argumentListView;
@property (weak) AMNameProvider * namer;
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
    [self.argumentListView reloadData];
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
    AMNameProviderBase * namer = [[AMNameProviderBase alloc] init];
    return [namer fontForSymbolsAtScriptinglevel:scriptingLevel];
}

-(NSUInteger)displayStringCount
{

    return self.argumentList.arguments.count;
}

-(NSAttributedString *)displayStringForIndex:(NSUInteger)index
                            atScriptingLevel:(NSUInteger)scriptingLevel
{
    NSAttributedString * aString = [self.argumentList argumentAtIndex:index].name.attributedString;
    AMNameProviderBase * namer = [[AMNameProviderBase alloc] init];
    return [namer attributedStringByModifying:aString toSuperscriptLevel:scriptingLevel];
}


























@end