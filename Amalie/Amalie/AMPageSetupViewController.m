//
//  AMPageSetupViewController.m
//  Amalie
//
//  Created by Keith Staines on 20/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMPageSetupViewController.h"
#import "AMPaper.h"
#import "AMMeasurement.h"
#import "AMPageOrientationView.h"
#import "AMPreferences.h"

@interface AMPageSetupViewController ()
{
    AMPaper * _paper;
}
@end

@implementation AMPageSetupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(NSString *)nibName
{
    return @"AMPageSetupViewController";
}
-(void)updateDisplay
{
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
-(void)loadView
{
    [super loadView];
    [self updateDisplay];
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
    NSString * customSizeDescription = [AMPaper paperSizeDescriptionForPaperWithPortraitSize:self.paperSize inOrientation:self.paperOrientation inUnits:self.paperMeasurementUnits];
    for ( NSString * paperName in [AMPaper paperNames] ) {
        name = [paperName stringByAppendingString:@" "];
        if (counter == AMPaperTypeCustom) {
            name = [name stringByAppendingString:customSizeDescription];
        } else {
            name = [name stringByAppendingString:[AMPaper paperSizeDescriptionForPaperType:counter withOrientation:self.paperOrientation inUnits:self.paperMeasurementUnits]];
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
    for ( NSString * orientationName in [AMPaper paperOrientationNames] ) {
        name = [orientationName capitalizedString];
        [btn addItemWithTitle:name];
        [btn itemAtIndex:counter].tag = counter;
        counter++;
    }
    [btn selectItemAtIndex:self.paperOrientation];
}
-(void)populateMarginTextFields
{
    AMMargins margins = [self.paper marginsInUnits:self.paperMeasurementUnits];
    self.leftMarginTextField.floatValue    = margins.left;
    self.rightMarginTextField.floatValue   = margins.right;
    self.topMarginTextField.floatValue     = margins.top;
    self.bottomMarginTextField.floatValue  = margins.bottom;
}
#pragma mark - AMPageOrientationViewDatasource -
-(AMPaperType)paperType
{
    return self.paper.paperType;
}
-(NSString *)paperName
{
    return self.paper.paperName;
}
-(NSString*)paperDescription
{
    return self.paper.paperDescription;
}
-(NSString *)paperWidthDescription
{
    return self.paper.paperWidthDescription;
}
-(NSString*)paperHeightDescription
{
    return self.paper.paperHeightDescription;
}
-(NSString*)paperSizeDescription
{
    return self.paper.paperSizeDescription;
}
-(NSSize)paperSize
{
    return self.paper.paperSize;
}
-(AMPaperOrientation)paperOrientation
{
    return self.paper.paperOrientation;
}
-(NSString*)paperOrientationName
{
    return self.paper.paperOrientationName;
}
-(AMMeasurementUnits)paperMeasurementUnits
{
    return self.paper.paperMeasurementUnits;
}
-(AMMargins)paperMargins
{
    return [self.paper marginsInUnits:self.paperMeasurementUnits];
}
-(AMPaper *)paper
{
    if (!_paper) {
        _paper = [[AMPaper alloc] init];
    }
    return _paper;
}
-(void)setPaper:(AMPaper *)paper
{
    _paper = paper;
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
        [self setCustomSize:[AMPaper paperSizeForPaperType:self.paperType withOrientation:AMPaperOrientationPortrait inUnits:AMMeasurementUnitsPoints]];
    } else {
        self.paper.paperType = paperType;
    }
    [self updateDisplay];
}
-(void)setCustomSize:(NSSize)size
{
    [self.paper makeCustomPortraitWidth:size.width portraitHeight:size.height];
}
-(void)setPaperOrientation:(AMPaperOrientation)paperOrientation
{
    self.paper.paperOrientation = paperOrientation;
    [self updateDisplay];
}
-(void)setPaperMeasurementUnits:(AMMeasurementUnits)units
{
    self.paper.paperMeasurementUnits = units;
    [self updateDisplay];
}
-(void)setMargins
{
    AMMargins margins = [self marginsFromView];
    [self.paper setMargins:margins inUnits:self.paperMeasurementUnits];
    [self updateDisplay];
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

#pragma mark - Delegate -
-(BOOL)control:(NSControl *)control didFailToFormatString:(NSString *)string errorDescription:(NSString *)error
{
    return NO;
}
@end
