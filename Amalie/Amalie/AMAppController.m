//
//  AMAppController.m
//  Amalie
//
//  Created by Keith Staines on 07/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMAppController.h"
#import "AMUserPreferences.h"
#import "AMUserPreferencesWindowController.h"
#import "AMConstants.h"
#import "AMLibraryItem.h"
#import "AMInsertableView.h"
#import "AMUserPreferences.h"

NSString * const kAMPreferencesWindowNibName = @"AMUserPreferencesWindow";

@interface AMAppController()
{
    AMUserPreferencesWindowController * _preferencesWindowController;
    BOOL _doneAppClosingCleanup;
}

@property (strong,readonly) AMUserPreferencesWindowController * preferencesWindowController;

@end

@implementation AMAppController

- (IBAction)resetAllUserPreferences:(id)sender
{
    [AMUserPreferences resetSettingsForSection:AMSettingsSectionColors];
    [AMUserPreferences resetSettingsForSection:AMSettingsSectionFonts];
    [AMUserPreferences resetSettingsForSection:AMSettingsSectionMathsStyle];
    [AMUserPreferences resetSettingsForSection:AMSettingsSectionPage];
}

- (IBAction)showPreferencesPanel:(id)sender {
    
    if (!_preferencesWindowController) {
        _preferencesWindowController = [[AMUserPreferencesWindowController alloc] initWithWindowNibName:kAMPreferencesWindowNibName];
    }
    [_preferencesWindowController showWindow:self];
}

-(void)awakeFromNib
{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(applicationWillTerminateNotification:)
               name:NSApplicationWillTerminateNotification
             object:nil];
    _doneAppClosingCleanup = NO;
}

// Called before any other method of this class
+(void)initialize
{
    [AMUserPreferences registerDefaultPreferences];
}

-(void)applicationWillTerminateNotification:(NSNotification*)notification
{
    [self doAppClosingCleanup];
}

-(void)dealloc
{
    [self doAppClosingCleanup];
}

-(void)doAppClosingCleanup
{
    if (_doneAppClosingCleanup) {
        return;
    }
    _doneAppClosingCleanup = YES;
    BOOL saveResult = [[NSUserDefaults standardUserDefaults] synchronize];
    NSAssert(saveResult, @"Failed to synchronise user defaults on app exit");
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}


@end
