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
@property AMPaper * paper;
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
    [self.orientationView reloadData];
}
-(void)loadView
{
    [super loadView];
    [self populateUnitsButton];
    [self populatePaperTypeButton];
    [self updateDisplay];
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
    for ( NSString * paperName in [AMPaper paperNames] ) {
        name = [paperName stringByAppendingString:@" "];
        name = [name stringByAppendingString:[AMPaper paperSizeDescriptionForPaperType:counter withOrientation:self.paperOrientation inUnits:self.paperMeasurementUnits]];
        [btn addItemWithTitle:name];
        [btn itemAtIndex:counter].tag = counter;
        counter++;
    }
    [btn selectItemAtIndex:self.paperType];
}

- (IBAction)marginChanged:(id)sender {
}

-(void)customWidthChanged:(id)sender
{
}

#pragma mark - AMPageOrientationViewDatasource -
-(NSString *)paperName
{
    return self.paper.paperName;
}
-(NSString*)paperDescription
{
    return self.paper.paperDescription;
}
-(NSSize)paperSize
{
    return self.paper.paperSize;
}
-(AMPaperOrientation)paperOrientation
{
    return self.paper.paperOrientation;
}
-(AMMeasurementUnits)paperMeasurementUnits
{
    return self.paper.paperMeasurementUnits;
}
-(NSString*)paperOrientationName
{
    return self.paper.paperOrientationName;
}
-(AMMargins)paperMargins
{
    AMMargins margins;
    margins.top    = 2;
    margins.bottom = 2;
    margins.left   = 2;
    margins.right  = 2;
    return margins;
}
-(AMPaperType)paperType
{
    return self.paper.paperType;
}
-(AMPaper *)paper
{
    if (!_paper) {
        _paper = [AMPaper paperWithType:AMPaperTypeA4 orientation:AMPaperOrientationPortrait];
    }
    return _paper;
}
-(void)setPaper:(AMPaper *)paper
{
    _paper = paper;
}

- (IBAction)unitsChanged:(NSPopUpButton*)sender
{
    self.paper.paperMeasurementUnits = sender.selectedTag;
    [self populatePaperTypeButton];
}
- (IBAction)paperTypeChanged:(NSPopUpButton*)sender
{
    self.paper.paperType = sender.selectedTag;
}
@end
