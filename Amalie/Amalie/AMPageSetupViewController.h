//
//  AMPageSetupViewController.h
//  Amalie
//
//  Created by Keith Staines on 20/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMPageOrientationView;

#import <Cocoa/Cocoa.h>
#import "AMConstants.h"
#import "AMPageSetupDatasource.h"

typedef NS_ENUM(NSUInteger,AMMarginTags)
{
    AMMarginTagsTop    = 0,
    AMMarginTagsBottom = 1,
    AMMarginTagsLeft   = 2,
    AMMarginTagsRight  = 3
};

typedef NS_ENUM(NSUInteger, AMCustomSizeTags) {
    AMCustomSizeTagsWidth  = 0,
    AMCustomSizeTagsHeight = 1,
};

typedef NS_ENUM(NSUInteger, AMUnits) {
    AMUnitsPoints      = 0,
    AMUnitsCentimeters = 1,
    AMUnitsMillimeters = 2,
};

@interface AMPageSetupViewController : NSViewController <AMPageSetupDatasource>

#pragma mark - Page orientation view
@property (weak) IBOutlet AMPageOrientationView *orientationView;

#pragma mark - Paper type and units outlets and actions
- (IBAction)unitsChanged:(NSPopUpButton*)sender;
- (IBAction)paperTypeChanged:(NSPopUpButton*)sender;
@property (weak) IBOutlet NSPopUpButton *unitsPopupButton;
@property (weak) IBOutlet NSPopUpButton *paperTypePopupButton;

#pragma mark - Document margins outlets and actions
- (IBAction)marginChanged:(id)sender;
@property (weak) IBOutlet NSTextField *topMarginPopupButton;
@property (weak) IBOutlet NSTextField *bottomMarginPopupButton;
@property (weak) IBOutlet NSTextField *leftMarginPopupButton;
@property (weak) IBOutlet NSTextField *rightMarginPopupButton;

#pragma mark - Custom width and height outlets and actions
- (IBAction)customWidthChanged:(id)sender;
@property (weak) IBOutlet NSTextField *customWidthTextField;
@property (weak) IBOutlet NSTextField *customHeightTextField;
@property (weak) IBOutlet NSStepper *customWidthStepperButton;
@property (weak) IBOutlet NSStepper *customHeightStepperButton;






@end
