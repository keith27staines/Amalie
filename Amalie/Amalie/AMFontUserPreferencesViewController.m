//
//  AMFontUserPreferencesViewController.m
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMFontUserPreferencesViewController.h"
#import "AMPreferences.h"
#import "AMFontChoiceView.h"
#import "AMConstants.h"
#import "AMFontAttributes.h"
#import "AMFontText.h"
#import "AMFontSelectionViewController.h"

@interface AMFontUserPreferencesViewController ()

@property (strong) IBOutlet NSPopover *fontSelectionViewController;

@end

@implementation AMFontUserPreferencesViewController

-(NSString *)nibName
{
    return @"AMFontUserPreferencesViewController";
}

-(void)awakeFromNib
{
    [self populateFontSizePopup];
}
-(void)populateFontSizePopup
{
    NSPopUpButton * btn = self.fontSizeSelector;
    [btn removeAllItems];
    NSMenu * menu = btn.menu;
    for (int i = (int)[AMPreferences smallestFontSize]; i < 21; i++) {
        [self addFontsizeMenuItemForSize:i toMenu:menu];
    }
    for (int i = 22; i < 42; i += 2) {
        [self addFontsizeMenuItemForSize:i toMenu:menu];
    }
    for (int i = 45; i < 75; i += 5) {
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

-(void)reloadData
{
    [self.fontChoiceTable reloadData];
    [self synchronizeMasterFontSizeControl];
}

-(void)synchronizeMasterFontSizeControl
{
    NSPopUpButton * btn = self.fontSizeSelector;
    [btn selectItemWithTag:(int)[AMPreferences fontSize]];
}

#pragma mark - Preferences updates
- (IBAction)fontSizeChanged:(NSPopUpButton*)sender {
    [AMPreferences setFontSize:sender.selectedTag];
}

-(IBAction)restoreToFactoryDefaults:(NSButton *)button
{
    [AMPreferences resetAll];
    [self reloadData];
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
    return [AMPreferences fontAttributesForFontType:view.fontType];
}
-(void)attributesUpdatedForFontChoiceView:(AMFontChoiceView*)view
{
    [AMPreferences setFontAttributes:view.fontAttributes forFontType:view.fontType];
}
-(void)restoreFactoryDefaultsForFontChoiceView:(AMFontChoiceView*)view
{
    [AMPreferences resetFontAttributesForFontType:view.fontType];
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
