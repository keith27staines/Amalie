//
//  AMPreferencesWindowController.h
//  Amalie
//
//  Created by Keith Staines on 07/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AMTrayDatasource.h"

@interface AMPreferencesWindowController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate>
{

}

@property (weak) IBOutlet NSTextField *textFontName;

-(IBAction)changedFontName:(NSTextField *)sender;

@property (weak) IBOutlet NSTextField *textNormalFontSize;

-(IBAction)changedNormalFontSize:(NSTextField *)sender;

@property (weak) IBOutlet NSTextField *textFontSizeDelta;

-(IBAction)changedFontSizeDelta:(NSTextField *)sender;

@property (weak) IBOutlet NSTextField *textSmallestFontSize;

-(IBAction)changedSmallestFontSize:(NSTextField *)sender;


@property (weak) IBOutlet NSTextField *textFixedWidthFontName;

-(IBAction)changedFixedWidthFontName:(NSTextField *)sender;

@property (weak) IBOutlet NSTextField *textFixedWidthFontSize;

- (IBAction)changedFixedWidthFontSize:(id)sender;


@property (weak) id<AMTrayDataSource>trayDatasource;

@end
