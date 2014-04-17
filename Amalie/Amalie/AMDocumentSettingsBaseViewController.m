//
//  AMDocumentSettingsBaseViewController.m
//  Amalie
//
//  Created by Keith Staines on 07/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMDocumentSettingsBaseViewController.h"
#import "AMAmalieDocument.h"
#import "AMPreferencesViewControllerBase.h"

@implementation AMDocumentSettingsBaseViewController

-(NSView *)view
{
    NSView * view = [super view];
    NSView * subView = [self preferencesView];
    [view addSubview:subView];
    NSDictionary * views = NSDictionaryOfVariableBindings(subView);
    NSArray * constraints;
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|" options:0 metrics:nil views:views];
    [view addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|" options:0 metrics:nil views:views];
    [view addConstraints:constraints];
    
    return view;
}

-(NSView*)preferencesView
{
    self.preferencesViewController.documentSettings = (AMDocumentSettingsBase*)self.document.documentSettings;
    self.preferencesViewController.settingsStorageLocationType = AMSettingsStorageLocationTypeCurrentDocument;
    NSView * view = self.preferencesViewController.view;
    [self.preferencesViewController reloadData];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    return view;
}

@end
