//
//  AMPreferencesWindowController.h
//  Amalie
//
//  Created by Keith Staines on 07/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AMConstants.h"

@interface AMPreferencesWindowController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate>
{
    IBOutlet NSTableView * trayObjects;
}

@property (weak) IBOutlet NSTextField *textNormalFontSize;

@property (weak) IBOutlet NSTextField *textFontSizeDelta;

@property (weak) IBOutlet NSTextField *textSmallestFontSize;

@property (weak) IBOutlet NSTextField *textFixedWidthFontName;

@property (weak) IBOutlet NSTextField *textFontName;


-(IBAction)changedNormalFontSize:(NSTextField *)sender;
-(IBAction)changedFontSizeDelta:(NSTextField *)sender;
-(IBAction)changedSmallestFontSize:(NSTextField *)sender;
-(IBAction)changedFixedWidthFontName:(NSTextField *)sender;
-(IBAction)changedFontName:(NSTextField *)sender;


+(void)registerDefaultPreferences;

+(NSColor*)worksheetBackgroundColor;
+(NSUInteger)worksheetFontSize;
+(NSUInteger)worksheetFontDelta;
+(NSUInteger)worksheetSmallestFontSize;
+(NSString*)worksheetFontName;
+(NSString*)worksheetFixedWidthFontName;
+(void)setWorksheetBackgroundColor:(NSColor*)colour;
+(void)setWorksheetFontSize:(NSUInteger)size;
+(void)setWorksheetFontDelta:(NSUInteger)delta;
+(void)setWorksheetSmallestFontSize:(NSUInteger)size;
+(void)setWorksheetFontName:(NSString*)fontName;
+(void)setWorksheetFixedWidthFontName:(NSString*)fontName;


@end
