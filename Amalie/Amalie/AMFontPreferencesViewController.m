//
//  AMFontPreferencesViewController.m
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMFontPreferencesViewController.h"
#import "AMUserPreferences.h"
#import "AMFontChoiceView.h"
#import "AMConstants.h"
#import "AMFontAttributes.h"
#import "AMFontText.h"
#import "AMFontSelectionViewController.h"
#import "AMFontSettings.h"

@interface AMFontPreferencesViewController ()

@property (strong) IBOutlet NSPopover *fontSelectionViewController;

@property (readonly) AMFontSettings * fontSettings;

@end

@implementation AMFontPreferencesViewController

-(NSString *)nibName
{
    return @"AMFontPreferencesViewController";
}

-(void)awakeFromNib
{
    [self populateFontSizePopup];
}


#pragma mark - AMPreferencesBaseViewController overrides -

-(void)reloadData
{
    [super reloadData];
    [self.fontChoiceTable reloadData];
    [self synchronizeMasterFontSizeControl];
}

-(AMSettingsSectionType)sectionType
{
    return AMSettingsSectionFonts;
}

/* Just a helpful cast */
-(AMFontSettings*)fontSettings
{
    return (AMFontSettings*)self.settingsSection;
}

#pragma mark - data loading helpers -

-(void)populateFontSizePopup
{
    NSPopUpButton * btn = self.fontSizeSelector;
    [btn removeAllItems];
    NSMenu * menu = btn.menu;
    for (int i = 4; i < 20; i++) {
        [self addFontsizeMenuItemForSize:i toMenu:menu];
    }
    for (int i = 20; i < 40; i += 2) {
        [self addFontsizeMenuItemForSize:i toMenu:menu];
    }
    for (int i = 40; i < 75; i += 5) {
        [self addFontsizeMenuItemForSize:i toMenu:menu];
    }
}
-(void)addFontsizeMenuItemForSize:(int)i toMenu:(NSMenu*)menu
{
    NSMenuItem * item = [[NSMenuItem alloc] init];
    item.title = [NSString stringWithFormat:@"%i pt",i];
    item.tag = i;
    [menu addItem:item];
}

-(void)synchronizeMasterFontSizeControl
{
    NSPopUpButton * btn = self.fontSizeSelector;
    [btn selectItemWithTag:(int)self.fontSettings.fontSize];
}

#pragma mark - Preferences updates
- (IBAction)fontSizeChanged:(NSPopUpButton*)sender {
    [self.fontSettings setFontSize:sender.selectedTag];
}

#pragma mark - NSTableView datasource
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return AMFontTypeMax + 1;
}

#pragma mark - NSTableView delegate
-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    AMFontChoiceView * view = (AMFontChoiceView*)[self.fontChoiceTable makeViewWithIdentifier:@"fontChoiceColumn" owner:nil];
    view.fontType = row;
    [view setDatasource:self];
    [view reloadData];
    return view;
}

#pragma mark - AMFontChoiceView datasource

-(AMFontAttributes*)fontAttributesForFontChoiceView:(AMFontChoiceView*)view
{
    return [self.fontSettings fontAttributesForFontType:view.fontType];
}
-(void)attributesUpdatedForFontChoiceView:(AMFontChoiceView*)view
{
    [self.fontSettings setFontAttributes:view.fontAttributes forFontType:view.fontType];
}
-(void)restoreFactoryDefaultsForFontChoiceView:(AMFontChoiceView*)view
{
    // TODO: reset font attributes for font type view.fontType
    //[AMUserPreferences resetFontAttributesForFontType:view.fontType];
}
-(NSString *)localizedFontUsageDescriptionForFontChoiceView:(AMFontChoiceView *)view
{
    switch (view.fontType) {
        case AMFontTypeLiteral:
        {
            return NSLocalizedString(@"Literal numbers (e.g, 1, 1.5, etc)",nil);
        }
        case AMFontTypeAlgebra:
        {
            return NSLocalizedString(@"Constants, variables, and function names",nil);
        }
        case AMFontTypeMatrix:
        {
            return NSLocalizedString(@"Matrices",nil);
        }
        case AMFontTypeVector:
        {
            return NSLocalizedString(@"Vectors",nil);
        }
        case AMFontTypeFixedWidth:
        {
            return NSLocalizedString(@"Fixed width text (e.g., editing expressions)",nil);
        }
        case AMFontTypeSymbol:
        {
            return NSLocalizedString(@"Greek and mathematical symbols",nil);
        }
        case AMFontTypeText:
        {
            return NSLocalizedString(@"Normal text",nil);
        }
    }
}


@end
