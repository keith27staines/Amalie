//
//  AMFontUserPreferencesViewController.h
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AMFontUserPreferencesViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate>

@property (weak) IBOutlet NSTableView *fontChoiceTable;

@property (weak) IBOutlet NSTextField *fontSize;





@property (weak) IBOutlet NSTextField *fontSizeTextFieldChanged;












@end
