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

@property (weak) IBOutlet NSPopUpButton *unitsPopupButton;

@property (weak) IBOutlet NSPopUpButton *paperTypePopupButton;

@property (weak) IBOutlet NSTextField *topMarginPopupButton;

@property (weak) IBOutlet NSTextField *bottomMarginPopupButton;

@property (weak) IBOutlet NSTextField *leftMarginPopupButton;

@property (weak) IBOutlet NSTextField *rightMarginPopupButton;

@property (weak) IBOutlet AMPageOrientationView *orientationView;

- (IBAction)unitsChanged:(NSPopUpButton*)sender;

- (IBAction)paperTypeChanged:(NSPopUpButton*)sender;

- (IBAction)marginChanged:(id)sender;

- (IBAction)customWidthChanged:(id)sender;









@end
