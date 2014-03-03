//
//  AMFontChoiceView.h
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AMFontChoiceView : NSView

@property (readonly) NSTextField * fontUsage;

@property (readonly) NSTextField * fontFamilyName;

@property (readonly) NSButton * fontPickerButton;

@property (readonly) NSButton * boldButton;

@property (readonly) NSButton * italicButton;

@property (readonly) NSButton * restoreButton;

@end
