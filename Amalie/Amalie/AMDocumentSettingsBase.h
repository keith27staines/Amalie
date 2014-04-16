//
//  AMDocumentSettingsBase.h
//  
//
//  Created by Keith Staines on 16/04/2014.
//
//

@class AMColorSettings, AMFontSettings, AMMathStyleSettings, AMPageSettings, AMSettingsSection;


#import <Foundation/Foundation.h>
#import "AMConstants.h"

@interface AMDocumentSettingsBase : NSObject <NSCopying>

+(id)documentSettingsFromFactoryDefaults;
+(id)documentSettingsFromUserDefaults;

#pragma mark - Getters and setters for user preference sections
-(AMSettingsSection*)settingsForSection:(AMSettingsSectionType)section;
-(void)setSettings:(AMSettingsSection*)settings;

#pragma mark - Settings for paper, fonts and colors
@property (copy) AMFontSettings      * fontSettings;
@property (copy) AMColorSettings     * colorSettings;
@property (copy) AMPageSettings      * pageSettings;
@property (copy) AMMathStyleSettings * mathStyleSettings;

#pragma mark - reset
-(void)resetToUserDefaults;
-(void)resetToFactoryDefaults;

@end
