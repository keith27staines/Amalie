//
//  AMMathPreferencesViewController.h
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMExpressionContentView;

#import <Cocoa/Cocoa.h>
#import "AMPreferencesBaseViewController.h"
#import "AMNameProviderDelegate.h"

@interface AMMathPreferencesViewController : AMPreferencesBaseViewController <AMNameProviderDelegate>


@property (weak) IBOutlet NSView *expressionContainer;

@property (weak) IBOutlet NSSlider *smallestFontSlider;

@property (weak) IBOutlet NSSlider *superscriptOffsetSlider;

@property (weak) IBOutlet NSSlider *subscriptOffsetSlider;

@property (weak) IBOutlet NSSlider *subscriptSizeSlider;

@property (weak) IBOutlet NSView *expressionContainerView;

@property (weak) IBOutlet AMExpressionContentView *expressionView;

@property (weak) IBOutlet NSTextField *smallestFontTextField;

@property (weak) IBOutlet NSTextField *superscriptOffsetTextField;

@property (weak) IBOutlet NSTextField *subscriptOffsetTextField;

@property (weak) IBOutlet NSTextField *subscriptSizeTextField;


- (IBAction)textChanged:(NSTextField *)sender;

- (IBAction)sliderChanged:(NSSlider *)sender;




@end
