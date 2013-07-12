//
//  AMAppController.m
//  Amalie
//
//  Created by Keith Staines on 07/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMAppController.h"
#import "AMPreferences.h"
#import "AMPreferencesWindowController.h"
#import "AMConstants.h"
#import "AMTrayItem.h"

NSString * const kAMPreferencesWindowNibName = @"AMPreferencesWindow";
NSMutableDictionary * _trayDictionary;

@interface AMAppController()
{
    AMPreferencesWindowController * _preferencesController;
}

@property (strong,readonly) AMPreferencesWindowController * preferencesController;

@end

@implementation AMAppController

- (IBAction)showPreferencesPanel:(id)sender {
    
    if (!_preferencesController) {
        _preferencesController = [[AMPreferencesWindowController alloc] initWithWindowNibName:kAMPreferencesWindowNibName];
        [_preferencesController setTrayDatasource:self];
    }
    [_preferencesController showWindow:self];
}

// Called before any other method of this class
+(void)initialize
{
    [AMPreferences registerDefaultPreferences];
}

#pragma mark -Implementation of AMTrayDatasourceProtocol-

-(NSUInteger)trayItemCount
{
    return [[self dictionaryOfAllTrayItems] count];
}

-(void)mergeTrayPreferences
{
    NSDictionary * trayPreferences = [[AMPreferences defaults] objectForKey:kAMTrayDictionaryKey];
    
    for (NSString * key in trayPreferences) {
        
        NSDictionary * itemPreferences = trayPreferences[key];
        AMTrayItem * item = [self dictionaryOfAllTrayItems][key];

        item.backgroundColor = colorFromData( itemPreferences[kAMBackColorKey] );
        item.fontColor = colorFromData( itemPreferences[kAMFontColorKey] );
    }
}

-(NSDictionary*)dictionaryOfAllTrayItems
{
    if (!_trayDictionary) {
        
        _trayDictionary = [NSMutableDictionary dictionary];
        
        NSDictionary * trayPreferences = [[AMPreferences defaults] objectForKey:kAMTrayDictionaryKey];
        
        for (NSString * key in trayPreferences) {
            NSDictionary * itemPreferences = trayPreferences[key];
            AMTrayItem * item;
            NSString * title = [self StringByStrippingKeyPrefixAndSuffix:key];
            NSString * iconKey = title;
            NSString * description = title;
            NSColor * backgroundColor = colorFromData(itemPreferences[kAMBackColorKey]);
            NSColor * fontColor = colorFromData(itemPreferences[kAMFontColorKey]);
            item = [[AMTrayItem alloc] initWithKey:key
                                           iconKey:iconKey
                                             title:title
                                       info:description
                                   backgroundColor:backgroundColor
                                         fontColor:fontColor];
            [_trayDictionary setObject:item forKey:key];
        }
    }
    return _trayDictionary;
}

-(AMTrayItem*)trayItemAtIndex:(NSUInteger)index
{
    return [self arrayOfAllTrayItems][index];
}

-(NSArray*)arrayOfAllTrayItems
{
    return [[self dictionaryOfAllTrayItems] allValues];
}

-(NSString*)StringByStrippingKeyPrefixAndSuffix:(NSString*)string
{
    NSString * affix = [string substringFromIndex:([string length] - 3)];
    if ([affix isEqualToString:kAMKeySuffix]) {
        string = [string substringToIndex:([string length] - 3)];
    }
    affix = [string substringToIndex:[kAMKeyPrefix length]];
    if ([affix isEqualToString:kAMKeyPrefix]) {
        string = [string substringFromIndex:[kAMKeyPrefix length]];
    }
    
    return string;
}

@end
