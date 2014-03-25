//
//  AMPreferencesWindowController.m
//  Amalie
//
//  Created by Keith Staines on 07/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMPreferencesWindowController.h"
#import "AMConstants.h"
#import "AMPreferences.h"

#import "AMColorPreferencesViewController.h"
#import "AMFontUserPreferencesViewController.h"
#import "AMMathUserPreferencesViewController.h"
#import "AMPageUserPreferencesViewController.h"
#import "AMUserPreferencesBaseViewController.h"

@interface AMPreferencesWindowController ()
@property NSView * placeholderView;
@property (strong, readonly) AMPreferences * preferences;

@end

typedef NS_ENUM(NSUInteger,AMUserPreferencesView) {
    AMUserPreferencesViewFonts,
    AMUserPreferencesViewColors,
    AMUserPreferencesViewPage,
    AMUserPreferencesViewMath,
};

@implementation AMPreferencesWindowController

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

-(void)displayViewController:(AMUserPreferencesBaseViewController*)vc
{
    if (!self.placeholderView) {
        self.placeholderView = self.window.contentView;
    }
    NSWindow * window = self.window;
    NSRect oldWindowFrame = window.frame;
    NSView * newContentView = [vc view];
    NSRect newWindowFrame = [window frameRectForContentRect:newContentView.frame];
    newWindowFrame.origin.x = oldWindowFrame.origin.x;
    newWindowFrame.origin.y = oldWindowFrame.origin.y + oldWindowFrame.size.height - newWindowFrame.size.height;
    [window setContentView:self.placeholderView];
    [newContentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.window setFrame:newWindowFrame display:YES animate:YES];
    [vc reloadData];
    [window setContentView:newContentView];
}


#pragma mark - NSToolbar delegate
// Nothing to do here yet


#pragma mark - NSWindow delegate
-(void)windowWillClose:(NSNotification *)notification
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}














@end
