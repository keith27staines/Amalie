//
//  AMAppController.h
//  Amalie
//
//  Created by Keith Staines on 07/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

extern NSString* const kAMPreferencesWindowController;

extern NSString * const kAMPreferencesWindowNibName;
extern NSString * const kAMDefaultFixedWidthFontName;
extern NSString * const kAMDefaultFontName;

extern NSString * const kAMPreferencesWorksheetFontSizeKey;
extern NSString * const kAMPreferencesWorksheetFontSizeDeltaKey;
extern NSString * const kAMPreferencesWorksheetBackColorKey;
extern NSString * const kAMPreferencesWorksheetPaperSizeKey;
extern NSString * const kAMPreferencesFontNameKey;

extern NSString * const kAMPreferencesConstantDictionaryKey;
extern NSString * const kAMPreferencesVariableDictionaryKey;
extern NSString * const kAMPreferencesExpressionDictionaryKey;
extern NSString * const kAMPreferencesEquationDictionaryKey;
extern NSString * const kAMPreferencesGraphKey;
extern NSString * const kAMPreferencesSetKey;

@class AMPreferencesWindowController;

#import <Foundation/Foundation.h>

@interface AMAppController : NSObject

-(IBAction) showPreferencesPanel:(id)sender;

@property (strong,readonly) AMPreferencesWindowController * preferencesController;


@end
