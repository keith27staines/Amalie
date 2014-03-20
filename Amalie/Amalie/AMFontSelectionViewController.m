//
//  AMFontSelectionViewController.m
//  FontList
//
//  Created by Keith Staines on 17/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMFontSelectionViewController.h"
#import "AMFontText.h"

static NSMutableArray * _fontArray;

@interface AMFontSelectionViewController ()
{
    BOOL _requireRegularFont;
    BOOL _requireItalicFont;
    BOOL _requireBoldFont;
    BOOL _requireItalicBoldFont;
    BOOL _requireSerifs;
    NSString * _fontFamilyToSelect;
    NSString * _selectedFontFamily;
    NSString * _exampleText;
}

@property (weak) IBOutlet NSTableView *fontTable;

@end

@implementation AMFontSelectionViewController

- (IBAction)refreshFonts:(id)sender {
    [self clearFonts];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loadFonts) userInfo:nil repeats:NO];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        _requireRegularFont    = YES;
        _requireItalicFont     = YES;
        _requireBoldFont       = YES;
        _requireItalicBoldFont = YES;
        _requireSerifs         = YES;
        _exampleText           = @"Example text";
        _selectedFontFamily    = @"Times New Roman";
    }
    return self;
}
-(NSString *)nibName
{
    return @"AMFontSelectionViewController";
}
-(void)awakeFromNib
{
    [self.fontTable setColumnAutoresizingStyle:NSTableViewReverseSequentialColumnAutoresizingStyle];
}
-(NSMutableArray *)fontArray
{
    if (!_fontArray) {
        _fontArray = [NSMutableArray array];
        [self loadFonts];
    }
    return _fontArray;
}
-(void)loadFonts
{
    NSFontManager * fm = [NSFontManager sharedFontManager];
    NSArray * fontFamilyNames = [fm availableFontFamilies];
    [self.fontLoadProgressIndicator setMaxValue:fontFamilyNames.count];
    int count = 0;
    for (NSString * familyName in fontFamilyNames) {
        [self.fontLoadProgressIndicator setDoubleValue:count++];
        AMFontText * fontText = [AMFontText fontTextWithFamilyName:familyName];
        [self addFontIfSuitable:fontText];
    }
    [self setFontFamilyToSelect:[self fontFamilyToSelect]];
    [self.fontLoadProgressIndicator setDoubleValue:count++];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(hideFontLoadProgressBar:) userInfo:nil repeats:NO];
    [self.fontTable setNeedsDisplay:YES];
}
-(void)clearFonts
{
    [self.fontLoadProgressIndicator setMinValue:0];
    [self.fontLoadProgressIndicator setDoubleValue:0];
    [self.fontLoadProgressIndicator setHidden:NO];
    [self.fontArray removeAllObjects];
    [self.fontTable setNeedsDisplay:YES];
}
-(void)hideFontLoadProgressBar:(id)userInfo
{
    [self.fontLoadProgressIndicator setHidden:YES];
}

-(void)addFontIfSuitable:(AMFontText*)fontText
{
    if ( [self isFontSuitable:fontText] ) {
        fontText.exampleText = self.exampleText;
        [self.fontArray addObject:fontText];
    }
}

-(BOOL)isFontSuitable:(AMFontText*)fontText
{
    NSFont * regular = [fontText regularFont];
    if (self.requireItalicFont) {
        NSFont * italic = [fontText italicFont];
        if (regular == italic) {
            return NO; // Italic variation is required but is not available
        }
    }
    if (self.requireBoldFont) {
        NSFont * bold = [fontText boldFont];
        if (regular == bold) {
            return NO; // Bold variation is required but is not available
        }
    }
    if (self.requireItalicBoldFont) {
        NSFont * italicBold = [fontText italicBoldFont];
        if (regular == italicBold) {
            return NO; // Italic and bold variation is required but is not available
        }
    }
    // All required family variations are available
    return YES;
}

-(NSUInteger)indexOfFontWithFamilyName:(NSString*)familyName
{
    NSPredicate * p = [NSPredicate predicateWithFormat:@"familyName == %@",familyName];
    NSArray * fa = [self.fontArray filteredArrayUsingPredicate:p];
    NSUInteger index;
    if (fa.count == 0) {
        index = NSNotFound;
    } else {
        index = [self.fontArray indexOfObject:fa[0]];
    }
    return index;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeBool:_requireRegularFont    forKey:@"requireRegularFont"];
    [aCoder encodeBool:_requireItalicFont     forKey:@"requireItalicFont"];
    [aCoder encodeBool:_requireBoldFont       forKey:@"requireBoldFont"];
    [aCoder encodeBool:_requireItalicBoldFont forKey:@"requireItalicBoldFont"];
    [aCoder encodeBool:_requireSerifs         forKey:@"requireSerifs"];
    [aCoder encodeObject:_exampleText         forKey:@"exampleText"];
    [aCoder encodeObject:_selectedFontFamily  forKey:@"selectedFontFamily"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    _requireRegularFont = [aDecoder decodeBoolForKey:@"requireRegularFont"];
    _requireItalicFont = [aDecoder decodeBoolForKey:@"requireItalicFont"];
    _requireBoldFont = [aDecoder decodeBoolForKey:@"requireBoldFont"];
    _requireItalicBoldFont = [aDecoder decodeBoolForKey:@"requireItalicBoldFont"];
    _requireSerifs = [aDecoder decodeBoolForKey:@"requireSerifs"];
    _exampleText = [aDecoder decodeObjectForKey:@"exampleText"];
    _selectedFontFamily = [aDecoder decodeObjectForKey:@"selectedFontFamily"];
    return self;
}
-(CGFloat)rowHeight
{
    return round([NSFont systemFontSize]*2);
}
-(void)setRowHeight:(CGFloat)rowHeight
{
    
}
-(NSString *)fontFamilyToSelect
{
    return [_fontFamilyToSelect copy];
}
-(void)setFontFamilyToSelect:(NSString *)fontFamilyToSelect
{
    _fontFamilyToSelect = [fontFamilyToSelect copy];
    NSUInteger index = [self indexOfFontWithFamilyName:_fontFamilyToSelect];
    if (index == NSNotFound) {
        self.arrayController.selectionIndexes = nil;
    } else {
        self.arrayController.selectionIndex = index;
        [self.fontTable scrollRowToVisible:index];
    }
    [self.view.window makeFirstResponder:self.fontTable];
}
-(NSString *)selectedFontFamily
{
    NSIndexSet * set = self.arrayController.selectionIndexes;
    if (set.count == 0) {
        return @"No font selected";
    } else {
        NSUInteger i = set.firstIndex;
        if (i != NSNotFound) {
            AMFontText * ft = self.fontArray[i];
            return [ft familyName];
        } else {
            return @"No font selected";
        }
    }
}
@end
