//
//  AMPageSetupViewController.h
//  Amalie
//
//  Created by Keith Staines on 20/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMAmalieDocument, AMPagePreferencesViewController;

#import <Cocoa/Cocoa.h>


@interface AMPageSetupViewController : NSViewController

@property (weak) AMAmalieDocument * document;

@property (weak) IBOutlet AMPagePreferencesViewController *pagePreferencesViewController;
































@end
