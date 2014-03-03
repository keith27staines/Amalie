//
//  AMPreferencesWindowController.h
//  Amalie
//
//  Created by Keith Staines on 07/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMColorUserPreferencesViewController;
@class AMFontUserPreferencesViewController;
@class AMPageUserPreferencesViewController;
@class AMMathUserPreferencesViewController;

#import <Cocoa/Cocoa.h>
#import "AMTrayDatasource.h"

@interface AMPreferencesWindowController : NSWindowController <NSToolbarDelegate>

@property (weak) id<AMTrayDataSource>trayDatasource;

- (IBAction)showColorsView:(id)sender;
- (IBAction)showFontsView:(id)sender;
- (IBAction)showPageView:(id)sender;
- (IBAction)showMathView:(id)sender;


@property (weak) IBOutlet NSToolbarItem *showPageButton;
@property (weak) IBOutlet NSToolbarItem *showFontsButton;
@property (weak) IBOutlet NSToolbarItem *showColorsButton;
@property (weak) IBOutlet NSToolbarItem *showmathsButton;


@property (strong) IBOutlet AMColorUserPreferencesViewController *colorPreferencesViewController;

@property (strong) IBOutlet AMFontUserPreferencesViewController *fontPreferencesViewController;

@property (strong) IBOutlet AMPageUserPreferencesViewController *pagePreferencesViewController;

@property (strong) IBOutlet AMMathUserPreferencesViewController * mathPreferencesViewController;


@end
