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
#import "AMLibraryItem.h"
#import "AMInsertableView.h"

NSString * const kAMPreferencesWindowNibName = @"AMPreferencesWindow";

@interface AMAppController()
{
    AMPreferencesWindowController * _preferencesWindowController;
}

@property (strong,readonly) AMPreferencesWindowController * preferencesWindowController;

@end

@implementation AMAppController

- (IBAction)showPreferencesPanel:(id)sender {
    
    if (!_preferencesWindowController) {
        _preferencesWindowController = [[AMPreferencesWindowController alloc] initWithWindowNibName:kAMPreferencesWindowNibName];
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
}

// Called before any other method of this class
+(void)initialize
{
    [AMPreferences registerDefaultPreferences];
}

-(void)applicationWillTerminateNotification:(NSNotification*)notification
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}



@end
