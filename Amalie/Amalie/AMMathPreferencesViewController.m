//
//  AMMathPreferencesViewController.m
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMMathPreferencesViewController.h"
#import "AMMathStyleSettings.h"
#import "AMPersistentDocumentSettings.h"
#import "AMFontSettings.h"

@interface AMMathPreferencesViewController ()
{

}
@property (readonly) AMMathStyleSettings * mathStyleSettings;

@end


@implementation AMMathPreferencesViewController

- (void)configureNumberFormatters
{
    if (!self.smallestFontTextField) {
        return;
    }
    NSArray * numberFormatters = @[self.smallestFontTextField.formatter,
                                   self.subscriptOffsetTextField.formatter,
                                   self.superscriptOffsetTextField.formatter,
                                   self.subscriptSizeTextField.formatter];
    for (NSNumberFormatter * formatter in numberFormatters) {
        [formatter setNumberStyle:NSNumberFormatterPercentStyle];
        [formatter setMaximumFractionDigits:0];
        [formatter setLenient:YES];
    }
}

- (void)configureSliders
{
    [self.smallestFontSlider      setContinuous:YES];
    [self.superscriptOffsetSlider setContinuous:YES];
    [self.subscriptOffsetSlider   setContinuous:YES];
    [self.subscriptSizeSlider     setContinuous:YES];
}
-(void)awakeFromNib
{
    [self configureSliders];
    [self configureNumberFormatters];
    [self reloadData];
}
-(NSString *)nibName
{
    return @"AMMathPreferencesViewController";
}
-(AMSettingsSectionType)sectionType
{
    return AMSettingsSectionMathsStyle;
}
-(void)reloadData
{
    [super reloadData];
    AMMathStyleSettings * style = self.mathStyleSettings;
    self.smallestFontSlider.floatValue         = style.smallestFontSizeFraction  * 100.0;
    self.superscriptOffsetSlider.floatValue    = style.superscriptOffsetFraction * 100.0;
    self.subscriptOffsetSlider.floatValue      = style.subscriptOffsetFraction   * 100.0;
    self.subscriptSizeSlider.floatValue        = style.superscriptingFraction    * 100.0;
    
    self.smallestFontTextField.floatValue      = style.smallestFontSizeFraction;
    self.subscriptOffsetTextField.floatValue   = style.subscriptOffsetFraction;
    self.superscriptOffsetTextField.floatValue = style.superscriptOffsetFraction;
    self.subscriptSizeTextField.floatValue     = style.superscriptingFraction;
}
- (IBAction)textChanged:(NSTextField *)sender {
    AMMathStyleSettings * style = self.mathStyleSettings;
    if (sender == self.smallestFontTextField) {
        style.smallestFontSizeFraction = sender.floatValue;
    } else if (sender == self.subscriptOffsetTextField) {
        style.subscriptOffsetFraction = sender.floatValue;
    } else if (sender == self.superscriptOffsetTextField) {
        style.superscriptOffsetFraction = sender.floatValue;
    } else if (sender == self.subscriptSizeTextField) {
        style.superscriptingFraction = sender.floatValue;
    }
    [self reloadData];
}
- (IBAction)sliderChanged:(NSSlider *)sender {
    AMMathStyleSettings * style = self.mathStyleSettings;
    if (sender == self.smallestFontSlider) {
        style.smallestFontSizeFraction = sender.floatValue /100.0;
    } else if (sender == self.subscriptOffsetSlider) {
        style.subscriptOffsetFraction = sender.floatValue / 100.0;
    } else if (sender == self.superscriptOffsetSlider) {
        style.superscriptOffsetFraction = sender.floatValue / 100.0;
    } else if (sender == self.subscriptSizeSlider) {
        style.superscriptingFraction = sender.floatValue / 100.0;
    }
    [self reloadData];
}

-(AMMathStyleSettings*)mathStyleSettings
{
    return (AMMathStyleSettings*)self.settingsSection;
}

#pragma mark - AMNameProviderDelegate -
-(CGFloat)subscriptOffset
{
    return self.mathStyleSettings.subscriptOffsetFraction;
}
-(CGFloat)smallestFontSize
{
    return self.mathStyleSettings.smallestFontSizeFraction * [self baseFontSize];
}
-(AMFontAttributes *)fontAttributesForType:(AMFontType)fontType
{
    return [self.documentSettings.fontSettings fontAttributesForFontType:fontType];
}
-(CGFloat)superscriptingFraction
{
    return self.mathStyleSettings.superscriptingFraction;
}
-(CGFloat)superscriptOffset
{
    return self.mathStyleSettings.superscriptOffsetFraction;
}
-(CGFloat)baseFontSize
{
    return [self.documentSettings.fontSettings fontSize];
}
@end
