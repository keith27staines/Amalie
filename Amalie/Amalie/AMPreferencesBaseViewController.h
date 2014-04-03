//
//  AMPreferencesBaseViewController.h
//  Amalie
//
//  Created by Keith Staines on 05/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//


@class AMDocumentSettings;

#import <Cocoa/Cocoa.h>
#import "AMConstants.h"

@protocol AMUserPreferencesViewControlling <NSObject>

-(void)reloadData;

@end

@interface AMPreferencesBaseViewController : NSViewController <AMUserPreferencesViewControlling>

@property AMSettingsType settingsType;

@property AMDocumentSettings * documentSettings;

/*! saveSettings method must be overridden to save settings in appropriate format */
-(void)saveSettings;

@end
