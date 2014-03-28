//
//  AMColorPreferenceTableCellView.h
//  Amalie
//
//  Created by Keith Staines on 28/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMColorPreference;

#import <Cocoa/Cocoa.h>

@interface AMColorPreferenceTableCellView : NSTableCellView

@property AMColorPreference * colorPreference;
@property NSColor * backColor;
@property NSColor * textColor;

@end
