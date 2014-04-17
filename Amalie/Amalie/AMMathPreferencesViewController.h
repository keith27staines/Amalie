//
//  AMMathPreferencesViewController.h
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMExpressionNodeController;

#import <Cocoa/Cocoa.h>
#import "AMPreferencesViewControllerBase.h"
#import "AMNameProviderDelegate.h"

@interface AMMathPreferencesViewController : AMPreferencesViewControllerBase <AMNameProviderDelegate>

@property (weak) IBOutlet AMExpressionNodeController * expressionController;

- (IBAction)zoom:(NSSlider *)sender;

@property (weak) IBOutlet NSSlider *smallestFontSlider;

@property (weak) IBOutlet NSSlider *superscriptOffsetSlider;

@property (weak) IBOutlet NSSlider *subscriptOffsetSlider;

@property (weak) IBOutlet NSSlider *subscriptSizeSlider;

@property (weak) IBOutlet NSView *expressionContainerView;

@property (weak) IBOutlet NSTextField *smallestFontTextField;

@property (weak) IBOutlet NSTextField *superscriptOffsetTextField;

@property (weak) IBOutlet NSTextField *subscriptOffsetTextField;

@property (weak) IBOutlet NSTextField *subscriptSizeTextField;


- (IBAction)textChanged:(NSTextField *)sender;

- (IBAction)sliderChanged:(NSSlider *)sender;


@end
