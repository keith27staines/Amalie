//
//  AMAppController.m
//  Amalie
//
//  Created by Keith Staines on 07/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMConstants.h"
#import "AMAppController.h"
#import "AMPreferencesWindowController.h"

NSString * const kAMPreferencesWindowNibName = @"AMPreferencesWindow";



@interface AMAppController()
{
    AMPreferencesWindowController * _preferencesController;
}

@end

@implementation AMAppController

-(AMPreferencesWindowController*)preferencesController
{
    if (!_preferencesController) {
        _preferencesController = [[AMPreferencesWindowController alloc] initWithWindowNibName:kAMPreferencesWindowNibName];
    }
    return _preferencesController;
}

-(IBAction) showPreferencesPanel:(id)sender
{
    [self.preferencesController showWindow:self];
}

+(void)initialize
{
    [AMPreferencesWindowController registerDefaultPreferences];
}


@end
