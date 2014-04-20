//
//  AMFontPreferencesViewController.h
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMFontAttributes;

#import <Cocoa/Cocoa.h>
#import "AMConstants.h"
#import "AMFontChoiceView.h"
#import "AMPreferencesViewControllerBase.h"

@interface AMFontPreferencesViewController : AMPreferencesViewControllerBase <NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate, AMFontChoiceViewDataSource>

@property (weak) IBOutlet NSTableView *fontChoiceTable;


@property (weak) IBOutlet NSPopUpButton *fontSizeSelector;


- (IBAction)fontSizeChanged:(NSPopUpButton*)sender;







@end
