//
//  AMDocumentSettingsBase.m
//  
//
//  Created by Keith Staines on 16/04/2014.
//
//

#import "AMDocumentSettingsBase.h"
#import "AMPageSettings.h"
#import "AMFontSettings.h"
#import "AMColorSettings.h"
#import "AMMathStyleSettings.h"

@implementation AMDocumentSettingsBase

+(id)documentSettingsFromFactoryDefaults
{
    AMDocumentSettingsBase * documentSettings = [[self.class alloc] init];
    [documentSettings resetToFactoryDefaults];
    return documentSettings;
}
+(id)documentSettingsFromUserDefaults
{
    AMDocumentSettingsBase * documentSettings = [[self.class alloc] init];
    [documentSettings resetToUserDefaults];
    return documentSettings;
}
-(void)resetToUserDefaults
{
    self.pageSettings      = [AMPageSettings settingsWithUserDefaults];
    self.fontSettings      = [AMFontSettings settingsWithUserDefaults];
    self.colorSettings     = [AMColorSettings settingsWithUserDefaults];
    self.mathStyleSettings = [AMMathStyleSettings settingsWithUserDefaults];
}
-(void)resetToFactoryDefaults
{
    self.pageSettings      = [AMPageSettings settingsWithFactoryDefaults];
    self.fontSettings      = [AMFontSettings settingsWithFactoryDefaults];
    self.colorSettings     = [AMColorSettings settingsWithFactoryDefaults];
    self.mathStyleSettings = [AMMathStyleSettings settingsWithFactoryDefaults];
}
-(AMSettingsSection*)settingsForSection:(AMSettingsSectionType)section
{
    switch (section) {
        case AMSettingsSectionFonts:
            return self.fontSettings;
        case AMSettingsSectionColors:
            return self.colorSettings;
        case AMSettingsSectionPage:
            return self.pageSettings;
        case AMSettingsSectionMathsStyle:
            return self.mathStyleSettings;
    }
}
-(void)setSettings:(AMSettingsSection *)settings
{
    switch (settings.section) {
        case AMSettingsSectionFonts:
            self.fontSettings = (AMFontSettings*)settings;
            break;
        case AMSettingsSectionColors:
            self.colorSettings = (AMColorSettings*)settings;
            break;
        case AMSettingsSectionPage:
            self.pageSettings = (AMPageSettings*)settings;
            break;
        case AMSettingsSectionMathsStyle:
            self.mathStyleSettings = (AMMathStyleSettings*)settings;
            break;
    }
}

#pragma mark - NSCopying -
-(id)copyWithZone:(NSZone *)zone
{
    AMDocumentSettingsBase * copy = [self.class documentSettingsFromUserDefaults];
    copy.pageSettings      = self.pageSettings;
    copy.fontSettings      = self.fontSettings;
    copy.colorSettings     = self.colorSettings;
    copy.mathStyleSettings = self.mathStyleSettings;
    return copy;
}
@end
