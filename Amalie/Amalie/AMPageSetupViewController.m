//
//  AMPageSetupViewController.m
//  Amalie
//
//  Created by Keith Staines on 20/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMPageSetupViewController.h"
#import "AMPagePreferencesViewController.h"
#import "AMPagePreferencesView.h"
#import "AMUserPreferences.h"
#import "AMAmalieDocument.h"

@interface AMPageSetupViewController ()
{
    AMPageSettings * _pageSettings;
}
@end

@implementation AMPageSetupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(NSString *)nibName
{
    return @"AMPageSetupViewController";
}
-(NSView *)view
{
    NSView * view = [super view];
    NSView * subView = [self pagePreferencesView];
    [view addSubview:subView];
    NSDictionary * views = NSDictionaryOfVariableBindings(subView);
    NSArray * constraints;
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|" options:0 metrics:nil views:views];
    [view addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|" options:0 metrics:nil views:views];
    [view addConstraints:constraints];
    
    return view;
}

-(NSView*)pagePreferencesView
{
    self.pagePreferencesViewController.documentSettings = self.document.documentSettings;
    self.pagePreferencesViewController.settingsStorageLocationType = AMSettingsStorageLocationTypeCurrentDocument;
    NSView * view = self.pagePreferencesViewController.view;
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    return view;
}
@end
