//
//  AMColorSetupViewController.h
//  Amalie
//
//  Created by Keith Staines on 21/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMAmalieDocument,AMColorPreferencesViewController;

#import <Cocoa/Cocoa.h>

@interface AMColorSetupViewController : NSViewController

@property (weak) AMAmalieDocument * document;

@property (weak) IBOutlet AMColorPreferencesViewController *colorPreferenceViewController;

@end
