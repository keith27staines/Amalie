//
//  AMPageUserPreferencesViewController.m
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMPageUserPreferencesViewController.h"
#import "AMPageSetupViewController.h"
#import "AMPageSetupView.h"
#import "AMPreferences.h"
#import "AMPaper.h"

@interface AMPageUserPreferencesViewController ()

@property (unsafe_unretained) IBOutlet AMPageSetupViewController *pageSetupViewController;

@end

@implementation AMPageUserPreferencesViewController

#pragma mark - NSViewController -
-(NSString *)nibName
{
    return @"AMPageUserPreferencesViewController";
}

-(void)awakeFromNib
{

}

#pragma mark - AMUserPreferencesViewControlling -
-(void)reloadData
{
    AMPageSetupViewController * vc = self.pageSetupViewController;
    AMPaper * paper = [[AMPaper alloc] init];
    vc.paper = paper;
    vc.delegate = self;
    AMPageSetupView * pageSetupView = (AMPageSetupView*)vc.view;
    NSView * containerView = self.view;
    [pageSetupView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [containerView addSubview:pageSetupView];
    NSDictionary * viewsDictionary = NSDictionaryOfVariableBindings(pageSetupView,containerView);
    NSArray * constraints;
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[pageSetupView]-|" options:0 metrics:nil views:viewsDictionary];
    [containerView addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[pageSetupView]-|" options:0 metrics:nil views:viewsDictionary];
    [containerView addConstraints:constraints];
}

#pragma mark - AMPaperDelegate -
-(void)pageSetupViewController:(AMPageSetupViewController *)vc didUpdatePaper:(AMPaper *)paper
{
    [paper writeToAMPreferences];
}
@end
