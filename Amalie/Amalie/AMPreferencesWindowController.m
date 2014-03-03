//
//  AMPreferencesWindowController.m
//  Amalie
//
//  Created by Keith Staines on 07/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMPreferencesWindowController.h"
#import "AMConstants.h"
#import "AMAppController.h"
#import "AMPreferences.h"
#import "AMTrayItem.h"

#import "AMColorUserPreferencesViewController.h"
#import "AMFontUserPreferencesViewController.h"
#import "AMMathUserPreferencesViewController.h"
#import "AMPageUserPreferencesViewController.h"


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
    [self displayViewController:self.colorPreferencesViewController];
}
-(void)showFontsView:(id)sender
{
    [self displayViewController:self.fontPreferencesViewController];
}
-(void)showMathView:(id)sender
{
    [self displayViewController:self.mathPreferencesViewController];
}
-(void)showPageView:(id)sender
{
    [self displayViewController:self.pagePreferencesViewController];
}

-(void)displayViewController:(NSViewController*)vc
{
    if (!self.placeholderView) {
        self.placeholderView = self.window.contentView;
    }
    NSWindow * window = self.window;
    NSRect oldWindowFrame = window.frame;
    NSView * newContentView = [vc view];
    NSLog(@"View width:%f",newContentView.frame.size.width);
    NSRect newWindowFrame = [window frameRectForContentRect:newContentView.frame];
    newWindowFrame.origin.x = oldWindowFrame.origin.x;
    newWindowFrame.origin.y = oldWindowFrame.origin.y + oldWindowFrame.size.height - newWindowFrame.size.height;
    [window setContentView:self.placeholderView];
    [self.window setFrame:newWindowFrame display:YES animate:YES];
    [window setContentView:newContentView];
}


#pragma mark - NSToolbar delegate
// Nothing to do here yet



















@end
