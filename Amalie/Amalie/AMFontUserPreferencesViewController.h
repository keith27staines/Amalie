//
//  AMFontUserPreferencesViewController.h
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMFontAttributes;

#import <Cocoa/Cocoa.h>
#import "AMConstants.h"
#import "AMFontChoiceView.h"
#import "AMUserPreferencesBaseViewController.h"

@interface AMFontUserPreferencesViewController : AMUserPreferencesBaseViewController <NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate, AMFontChoiceViewDatasource>

@property (weak) IBOutlet NSTableView *fontChoiceTable;


@property (weak) IBOutlet NSPopUpButton *fontSizeSelector;


- (IBAction)fontSizeChanged:(NSPopUpButton*)sender;


- (IBAction)restoreToFactoryDefaults:(NSButton*)button;

-(void)reloadData;






@end
