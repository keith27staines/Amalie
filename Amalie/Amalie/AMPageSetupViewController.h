//
//  AMPageSetupViewController.h
//  Amalie
//
//  Created by Keith Staines on 20/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMPageOrientationView, AMPageSettings;

#import <Cocoa/Cocoa.h>
#import "AMConstants.h"
#import "AMPageSetupDatasource.h"
#import "AMPageSetupViewControllerDelegate.h"

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

@interface AMPageSetupViewController : NSViewController <AMPageSetupDatasource, NSControlTextEditingDelegate>
@property id<AMPageSetupViewControllerDelegate>delegate;
@property AMPageSettings * pageSettings;

#pragma mark - Page orientation
- (IBAction)orientationChanged:(NSPopUpButton *)sender;
@property (weak) IBOutlet NSPopUpButton *orientationPopupButton;

#pragma mark - paper visualisation view
@property (weak) IBOutlet AMPageOrientationView *orientationView;

#pragma mark - Paper type and units outlets and actions
- (IBAction)unitsChanged:(NSPopUpButton*)sender;
- (IBAction)paperTypeChanged:(NSPopUpButton*)sender;
@property (weak) IBOutlet NSPopUpButton *unitsPopupButton;
@property (weak) IBOutlet NSPopUpButton *paperTypePopupButton;

#pragma mark - Document margins outlets and actions
- (IBAction)marginChanged:(id)sender;
@property (weak) IBOutlet NSTextField *topMarginTextField;
@property (weak) IBOutlet NSTextField *bottomMarginTextField;
@property (weak) IBOutlet NSTextField *leftMarginTextField;
@property (weak) IBOutlet NSTextField *rightMarginTextField;

#pragma mark - Custom width and height outlets and actions
- (IBAction)customSizeChanged:(id)sender;
@property (weak) IBOutlet NSTextField *customWidthTextField;
@property (weak) IBOutlet NSTextField *customHeightTextField;
@property (weak) IBOutlet NSTextField *customWidthLabel;
@property (weak) IBOutlet NSTextField *customHeightLabel;
@property (weak) IBOutlet NSTextField *exactSizeLabel;

@property (weak) IBOutlet NSNumberFormatter *customWidthFormatter;

@property (weak) IBOutlet NSNumberFormatter *customHeightFormatter;

@property (weak) IBOutlet NSNumberFormatter *topMarginFormatter;

@property (weak) IBOutlet NSNumberFormatter *bottomMarginFormatter;

@property (weak) IBOutlet NSNumberFormatter *leftMarginFormatter;

@property (weak) IBOutlet NSNumberFormatter *rightMarginFormatter;

































@end
