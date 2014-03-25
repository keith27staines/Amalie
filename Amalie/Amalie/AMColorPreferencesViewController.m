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

@interface AMColorPreferencesViewController ()
{
    AMColorPreferencesType _colorPreferencesType;
    AMColorSettings * _colorSettings;
    AMDocumentSettings * _documentSettings;
    NSMutableDictionary * _colorPrefsDictionary;
    NSArray * _colorPrefsArray;
}
@end

@implementation AMColorPreferencesViewController

-(NSString *)nibName
{
    return @"AMColorPreferencesViewController";
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
    _colorPrefsDictionary = [NSMutableDictionary dictionary];
    [self appendGroupFromColorDataDictionary:self.colorSettings.libraryColorData toDictionary:_colorPrefsDictionary withGroupTitleKey:kAMLibraryObjectsKey];
    [self appendGroupFromColorDataDictionary:self.colorSettings.otherColorData toDictionary:_colorPrefsDictionary withGroupTitleKey:kAMNonLibraryObjectsKey];
    _colorPrefsArray = [_colorPrefsDictionary allValues];
}
-(void)appendGroupFromColorDataDictionary:(NSDictionary*)source toDictionary:(NSMutableDictionary*)target withGroupTitleKey:(NSString*)groupKey
{
    AMColorPreference * colorPreference = [[AMColorPreference alloc] init];
    colorPreference.key = groupKey;
    colorPreference.isGroupCell = YES;
    target[groupKey] = colorPreference;
    for (NSString * key in source) {
        NSDictionary * dataDictionary = source[key];
        AMColorPreference * colorPreference = [[AMColorPreference alloc] init];
        colorPreference.key = key;
        colorPreference.title = key;
        colorPreference.backColor = dataDictionary[kAMBackColorKey];
        colorPreference.fontColor = dataDictionary[kAMFontColorKey];
        target[key] = colorPreference;
    }
}

#pragma mark - NSTableView datasource -
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _colorPrefsDictionary.count;
}

-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    AMColorPreference * colorPreference = _colorPrefsArray[row];
    if (colorPreference.isGroupCell) {
        
    } else {
        
    }
    return nil;
}

#pragma mark - NSTableView delegate
























@end
