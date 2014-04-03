//
//  AMColorSetupViewController.m
//  Amalie
//
//  Created by Keith Staines on 21/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMColorSetupViewController.h"
#import "AMConstants.h"
#import "AMColorPreferencesViewController.h"
#import "AMAmalieDocument.h"

@interface AMColorSetupViewController ()

@end

@implementation AMColorSetupViewController

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
    return @"AMColorSetupViewController";
}

-(NSView *)view
{
    NSView * view = [super view];
    NSView * subView = [self colorPreferencesView];
    [view addSubview:subView];
    NSDictionary * views = NSDictionaryOfVariableBindings(subView);
    NSArray * constraints;
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|" options:0 metrics:nil views:views];
    [view addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|" options:0 metrics:nil views:views];
    [view addConstraints:constraints];
    
    return view;
}

-(NSView*)colorPreferencesView
{
    self.colorPreferenceViewController.documentSettings = self.document.documentSettings;
    self.colorPreferenceViewController.settingsType = AMSettingsTypeCurrentDocument;
    NSView * view = self.colorPreferenceViewController.view;
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    return view;
}
@end
