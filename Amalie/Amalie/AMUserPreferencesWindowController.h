//
//  AMUserPreferencesWindowController.h
//  Amalie
//
//  Created by Keith Staines on 07/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMColorPreferencesViewController;
@class AMFontPreferencesViewController;
@class AMPagePreferencesViewController;
@class AMMathPreferencesViewController;

#import <Cocoa/Cocoa.h>
#import "AMLibraryDataSource.h"

@interface AMUserPreferencesWindowController : NSWindowController <NSToolbarDelegate,NSWindowDelegate>

- (IBAction)showColorsView:(id)sender;
- (IBAction)showFontsView:(id)sender;
- (IBAction)showPageView:(id)sender;
- (IBAction)showMathView:(id)sender;


@property (weak) IBOutlet NSToolbarItem *showPageButton;
@property (weak) IBOutlet NSToolbarItem *showFontsButton;
@property (weak) IBOutlet NSToolbarItem *showColorsButton;
@property (weak) IBOutlet NSToolbarItem *showmathsButton;


@property (weak) IBOutlet AMColorPreferencesViewController *colorPreferencesViewController;

@property (weak) IBOutlet AMFontPreferencesViewController *fontPreferencesViewController;

@property (weak) IBOutlet AMPagePreferencesViewController *pagePreferencesViewController;

@property (weak) IBOutlet AMMathPreferencesViewController * mathPreferencesViewController;


@end
