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
NSDictionary * _trayDictionary;

@interface AMAppController()
{
    AMPreferencesWindowController * _preferencesController;
}

@property (strong,readonly) AMPreferencesWindowController * preferencesController;

@end

@implementation AMAppController

- (IBAction)showPreferencesPanel:(id)sender {
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

-(NSDictionary*)dictionaryOfAllTrayItems
{
    if (!_trayDictionary) {
        
        NSDictionary * trayPreferences = [[AMPreferences defaults] objectForKey:kAMTrayDictionaryKey];
        
        for (NSString * key in trayPreferences) {
            AMTrayItem * item;
            NSString * title = key;
            NSString * iconKey = key;
            NSString * description = title;
            item = [[AMTrayItem alloc] initWithKey:key
                                           iconKey:iconKey
                                             title:title
                                       description:description
                                   backgroundColor:trayPreferences[kAMTrayItemBackcolorKey]
                                         fontColor:trayPreferences[kAMTrayItemFontColorKey]];
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

@end
