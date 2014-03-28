//
//  AMColorPreferencesViewController.m
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMColorPreferencesViewController.h"
#import "AMDocumentSettings.h"
#import "AMColorSettings.h"
#import "AMColorPreference.h"
#import "AMPreferences.h"
#import "AMLibraryItem.h"
#import "AMColorPreferenceTableCellView.h"

@interface AMColorPreferencesViewController ()
{
    AMColorPreferencesType _colorPreferencesType;
    AMColorSettings * _colorSettings;
    AMDocumentSettings * _documentSettings;
    NSMutableArray * _colorPrefsArray;
}

@property (weak) IBOutlet NSTextField * objectLabel;

@property (weak) IBOutlet NSColorWell *backColorWell;

@property (weak) IBOutlet NSColorWell *textColorWell;


@end

@implementation AMColorPreferencesViewController

-(NSString *)nibName
{
    return @"AMColorPreferencesViewController";
}

-(NSView *)view
{
    NSView * view = [super view];
    if (!_colorSettings) {
        [self colorSettings];
    }
    return view;
}

-(AMDocumentSettings *)documentSettings
{
    return _documentSettings;
}
-(void)setDocumentSettings:(AMDocumentSettings *)documentSettings
{
    if (documentSettings == _documentSettings) {
        return;
    }
    if (_documentSettings) {
        [self saveColorSettings];
    }
    _documentSettings = documentSettings;
}
-(AMColorPreferencesType)colorPreferencesType
{
    return _colorPreferencesType;
}
-(void)setColorPreferencesType:(AMColorPreferencesType)colorPreferencesType
{
    [self saveColorSettings];
    _colorPreferencesType = colorPreferencesType;
}
-(void)saveColorSettings
{
    if (!_colorSettings) {
        // Nothing to save
        return;
    }
    if (_colorPreferencesType == AMColorPreferencesTypeFactorySettings) {
        // Can't save factory defaults so nothing to do here
    } else if (_colorPreferencesType == AMColorPreferencesTypeUserDefaults) {
        // Save to NSUserDefaults via AMPreferences
        [AMPreferences setColorSettings:_colorSettings];
    } else if (_colorPreferencesType == AMColorPreferencesTypeDocumentSettings) {
        if (self.documentSettings) {
            self.documentSettings.colorSettings = _colorSettings;
        }
    } else {
        NSAssert(NO, @"No saving mechanism for color preference type %li",_colorPreferencesType);
    }
}
-(AMColorSettings*)colorSettings
{
    if (_colorSettings) {
        return _colorSettings;
    }
    switch (self.colorPreferencesType) {
        case AMColorPreferencesTypeFactorySettings:
            _colorSettings = [AMColorSettings colorSettingsWithFactoryDefaults];
            break;
        case AMColorPreferencesTypeUserDefaults:
            _colorSettings = [AMColorSettings colorSettingsWithFactoryDefaults];
            break;
        case AMColorPreferencesTypeDocumentSettings:
            _colorSettings = self.documentSettings.colorSettings;
            break;
    }
    [self makeColorPreferenceDictionary];
    return _colorSettings;
}

-(void)makeColorPreferenceDictionary
{
    _colorPrefsArray = [NSMutableArray array];
    [self appendLibraryGroupToArray:_colorPrefsArray];
    [self appendNonLibraryGroupToArray:_colorPrefsArray];
    [self.colorPreferencesTable reloadData];
    [self enableColorwellsBySelection];
}
-(void)appendLibraryGroupToArray:(NSMutableArray*)target
{
    NSDictionary * source = self.colorSettings.libraryColorData;
    AMColorPreference * colorPreference = [[AMColorPreference alloc] init];
    colorPreference.title = NSLocalizedString(@"Colors for user-defined objects",@"Title for a section of color preferences devoted to user-defined objects");
    colorPreference.key = @"LibraryGroup";
    colorPreference.isGroupCell = YES;
    target[target.count] = colorPreference;
    for (NSString * key in source) {
        AMColorPreference * colorPreference = [[AMColorPreference alloc] init];
        AMLibraryItem * libraryItem = [AMLibraryItem libraryItemForLibraryItemKey:key withColorInfo:self.colorSettings];
        colorPreference.key = key;
        colorPreference.title = libraryItem.pluralisedName;
        colorPreference.backColor = libraryItem.backgroundColor;
        colorPreference.fontColor = libraryItem.fontColor;
        colorPreference.icon = libraryItem.icon;
        target[target.count] = colorPreference;
    }
}
-(void)appendNonLibraryGroupToArray:(NSMutableArray*)target
{
    NSDictionary * source = self.colorSettings.otherColorData;
    AMColorPreference * colorPreference = [[AMColorPreference alloc] init];
    colorPreference.title = NSLocalizedString(@"Colors for miscellaneous objects",@"Title for a section of color preferences devoted to miscellaneous objects");
    colorPreference.key = @"NonLibraryGroup";
    colorPreference.isGroupCell = YES;
    target[target.count] = colorPreference;
    for (NSString * key in source) {
        AMColorPreference * colorPreference = [[AMColorPreference alloc] init];
        colorPreference.key = key;
        NSDictionary * dataDictionary = source[key];
        if ([key isEqualToString:kAMDocumentBackgroundKey]) {
            colorPreference.title = NSLocalizedString(@"Background for document", @"Name for the area that frames the document - not the color of the document itself");
        }
        if ([key isEqualToString:kAMPaperKey]) {
            colorPreference.title = NSLocalizedString(@"Paper color", @"Paper color - the color for the paper on which the document is to appear");
        }
        colorPreference.backColor = colorFromData(dataDictionary[kAMBackColorKey]);
        colorPreference.fontColor = colorFromData(dataDictionary[kAMFontColorKey]);
        target[target.count] = colorPreference;
    }
}
- (IBAction)backColorChanged:(NSColorWell*)sender {
    [self setSelectedObjectBackColor:sender.color textColor:nil];
}
- (IBAction)textColorChanged:(NSColorWell *)sender {
    [self setSelectedObjectBackColor:nil textColor:sender.color];
}

