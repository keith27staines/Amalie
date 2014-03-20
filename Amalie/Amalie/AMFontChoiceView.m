//
//  AMFontChoiceView.m
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMFontChoiceView.h"
#import "AMFontAttributes.h"
#import "AMFontSelectionViewController.h"

@interface AMFontChoiceView()
{
    NSTextField * _fontUsageTextField;
    NSTextField * _fontFamilyNameTextField;
    NSButton    * _fontPickerButton;
    NSButton    * _boldButton;
    NSButton    * _italicButton;
    NSButton    * _restoreButton;
    AMFontAttributes * _fontAttributes;
}
@property (readonly) NSTextField * fontUsageTextField;

@property (readonly) NSTextField * fontFamilyNameTextField;

@property (readonly) NSButton * fontPickerButton;

@property (readonly) NSButton * boldButton;

@property (readonly) NSButton * italicButton;

@property (readonly) NSButton * restoreButton;
@end



@implementation AMFontChoiceView

static NSPopover   * _fontSelectionPopover;
static AMFontSelectionViewController * _fontSelectionViewController;

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

-(void)reloadData
{
    _fontAttributes = [self.datasource fontAttributesForFontChoiceView:self];
    self.fontFamilyNameTextField.stringValue = _fontAttributes.name;
    if (_fontAttributes.isBold) {
        [self.boldButton setState:NSOnState];
    } else {
        [self.boldButton setState:NSOffState];
    }
    if (_fontAttributes.isItalic) {
        [self.italicButton setState:NSOnState];
    } else {
        [self.italicButton setState:NSOffState];
    }
    self.fontUsageTextField.stringValue = [self.datasource localizedFontUsageDescriptionForFontChoiceView:self];
}

-(void)viewDidMoveToSuperview
{
    [self fontPickerButton];
    [self restoreButton];
}

#pragma mark - Actions
-(void)fontFamilyChanged:(NSTextField*)sender
{
    NSLog(@"Font usage changed!");
}
-(void)fontPickerButtonClicked:(NSButton*)button
{
    NSPopover * popover = [self fontSelectionPopover];
    AMFontSelectionViewController * vc = [self fontSelectionViewController];
    vc.fontFamilyToSelect = _fontAttributes.name;
    popover.delegate = self;
    [popover showRelativeToRect:button.frame ofView:self preferredEdge:NSMaxXEdge];
}

-(NSPopover*)fontSelectionPopover
{
    if (!_fontSelectionPopover) {
        _fontSelectionPopover = [[NSPopover alloc] init];
        [_fontSelectionPopover setBehavior:NSPopoverBehaviorTransient];
        [_fontSelectionPopover setAppearance:NSPopoverAppearanceMinimal];
    }
    return _fontSelectionPopover;
}
-(AMFontSelectionViewController*)fontSelectionViewController
{
    if (!_fontSelectionViewController) {
        _fontSelectionViewController = [[AMFontSelectionViewController alloc] init];
        _fontSelectionViewController.exampleText = @"Example text";
        [self fontSelectionPopover].contentViewController = _fontSelectionViewController;
    }
    return _fontSelectionViewController;
}
-(void)boldButtonClicked:(NSButton*)button
{
    if (button.state == NSOnState) {
        _fontAttributes.isBold = YES;
    } else {
        _fontAttributes.isBold = NO;
    }
    [self.datasource attributesUpdatedForFontChoiceView:self];
}
-(void)italicButtonClicked:(NSButton*)button
{
    if (button.state == NSOnState) {
        _fontAttributes.isItalic = YES;
    } else {
        _fontAttributes.isItalic = NO;
    }
    [self.datasource attributesUpdatedForFontChoiceView:self];
}
-(void)restoreButtonClicked:(NSButton*)button
{
    [self.datasource restoreFactoryDefaultsForFontChoiceView:self];
    [self reloadData];
}

#pragma mark - Properties returning controls on view
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
    return _fontFamilyNameTextField;
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
        [_boldButton setTarget:self];
        [_boldButton setAction:@selector(boldButtonClicked:)];
    }
    return _boldButton;
}
-(NSButton *)italicButton
{
    if (!_italicButton) {
        NSView * view = [self subViewForEnumeratedTag:AMFontChoiceViewItalicButton];
        _italicButton = (NSButton*)view;
        [_italicButton setTarget:self];
        [_italicButton setAction:@selector(italicButtonClicked:)];
    }
    return _italicButton;
}
-(NSButton *)restoreButton
{
    if (!_restoreButton) {
        NSView * view = [self subViewForEnumeratedTag:AMFontChoiceViewRestoreButton];
        _restoreButton = (NSButton*)view;
        [_restoreButton setTarget:self];
        [_restoreButton setAction:@selector(restoreButtonClicked:)];
    }
    return _restoreButton;
}

-(NSView*)subViewForEnumeratedTag:(AMFontChoiceSubviewTags)tag
{
    return [self viewWithTag:tag];
}

#pragma mark - NSTextField delegate

#pragma mark - NSPopover delegate

-(void)popoverDidShow:(NSNotification *)notification
{
    AMFontSelectionViewController * vc = [self fontSelectionViewController];
    vc = (AMFontSelectionViewController*)[self.fontSelectionPopover contentViewController];
    vc.fontFamilyToSelect = _fontAttributes.name;
}

-(void)popoverWillClose:(NSNotification *)notification
{
    AMFontSelectionViewController * vc = [self fontSelectionViewController];
    _fontAttributes.name = vc.selectedFontFamily;
    [self.datasource attributesUpdatedForFontChoiceView:self];
    [self reloadData];
}

@end
