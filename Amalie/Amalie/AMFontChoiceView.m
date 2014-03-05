//
//  AMFontChoiceView.m
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMFontChoiceView.h"
#import "AMFontAttributes.h"

@interface AMFontChoiceView()
{
    NSTextField * _fontUsageTextField;
    NSTextField * _fontFamilyNameTextField;
    NSButton    * _fontPickerButton;
    NSButton    * _boldButton;
    NSButton    * _italicButton;
    NSButton    * _restoreButton;
}
@property (readonly) NSTextField * fontUsageTextField;

@property (readonly) NSTextField * fontFamilyNameTextField;

@property (readonly) NSButton * fontPickerButton;

@property (readonly) NSButton * boldButton;

@property (readonly) NSButton * italicButton;

@property (readonly) NSButton * restoreButton;
@end

@implementation AMFontChoiceView

#pragma mark - NSView overrides
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
-(void)viewDidMoveToSuperview
{
    [self fontUsageTextField];
    [self fontFamilyNameTextField];
    [self fontPickerButton];
    [self boldButton];
    [self italicButton];
}

-(void)reloadData
{
    AMFontAttributes * attrs = [self.datasource fontAttributesForFontChoiceView:self];
    self.fontFamilyNameTextField.stringValue = attrs.name;
    if (attrs.isBold) {
        [self.boldButton setState:NSOnState];
    } else {
        [self.boldButton setState:NSOffState];
    }
    if (attrs.isItalic) {
        [self.italicButton setState:NSOnState];
    } else {
        [self.italicButton setState:NSOffState];
    }
    self.fontUsageTextField.stringValue = [self.datasource localizedFontUsageDescriptionForFontChoiceView:self];
}

#pragma mark - Actions
-(void)fontFamilyChanged:(NSTextField*)sender
{
    NSLog(@"Font usage changed!");
}
-(void)fontPickerButtonClicked:(NSButton*)button
{
    NSLog(@"Font Picker button clicked");
}
-(void)boldButtonClicked:(NSButton*)button
{
    
}
-(void)italicButtonClicked:(NSButton*)button
{
    
}
-(void)restoreButtonClicked:(NSButton*)button
{
    [NSUserDefaults standardUserDefaults];
}

#pragma mark - Properties returning controls ov view
-(NSTextField *)fontUsageTextField
{
    if (!_fontUsageTextField) {
        NSView * view = [self subViewForEnumeratedTag:AMFontChoiceViewFontUsageLabel];
        _fontUsageTextField = (NSTextField *)view;
    }
    return _fontUsageTextField;
}
-(NSTextField *)fontFamilyNameTextField
{
    if (!_fontFamilyNameTextField) {
        NSView * view = [self subViewForEnumeratedTag:AMFontChoiceViewFontFamilyNameField];
        _fontFamilyNameTextField = (NSTextField *)view;
        [_fontFamilyNameTextField setTarget:self];
        [_fontFamilyNameTextField setAction:@selector(fontFamilyChanged:)];
    }
    return _fontUsageTextField;
}
-(NSButton*)fontPickerButton
{
    if (!_fontPickerButton) {
        NSView * view = [self subViewForEnumeratedTag:AMFontChoiceViewFontPickerButton];
        _fontPickerButton = (NSButton *)view;
        [_fontPickerButton setTarget:self];
        [_fontPickerButton setAction:@selector(fontPickerButtonClicked:)];
    }
    return _fontPickerButton;
}
-(NSButton *)boldButton
{
    if (!_boldButton) {
        NSView * view = [self subViewForEnumeratedTag:AMFontChoiceViewBoldButton];
        _boldButton = (NSButton*)view;
    }
    return _boldButton;
}
-(NSButton *)italicButton
{
    return (NSButton*)[self subViewForEnumeratedTag:AMFontChoiceViewItalicButton];
}
-(NSButton *)restoreButton
{
    return (NSButton*)[self subViewForEnumeratedTag:AMFontChoiceViewRestoreButton];
}

-(NSView*)subViewForEnumeratedTag:(AMFontChoiceSubviewTags)tag
{
    return [self viewWithTag:tag];
}

#pragma mark - NSTextField delegate


@end
