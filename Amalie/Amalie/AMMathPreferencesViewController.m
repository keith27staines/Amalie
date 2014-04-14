//
//  AMMathPreferencesViewController.m
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMMathPreferencesViewController.h"
#import "AMMathStyleSettings.h"

@interface AMMathPreferencesViewController ()

@property (readonly) AMMathStyleSettings * mathStyleSettings;

@end

@implementation AMMathPreferencesViewController

-(void)awakeFromNib
{
    [self.smallestFontSlider setContinuous:YES];
    [self.superscriptOffsetSlider setContinuous:YES];
    [self.subscriptOffsetSlider setContinuous:YES];
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
    self.smallestFontSlider.floatValue = [self pointSizeAsPercentage:style.smallestFontSize];
    self.superscriptOffsetSlider.floatValue = style.superscriptOffset * 100;
    self.subscriptOffsetSlider.floatValue = style.subscriptOffset * 100;
    
    self.smallestFontTextField.floatValue = [self pointSizeAsPercentage:style.smallestFontSize];;
    self.subscriptOffsetTextField.floatValue = style.subscriptOffset * 100;
    self.superscriptOffsetTextField.floatValue = style.superscriptOffset * 100;
}

- (IBAction)textChanged:(NSTextField *)sender {
    AMMathStyleSettings * style = self.mathStyleSettings;
    if (sender == self.smallestFontTextField) {
        style.smallestFontSize = [self percentageToPointSize:self.smallestFontTextField.floatValue];
    } else if (sender == self.subscriptOffsetTextField) {
        style.subscriptOffset = sender.floatValue / 100.0;
    } else if (sender == self.superscriptOffsetTextField) {
        style.superscriptOffset = sender.floatValue / 100.0;
    }
    [self reloadData];
}

- (IBAction)sliderChanged:(NSSlider *)sender {
    AMMathStyleSettings * style = self.mathStyleSettings;
    if (sender == self.smallestFontSlider) {
        style.smallestFontSize = [self percentageToPointSize:self.smallestFontSlider.floatValue];
    } else if (sender == self.subscriptOffsetSlider) {
        style.subscriptOffset = sender.floatValue / 100.0;
    } else if (sender == self.superscriptOffsetSlider) {
        style.superscriptOffset = sender.floatValue / 100;
    }
    [self reloadData];
}

-(AMMathStyleSettings*)mathStyleSettings
{
    return (AMMathStyleSettings*)self.settingsSection;
}
-(CGFloat)baseFontSize
{
    return 48;
}
-(CGFloat)pointSizeAsPercentage:(CGFloat)pointSize
{
    return pointSize / [self baseFontSize] * 100.0;
}
-(CGFloat)percentageToPointSize:(CGFloat)percentage
{
    return percentage * [self baseFontSize] / 100.0;
}

@end
