//
//  AMDocumentSettingsBaseViewController.h
//  Amalie
//
//  Created by Keith Staines on 07/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMDocumentSettingsBase, AMPreferencesViewControllerBase,AMSettingsSection;

#import <Cocoa/Cocoa.h>
#import "AMConstants.h"

@interface AMDocumentSettingsBaseViewController : NSViewController


@property (weak) AMDocumentSettingsBase * documentSettings;

@property (weak) IBOutlet AMPreferencesViewControllerBase *preferencesViewController;
-(AMSettingsSectionType)settingsSectionType;
-(void)saveControlledSettingsSection;
-(AMSettingsSection*)controlledSettingsSection;

@end
