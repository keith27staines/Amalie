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
#import "AMPreferencesBaseView.h"

static CGFloat const kAMMINPREFERENCEPANEWIDTH = 900;  // minimum pane width in points

@interface AMUserPreferencesWindowController ()
@property (strong, readonly) AMUserPreferences * preferences;
@property (weak) AMPreferencesBaseViewController * displayedViewController;

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
    [self showPageView:nil];
}

-(void)showColorsView:(id)sender
{
    self.window.title = NSLocalizedString(@"Color preferences for new documents", @"Window title for user preferences panel dedicated to the colors of various displayed objects");
    [self displayViewController:self.colorPreferencesViewController];
}
-(void)showFontsView:(id)sender
{
    self.window.title = NSLocalizedString(@"Font preferences for new documents", @"Window title for user preferences panel dedicated to font settings");
    [self displayViewController:self.fontPreferencesViewController];
}
-(void)showMathView:(id)sender
{
    self.window.title = NSLocalizedString(@"Mathematical style preferences for new documents",@"Window title for user preferences panel dedicated to mathematical style settings");
    [self displayViewController:self.mathPreferencesViewController];
}
-(void)showPageView:(id)sender
{
    self.window.title = NSLocalizedString(@"Page settings for new documents",@"Window title for user preferences panel dedicated to page setup");
    [self displayViewController:self.pagePreferencesViewController];
}

-(void)displayViewController:(AMPreferencesBaseViewController*)vc
{
    if (vc == self.displayedViewController) {
        return;
    }
    if (self.displayedViewController) {
        [self.displayedViewController saveSettingsSection];
    }
    self.displayedViewController = vc;
    vc.settingsStorageLocationType = AMSettingsStorageLocationTypeUserDefaults;
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
        NSView * view = contentView.subviews[0];
        [view removeFromSuperview];
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
    [self.displayedViewController saveSettingsSection];
    [[NSUserDefaults standardUserDefaults] synchronize];
}














@end
