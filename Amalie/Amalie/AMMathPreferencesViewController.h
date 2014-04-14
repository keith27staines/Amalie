//
//  AMMathPreferencesViewController.h
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AMPreferencesBaseViewController.h"


@interface AMMathPreferencesViewController : AMPreferencesBaseViewController

@property (weak) IBOutlet NSView *expressionContainer;

@property (weak) IBOutlet NSSlider *smallestFontSlider;

@property (weak) IBOutlet NSSlider *superscriptOffsetSlider;

@property (weak) IBOutlet NSSlider *subscriptOffsetSlider;

@property (weak) IBOutlet NSTextField *smallestFontTextField;

@property (weak) IBOutlet NSTextField *superscriptOffsetTextField;

@property (weak) IBOutlet NSTextField *subscriptOffsetTextField;

- (IBAction)textChanged:(NSTextField *)sender;

- (IBAction)sliderChanged:(NSSlider *)sender;

@end
