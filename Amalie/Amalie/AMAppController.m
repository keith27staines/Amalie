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

NSString * const kAMPreferencesWindowNibName = @"AMPreferencesWindow";

@interface AMAppController()
{
    AMPreferencesWindowController * _preferencesController;
}

@property (strong,readonly) AMPreferencesWindowController * preferencesController;

@end

@implementation AMAppController

- (IBAction)showPreferencesPanel:(id)sender {
}

-(NSImage*)iconForTrayItemWithName:(NSString*)trayItemKey
{
    return [AMAppController iconForTrayItemWithName:trayItemKey];
}

-(NSUInteger)trayRowCount
{
    return [AMAppController trayRowCount];
}

-(NSDictionary*)dictionaryOfTrayRows
{
    return [AMAppController dictionaryOfTrayRows];
}

-(NSArray*)arrayOfTrayRows
{
    return [AMAppController arrayOfTrayRows];
}


+(NSUInteger)trayRowCount
{
    return [[self dictionaryOfTrayRows] count];
}

+(NSArray*)arrayOfTrayRows
{
    return [[self dictionaryOfTrayRows] allValues];
}

+(NSDictionary*)dictionaryOfTrayRows
{
    return [[AMPreferences defaults] objectForKey:kAMTrayDictionaryKey];
}

+(void)initialize
{
    [AMPreferences registerDefaultPreferences];
}


+(NSImage*)iconForTrayItemWithName:(NSString*)trayItemKey
{
    NSString * resource = trayItemKey;
    NSString * lastThreeLetters = [trayItemKey substringFromIndex:[trayItemKey length] - [kAMKeySuffix length]];
    if ( [lastThreeLetters isEqualToString:kAMKeySuffix] ) {
        resource = [trayItemKey substringToIndex:[trayItemKey length] - [kAMKeySuffix length]];
    }
    NSImage * image = [[NSBundle mainBundle] imageForResource:resource];
    return image;
}

@end
