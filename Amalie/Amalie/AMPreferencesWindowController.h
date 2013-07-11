//
//  AMPreferencesWindowController.h
//  Amalie
//
//  Created by Keith Staines on 07/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AMTrayDatasourceProtocol.h"

@interface AMPreferencesWindowController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate>
{

}

@property (weak) IBOutlet NSTextField *textNormalFontSize;

@property (weak) IBOutlet NSTextField *textFontSizeDelta;

@property (weak) IBOutlet NSTextField *textSmallestFontSize;

@property (weak) IBOutlet NSTextField *textFixedWidthFontName;

@property (weak) IBOutlet NSTextField *textFontName;

@property (weak) IBOutlet NSTextField *textFixedWidthFontSize;

-(IBAction)changedNormalFontSize:(NSTextField *)sender;
-(IBAction)changedFontSizeDelta:(NSTextField *)sender;
-(IBAction)changedSmallestFontSize:(NSTextField *)sender;
-(IBAction)changedFixedWidthFontName:(NSTextField *)sender;
-(IBAction)changedFontName:(NSTextField *)sender;

@property (weak) id<AMTrayDatasourceProtocol>trayDatasource;

@end
