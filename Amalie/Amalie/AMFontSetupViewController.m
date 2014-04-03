//
//  AMFontSetupViewController.m
//  Amalie
//
//  Created by Keith Staines on 21/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMFontSetupViewController.h"
#import "AMConstants.h"
#import "AMFontPreferencesViewController.h"
#import "AMAmalieDocument.h"

@interface AMFontSetupViewController ()

@end

@implementation AMFontSetupViewController

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
    return @"AMFontSetupViewController";
}
-(NSView *)view
{
    NSView * view = [super view];
    NSView * subView = [self fontPreferencesView];
    [view addSubview:subView];
    NSDictionary * views = NSDictionaryOfVariableBindings(subView);
    NSArray * constraints;
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|" options:0 metrics:nil views:views];
    [view addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|" options:0 metrics:nil views:views];
    [view addConstraints:constraints];
    
    return view;
}

-(NSView*)fontPreferencesView
{
    self.fontPreferenceViewController.documentSettings = self.document.documentSettings;
    self.fontPreferenceViewController.settingsStorageLocationType = AMSettingsStorageLocationTypeCurrentDocument;
    NSView * view = self.fontPreferenceViewController.view;
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    return view;
}
@end
