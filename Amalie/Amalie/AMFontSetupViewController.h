//
//  AMFontSetupViewController.h
//  Amalie
//
//  Created by Keith Staines on 21/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMAmalieDocument, AMFontPreferencesViewController;

#import <Cocoa/Cocoa.h>

@interface AMFontSetupViewController : NSViewController

@property (weak) AMAmalieDocument * document;

@property (weak) IBOutlet AMFontPreferencesViewController *fontPreferenceViewController;

@end
