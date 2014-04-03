//
//  AMUserPreferencesWindowController.m
//  Amalie
//
//  Created by Keith Staines on 07/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMUserPreferencesWindowController.h"
#import "AMConstants.h"
#import "AMUserPreferences.h"

#import "AMColorPreferencesViewController.h"
#import "AMFontPreferencesViewController.h"
#import "AMMathPreferencesViewController.h"
#import "AMPagePreferencesViewController.h"
#import "AMPreferencesBaseViewController.h"

static CGFloat const kAMMINPREFERENCEPANEWIDTH = 900;  // minimum pane width in points

@interface AMUserPreferencesWindowController ()
@property (strong, readonly) AMUserPreferences * preferences;

@end

typedef NS_ENUM(NSUInteger,AMUserPreferencesView) {
    AMUserPreferencesViewFonts,
    AMUserPreferencesViewColors,
    AMUserPreferencesViewPage,
    AMUserPreferencesViewMath,
};

@implementation AMUserPreferencesWindowController

-(void)awakeFromNib
{
    // First call setup goes here
    [self displayViewController:self.pagePreferencesViewController];
}

-(void)showColorsView:(id)sender
{
    self.window.title = NSLocalizedString(@"Amalie colors", @"Window title for user preferences panel dedicated to the colors of various displayed objects");
    [self displayViewController:self.colorPreferencesViewController];
}
-(void)showFontsView:(id)sender
{
    self.window.title = NSLocalizedString(@"Amalie worksheet fonts", @"Window title for user preferences panel dedicated to font settings");
    [self displayViewController:self.fontPreferencesViewController];
}
-(void)showMathView:(id)sender
{
    self.window.title = NSLocalizedString(@"Amalie mathematical style preferences",@"Window title for user preferences panel dedicated to mathematical style settings");
    [self displayViewController:self.mathPreferencesViewController];
}
-(void)showPageView:(id)sender
{
    self.window.title = NSLocalizedString(@"Amalie page size, orientation and margins",@"Window title for user preferences panel dedicated to page setup");
    [self displayViewController:self.pagePreferencesViewController];
}

-(void)displayViewController:(AMPreferencesBaseViewController*)vc
{
    vc.settingsType = AMSettingsTypeUserDefaults;
    NSView * contentView = self.window.contentView;
    NSWindow * window = self.window;
    NSRect oldWindowFrame = window.frame;
    NSView * newSubView = [vc view];
    NSRect requiredFrame = [newSubView frame];
    requiredFrame.size.height = requiredFrame.size.height + 40;
    requiredFrame.size.width = kAMMINPREFERENCEPANEWIDTH + 40;
    NSRect newWindowFrame = [window frameRectForContentRect:requiredFrame];
    newWindowFrame.origin.x = oldWindowFrame.origin.x;
    newWindowFrame.origin.y = oldWindowFrame.origin.y + oldWindowFrame.size.height - newWindowFrame.size.height;
    while (contentView.subviews.count > 0) {
        [contentView.subviews[0] removeFromSuperview];
    }
    [self.window setFrame:newWindowFrame display:YES animate:YES];

    [contentView addSubview:newSubView];
    [newSubView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:newSubView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:newSubView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [vc reloadData];
}


#pragma mark - NSToolbar delegate
// Nothing to do here yet


#pragma mark - NSWindow delegate
-(void)windowWillClose:(NSNotification *)notification
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}














@end
