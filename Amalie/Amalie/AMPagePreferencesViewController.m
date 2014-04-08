//
//  AMPagePreferencesViewController.m
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMPagePreferencesViewController.h"
#import "AMConstants.h"
#import "AMPageSettings.h"
#import "AMMeasurement.h"
#import "AMPageOrientationView.h"

@interface AMPagePreferencesViewController ()
{

}
@property (readonly) AMPageSettings * pageSettings;
@end

@implementation AMPagePreferencesViewController

#pragma mark - NSViewController overrides -
-(NSString *)nibName
{
    return @"AMPagePreferencesViewController";
}

#pragma mark - AMPreferencesBaseViewController overrides -

-(void)reloadData
{
    [super reloadData];
    [self populateUnitsButton];
    [self populatePaperTypeButton];
    [self populatePaperOrientationButton];
    [self populateMarginTextFields];
    [self enableCustomSizeControls];
    [self.orientationView reloadData];
    [self enableCustomSizeControls];
    [self.customWidthTextField setFloatValue:self.paperSize.width];
    [self.customHeightTextField setFloatValue:self.paperSize.height];
    [self configureFormatters];
    [self.view.window endEditingFor:nil];
    [self.view.window makeFirstResponder:self.view.window];
}

-(AMSettingsSectionType)sectionType
{
    return AMSettingsSectionPage;
}
/* Just a helpful cast */
-(AMPageSettings*)pageSettings
{
    return (AMPageSettings*)self.settingsSection;
}

#pragma mark - AMPageSetupViewControllerDelegate -
-(void)pageSetupViewController:(AMPageSetupViewController *)vc didUpdate:(AMPageSettings *)settings
{
    // TODO: add implementation
    //NSAssert(NO, @"Missing implementation");
}

#pragma mark - AMPagePreferencesViewController -

-(void)loadView
{
    [super loadView];
    [self reloadData];
}

-(NSArray*)numberFormatters
{
    return @[self.customWidthFormatter,
             self.customHeightFormatter,
             self.topMarginFormatter,
             self.bottomMarginFormatter,
             self.leftMarginFormatter,
             self.rightMarginFormatter];
}
-(void)configureFormatters
{
    for ( NSNumberFormatter * formatter in [self numberFormatters] ) {
        [self configureFormatterForUnits:formatter];
    }
    [self.leftMarginFormatter setMaximum:@(self.paperSize.width/2.0)];
    [self.rightMarginFormatter setMaximum:@(self.paperSize.width/2.0)];
    [self.topMarginFormatter setMaximum:@(self.paperSize.height/2.0)];
    [self.bottomMarginFormatter setMaximum:@(self.paperSize.height/2.0)];
}
-(void)configureFormatterForUnits:(NSNumberFormatter*)formatter
{
    NSString * suffix = [@" " stringByAppendingString:[AMMeasurement abbreviatedMameForUnitType:self.paperMeasurementUnits]];
    [formatter setMinimum:@(0)];
    [formatter setPositiveSuffix:suffix];
    [formatter setMinimum:@(0)];
    [formatter setLenient:YES];
    
    switch (self.paperMeasurementUnits) {
        case AMMeasurementUnitsPoints:
        {
            [formatter setPositiveFormat:@"%i"];
            [formatter setAllowsFloats:NO];
            break;
        }
        case AMMeasurementUnitsMillimeters:
        {
            [formatter setPositiveFormat:@"%i"];
            [formatter setAllowsFloats:NO];
            break;
        }
        case AMMeasurementUnitsCentimeters:
        {
            [formatter setAllowsFloats:YES];
            [formatter setMaximumFractionDigits:1];
            break;
        }
        case AMMeasurementUnitsInches:
        {
            [formatter setAllowsFloats:YES];
            [formatter setMaximumFractionDigits:2];
            break;
        }
    }
}
-(void)populateUnitsButton
{
    NSPopUpButton * btn = self.unitsPopupButton;
    [btn removeAllItems];
    NSUInteger counter = 0;
    for ( NSString * unitName in [AMMeasurement namesForUnitTypes] ) {
        [btn addItemWithTitle:unitName];
        [btn itemAtIndex:counter].tag = counter;
        counter++;
    }
    [btn selectItemAtIndex:self.paperMeasurementUnits];
}

