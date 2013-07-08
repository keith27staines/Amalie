//
//  AMPreferencesWindowController.m
//  Amalie
//
//  Created by Keith Staines on 07/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMPreferencesWindowController.h"

@interface AMPreferencesWindowController ()

@end

@implementation AMPreferencesWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.

    }
    
    return self;
}

-(IBAction)changedNormalFontSize:(NSTextField *)sender
{
    NSUInteger size = ceil([sender doubleValue]);
    [AMPreferencesWindowController setWorksheetFontSize:size];
}

-(IBAction)changedFontSizeDelta:(NSTextField *)sender
{
    NSUInteger size = ceil([sender doubleValue]);
    [AMPreferencesWindowController setWorksheetFontDelta:size];
}


// Smallest font size
-(IBAction)changedSmallestFontSize:(NSTextField *)sender
{
    NSUInteger size = ceil([sender doubleValue]);
    [AMPreferencesWindowController setWorksheetSmallestFontSize:size];
}

+(void)setWorksheetSmallestFontSize:(NSUInteger)size
{
    [[NSUserDefaults standardUserDefaults] setInteger:size forKey:kAMPreferencesWorksheetMinFontSizeKey];
}


+(NSUInteger)worksheetSmallestFontSize
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kAMPreferencesWorksheetMinFontSizeKey];
}


//
-(IBAction)changedFixedWidthFontName:(NSTextField *)sender
{
    
}

-(IBAction)changedFontName:(NSTextField *)sender
{
    
}


+(NSUInteger)worksheetFontDelta
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kAMPreferencesWorksheetFontSizeDeltaKey];
}

+(NSUInteger)worksheetFontSize
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kAMPreferencesWorksheetFontSizeKey];
}

+(void)setWorksheetFontDelta:(NSUInteger)delta
{
    return [[NSUserDefaults standardUserDefaults] setInteger:delta forKey:kAMPreferencesWorksheetFontSizeDeltaKey];
}

+(void)setWorksheetFontSize:(NSUInteger)size
{
    return [[NSUserDefaults standardUserDefaults] setInteger:size forKey:kAMPreferencesWorksheetFontSizeKey];
}


- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSNumber * size;
    NSString * strSize;
    
    // smallest font
    size = [defaults objectForKey:kAMPreferencesWorksheetMinFontSizeKey];
    strSize = [NSString stringWithFormat:@"%ld",(long)[size integerValue]];
    self.textSmallestFontSize.stringValue = strSize;
    
    // font delta
    size = [defaults objectForKey:kAMPreferencesWorksheetMinFontSizeKey];
    strSize = [NSString stringWithFormat:@"%ld",(long)[size integerValue]];
    self.textSmallestFontSize.stringValue = strSize;
}


+(void)registerDefaultPreferences
{
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    
    [defaults setObject:kAMPaperSizeA4Portrait forKey:kAMPreferencesWorksheetPaperSizeKey];
    [defaults setObject:kAMDefaultFontName forKey:kAMDefaultFontName];
    [defaults setObject:kAMDefaultFixedWidthFontName forKey:kAMDefaultFixedWidthFontName];
    [defaults setObject:@(kAMDefaultWorksheetFontSize) forKey:kAMPreferencesWorksheetFontSizeKey];
    [defaults setObject:@(kAMDefaultWorksheetFontDelta) forKey:kAMPreferencesWorksheetFontSizeDeltaKey];
    [defaults setObject:@(kAMDefaultWorksheetMinFontSize) forKey:kAMPreferencesWorksheetMinFontSizeKey];
    
    // Constant dictionary
    NSDictionary * constantDictionary   = @{kAMPreferencesBackColorKey: colorDataFromName(AMColorPaleRed)};
    [defaults setObject:constantDictionary forKey:kAMPreferencesConstantDictionaryKey];
    
    // Variable dictionary
    NSDictionary * variableDictionary   = @{kAMPreferencesBackColorKey: colorDataFromName(AMColorPaleGreen)};
    [defaults setObject:variableDictionary forKey:kAMPreferencesVariableDictionaryKey];
    
    // Expression dictionary
    NSDictionary * expressionDictionary = @{kAMPreferencesBackColorKey: colorDataFromName(AMColorPaleBlue)};
    [defaults setObject:expressionDictionary forKey:kAMPreferencesExpressionDictionaryKey];
    
    // Expression dictionary
    NSDictionary * equationDictionary   = @{kAMPreferencesBackColorKey: colorDataFromName(AMColorPalePurple)};
    [defaults setObject:equationDictionary forKey:kAMPreferencesEquationDictionaryKey];
    
    // Equation dictionary
    NSDictionary * graph2DDictionary    = @{kAMPreferencesBackColorKey: colorDataFromName(AMColorPaleYellow)};
    [defaults setObject:graph2DDictionary forKey:kAMPreferencesGraph2DDictionaryKey];
    
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    
    
}

#pragma mark - Helper functions -

NSData * colorDataFromName(AMColor color)
{
    return dataFromColor(colorFromName(color));
}

NSColor * colorFromName(AMColor color)
{
    switch (color) {
        case AMColorPaleRed:
            return [NSColor colorWithCalibratedRed:1.0 green:0.8 blue:0.8 alpha:1.0];
        case AMColorPaleGreen:
            return [NSColor colorWithCalibratedRed:0.8 green:1.0 blue:0.8 alpha:1.0];
        case AMColorPaleBlue:
            return [NSColor colorWithCalibratedRed:0.8 green:0.8 blue:1.0 alpha:1.0];
        case AMColorPaleYellow:
            return [NSColor colorWithCalibratedRed:1.0 green:1.0 blue:0.8 alpha:1.0];
        case AMColorPalePurple:
            return [NSColor colorWithCalibratedRed:1.0 green:0.8 blue:1.0 alpha:1.0];
        case AMColorPaleAzure:
            return [NSColor colorWithCalibratedRed:0.8 green:1.0 blue:1.0 alpha:1.0];
            
        default:
            break;
    }
}


NSColor * colorFromData(NSData* data)
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

NSData * dataFromColor(NSColor* color)
{
    return [NSKeyedArchiver archivedDataWithRootObject:color];
}

@end
