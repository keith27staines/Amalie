//
//  AMPreferencesWindowController.m
//  Amalie
//
//  Created by Keith Staines on 07/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMPreferencesWindowController.h"
#import "AMConstants.h"
#import "AMAppController.h"
#import "AMPreferencesTrayTableColorwellCellView.h"
#import "AMPreferences.h"

@interface AMPreferencesWindowController ()

@property (strong, readonly) AMPreferences * preferences;

@end

@implementation AMPreferencesWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.

    }
    
    return self;
}

// Fixed-width font size
- (IBAction)changedFixedWidthFontSize:(NSTextField *)sender
{
    NSUInteger size = ceil([sender doubleValue]);
    [AMPreferences setWorksheetFixedWidthFontSize:size];
}

// Normal font size
-(IBAction)changedNormalFontSize:(NSTextField *)sender
{
    NSUInteger size = ceil([sender doubleValue]);
    [AMPreferences setWorksheetFontSize:size];
}

// Font size delta
-(IBAction)changedFontSizeDelta:(NSTextField *)sender
{
    NSUInteger size = ceil([sender doubleValue]);
    [AMPreferences setWorksheetFontDelta:size];
}
// Smallest font
-(IBAction)changedSmallestFontSize:(NSTextField *)sender
{
    NSUInteger size = ceil([sender doubleValue]);
    [AMPreferences setWorksheetSmallestFontSize:size];
}

// Fixed width font name
-(IBAction)changedFixedWidthFontName:(NSTextField *)sender
{
    NSString * str = [sender stringValue];
    [AMPreferences setWorksheetFixedWidthFontName:str];
}

// Normal font name
-(IBAction)changedFontName:(NSTextField *)sender
{
    NSString * str = [sender stringValue];
    [AMPreferences setWorksheetFontName:str];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    NSNumber * size;
    NSString * strSize;
    NSString * name;
    
    // smallest font
    size = [AMPreferences objectForKey:kAMMinFontSizeKey];
    strSize = [NSString stringWithFormat:@"%ld",(long)[size integerValue]];
    self.textSmallestFontSize.stringValue = strSize;
    
    // font delta
    size = [AMPreferences objectForKey:kAMFontSizeDeltaKey];
    strSize = [NSString stringWithFormat:@"%ld",(long)[size integerValue]];
    self.textFontSizeDelta.stringValue = strSize;

    // Normal font size
    size = [AMPreferences objectForKey:kAMFontSizeKey];
    strSize = [NSString stringWithFormat:@"%ld",(long)[size integerValue]];
    self.textNormalFontSize.stringValue = strSize;
    
    // Fixed width font size
    size = [AMPreferences objectForKey:kAMFixedWidthFontSizeKey];
    strSize = [NSString stringWithFormat:@"%ld",(long)[size integerValue]];
    self.textFixedWidthFontSize.stringValue = strSize;
    
    // Normal font name
    name = [AMPreferences objectForKey:kAMFontNameKey];
    self.textFontName.stringValue = name;

    // Fixed width font name
    name = [AMPreferences objectForKey:kAMFixedWidthFontNameKey];
    self.textFixedWidthFontName.stringValue = name;

}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    // which table are we dealing with?
    if ( [aTableView.identifier isEqualToString:kAMTrayDictionaryKey] ) {
        return [AMAppController trayRowCount];
    }
    return 0;
}

-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{

    NSTableCellView * view = nil;
    AMPreferencesTrayTableColorWellCellView * colorWellView = nil;
    
    // which table are we dealing with?
    if ( [tableView.identifier isEqualToString:kAMTrayDictionaryKey] ) {

        // We are populating the tray objects table. We will use the table row
        // to index into the _tray dictionary to obtain the row's content
        NSDictionary * trayRow = [AMAppController arrayOfTrayRows][row];
        
        // Ask the table to make us a nice view to hold the content
        view = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];

        if ( [tableColumn.identifier isEqualToString:kAMTrayItemIconKey] ) {
            
            // This column has an icon and a title in a single cell
            [view.imageView setImage:[trayRow objectForKey:kAMTrayItemIconKey]];
            [view.textField setStringValue:[trayRow objectForKey:kAMTrayItemTitleKey]];
            return view;
        
        } else if ( [tableColumn.identifier isEqualToString:kAMTrayItemBackcolorKey] ) {
            
            // View just holds a color well and we need to set its color
            NSData * colorData = [trayRow objectForKey:kAMTrayItemBackcolorKey];
            NSColor * color = colorFromData(colorData);
            colorWellView = (AMPreferencesTrayTableColorWellCellView*)view;
            [colorWellView.colorWell setColor:color];
            return colorWellView;
        
        } else if ( [tableColumn.identifier isEqualToString:kAMTrayItemFontColorKey] ) {
            
            // View just holds a color well and we need to set its color
            NSData * colorData = [trayRow objectForKey:kAMTrayItemFontColorKey];
            NSColor * color = colorFromData(colorData);
            colorWellView = (AMPreferencesTrayTableColorWellCellView*)view;
            [colorWellView.colorWell setColor:color];
            return colorWellView;
        }
        
        NSAssert(NO, @"Failed to find a view for the view-based table.");
        return nil;

    }

    return nil;
}

#pragma mark - C helper functions -


NSColor * colorFromData(NSData* data)
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}
@end
