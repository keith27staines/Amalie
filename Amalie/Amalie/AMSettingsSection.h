//
//  AMSettingsSection.h
//  Amalie
//
//  Created by Keith Staines on 03/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMConstants.h"

/*!
  Abstract base class representing a section of settings from AMUserPreferences or the document's persistent store. 
 
 Subclasses must override:
 1. The initWithFactoryDefaults method.
 2. The section method.
 3. The NSCoding and NSCopying interface methods.
 Note that the subclass should not call the base class implementation which will raise an exception.
 
 */

@interface AMSettingsSection : NSObject <NSCoding, NSCopying>

#pragma mark - Abstract methods that must be overridden in subclasses
/*! Designated initializer */
- (instancetype)initWithFactoryDefaults;
-(AMSettingsSectionType)section;

#pragma mark - Default implementations that should not be overridden in subclasses
+(id)settingsWithUserDefaults;
+(id)settingsWithFactoryDefaults;
+(id)settingsWithFactoryDefaultsOfType:(AMSettingsSectionType)sectionType;
+(id)settingsWithUserDefaultsOfType:(AMSettingsSectionType)sectionType;

- (instancetype)initWithUserDefaults;
- (NSData*)data;

@end