-(void)populatePaperTypeButton
{
    NSPopUpButton * btn = self.paperTypePopupButton;
    [btn removeAllItems];
    NSUInteger counter = 0;
    NSString * name;
    NSString * customSizeDescription = [AMPageSettings paperSizeDescriptionForPaperWithPortraitSize:self.paperSize inOrientation:self.paperOrientation inUnits:self.paperMeasurementUnits];
    for ( NSString * paperName in [AMPageSettings paperNames] ) {
        name = [paperName stringByAppendingString:@" "];
        if (counter == AMPaperTypeCustom) {
            name = [name stringByAppendingString:customSizeDescription];
        } else {
            name = [name stringByAppendingString:[AMPageSettings paperSizeDescriptionForPaperType:counter withOrientation:self.paperOrientation inUnits:self.paperMeasurementUnits]];
        }
        [btn addItemWithTitle:name];
        [btn itemAtIndex:counter].tag = counter;
        counter++;
    }
    [btn selectItemAtIndex:self.paperType];
}
-(void)populatePaperOrientationButton
{
    NSPopUpButton * btn = self.orientationPopupButton;
    [btn removeAllItems];
    NSUInteger counter = 0;
    NSString * name;
    for ( NSString * orientationName in [AMPageSettings paperOrientationNames] ) {
        name = [orientationName capitalizedString];
        [btn addItemWithTitle:name];
        [btn itemAtIndex:counter].tag = counter;
        counter++;
    }
    [btn selectItemAtIndex:self.paperOrientation];
}
-(void)populateMarginTextFields
{
    AMMargins margins = [self.pageSettings marginsInUnits:self.paperMeasurementUnits];
    self.leftMarginTextField.floatValue    = margins.left;
    self.rightMarginTextField.floatValue   = margins.right;
    self.topMarginTextField.floatValue     = margins.top;
    self.bottomMarginTextField.floatValue  = margins.bottom;
}
#pragma mark - AMPageOrientationViewDatasource -
-(AMPaperType)paperType
{
    return self.pageSettings.paperType;
}
-(NSString *)paperName
{
    return self.pageSettings.paperName;
}
-(NSString*)paperDescription
{
    return self.pageSettings.paperDescription;
}
-(NSString *)paperWidthDescription
{
    return self.pageSettings.paperWidthDescription;
}
-(NSString*)paperHeightDescription
{
    return self.pageSettings.paperHeightDescription;
}
-(NSString*)paperSizeDescription
{
    return self.pageSettings.paperSizeDescription;
}
-(NSSize)paperSize
{
    return self.pageSettings.paperSize;
}
-(AMPaperOrientation)paperOrientation
{
    return self.pageSettings.paperOrientation;
}
-(NSString*)paperOrientationName
{
    return self.pageSettings.paperOrientationName;
}
-(AMMeasurementUnits)paperMeasurementUnits
{
    return self.pageSettings.paperMeasurementUnits;
}
-(AMMargins)paperMargins
{
    return [self.pageSettings marginsInUnits:self.paperMeasurementUnits];
}
-(void)enableCustomSizeControls
{
    BOOL enabled = (self.paperType == AMPaperTypeCustom);
    [self.customHeightTextField setEnabled:enabled];
    [self.customWidthTextField setEnabled:enabled];
    [self.customWidthLabel setEnabled:enabled];
    [self.customHeightLabel setEnabled:enabled];
    [self.exactSizeLabel setEnabled:enabled];
}
-(NSSize)customSizeFromView
{
    NSSize customSize = NSMakeSize(self.customWidthTextField.floatValue, self.customHeightTextField.floatValue);
    customSize = [AMMeasurement convertSize:customSize fromUnits:self.paperMeasurementUnits toUnits:AMMeasurementUnitsPoints];
    return customSize;
}
-(void)setPaperType:(AMPaperType)paperType
{
    if (paperType == self.paperType) {
        return;
    }
    if (paperType == AMPaperTypeCustom) {
        [self setCustomSize:[AMPageSettings paperSizeForPaperType:self.paperType withOrientation:AMPaperOrientationPortrait inUnits:AMMeasurementUnitsPoints]];
    } else {
        self.pageSettings.paperType = paperType;
    }
    [self pageDidUpdate];
    [self reloadData];
}
-(void)setCustomSize:(NSSize)size
{
    [self pageDidUpdate];
    [self.pageSettings makeCustomPortraitWidth:size.width portraitHeight:size.height];
}
-(void)setPaperOrientation:(AMPaperOrientation)paperOrientation
{
    self.pageSettings.paperOrientation = paperOrientation;
    [self pageDidUpdate];
    [self reloadData];
}
-(void)setPaperMeasurementUnits:(AMMeasurementUnits)units
{
    self.pageSettings.paperMeasurementUnits = units;
    [self pageDidUpdate];
    [self reloadData];
}
-(void)setMargins
{
    AMMargins margins = [self marginsFromView];
    [self.pageSettings setMargins:margins inUnits:self.paperMeasurementUnits];
    [self pageDidUpdate];
    [self reloadData];
}
-(AMMargins)marginsFromView
{
    AMMargins margins;
    margins.top = self.topMarginTextField.floatValue;
    margins.bottom = self.bottomMarginTextField.floatValue;
    margins.left = self.leftMarginTextField.floatValue;
    margins.right = self.rightMarginTextField.floatValue;
    return margins;
}
#pragma mark - Actions -
- (IBAction)marginChanged:(id)sender {
    [self setMargins];
}
-(void)customSizeChanged:(id)sender
{
    [self setCustomSize:[self customSizeFromView]];
}
- (IBAction)orientationChanged:(NSPopUpButton *)sender {
    [self setPaperOrientation:sender.selectedTag];
}
- (IBAction)paperTypeChanged:(NSPopUpButton*)sender
{
    [self setPaperType:sender.selectedTag];
}
- (IBAction)unitsChanged:(NSPopUpButton*)sender
{
    [self setPaperMeasurementUnits:sender.selectedTag];
}

#pragma mark - NSControl Delegate -
-(BOOL)control:(NSControl *)control didFailToFormatString:(NSString *)string errorDescription:(NSString *)error
{
    return NO;
}

#pragma mark - Inform delegate that paper did update-
-(void)pageDidUpdate
{
    // TODO: Add implementation
    //[self.delegate pageSetupViewController:self didUpdate:self.pageSettings];
}






















@end
