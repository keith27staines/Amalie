//
//  AMDocumentSettingsBaseViewController.h
//  Amalie
//
//  Created by Keith Staines on 07/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMAmalieDocument, AMPreferencesBaseViewController;

#import <Cocoa/Cocoa.h>

@interface AMDocumentSettingsBaseViewController : NSViewController


@property (weak) AMAmalieDocument * document;

@property (weak) IBOutlet AMPreferencesBaseViewController *preferencesViewController;


@end