- (IBAction)resetToFactoryDefaults:(NSButton *)sender {
}
- (IBAction)resetToDocumentDefaults:(NSButton *)sender {
}


-(void)setSelectedObjectBackColor:(NSColor*)backColor textColor:(NSColor*)textColor
{
    NSTableView * tableView = self.colorPreferencesTable;
    NSIndexSet * selectedRows = tableView.selectedRowIndexes;
    
    // Index sets don't allow fast enumeration
    [selectedRows enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        AMColorPreferenceTableCellView * view = [tableView viewAtColumn:0 row:idx makeIfNecessary:YES];
        if (backColor) {
            view.backColor = backColor;
        }
        if (textColor) {
            view.textColor = textColor;
        }
    }];
}

#pragma mark - NSTableView datasource -
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _colorPrefsArray.count;
}

-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    AMColorPreference * colorPreference = _colorPrefsArray[row];
    NSView * view;
    if (colorPreference.isGroupCell) {
        view = [tableView makeViewWithIdentifier:@"GroupHeaderView" owner:nil];
        NSTextField * textField = (NSTextField*)view;
        textField.stringValue = colorPreference.title;
    } else {
        view = [tableView makeViewWithIdentifier:@"ColorPreferenceView" owner:nil];
        AMColorPreferenceTableCellView * cellView = (AMColorPreferenceTableCellView*)view;
        cellView.colorPreference = colorPreference;
    }
    return view;
}

-(BOOL)isGroupRow:(NSUInteger)row
{
    AMColorPreference * colorPref = _colorPrefsArray[row];
    return colorPref.isGroupCell;
}

#pragma mark - NSTableView delegate

-(BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
    return [self isGroupRow:row];
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    if ([self isGroupRow:row]) {
        return 22;
    } else {
        return tableView.rowHeight;
    }
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
    [self enableColorwellsBySelection];
}

-(BOOL)tableView:(NSTableView*)tableView shouldSelectRow:(NSInteger)row
{
    AMColorPreference * colorPref = _colorPrefsArray[row];
    if (colorPref.isGroupCell) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - Table selection helpers -

-(void)enableColorwellsBySelection
{
    NSTableView * tableView = self.colorPreferencesTable;
    NSIndexSet * selectedRows = tableView.selectedRowIndexes;
    if (selectedRows.count == 0) {
        [self disabledColorwellsAndSetGray];
        self.objectLabel.stringValue = NSLocalizedString(@"Select an item in the  table to set its colors here", @"Indicates that the user needs to select an item shown in the color preferences table");
        return;
    }
    [self.backColorWell setEnabled:YES];
    [self.textColorWell setEnabled:YES];
    
    if (selectedRows.count == 1) {
        // Single row selected
        NSInteger row = tableView.selectedRow;
        AMColorPreference * colorPref = _colorPrefsArray[row];
        NSString * preamble = NSLocalizedString(@"Set colors for: ",@"Indicates that the user has selected a single object and can now set its colors. The name of the object will follow the ':'");
        self.objectLabel.stringValue = [preamble stringByAppendingString:colorPref.title];
        self.backColorWell.color = colorPref.backColor;
        self.textColorWell.color = colorPref.fontColor;
        return;
    } else {
        // Muliple rows selected
        self.objectLabel.stringValue = NSLocalizedString(@"Set color for: Multiple items", @"Indicates the user has selected multiple items in the colour preferences table and setting color will affect them all");
        self.backColorWell.color = [NSColor lightGrayColor];
        self.textColorWell.color = [NSColor lightGrayColor];
    }
}
-(void)disabledColorwellsAndSetGray
{
    [self.backColorWell setEnabled:NO];
    [self.textColorWell setEnabled:NO];
    self.backColorWell.color = [NSColor lightGrayColor];
    self.textColorWell.color = [NSColor lightGrayColor];
}






















@end
