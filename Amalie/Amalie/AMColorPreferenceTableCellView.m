//
//  AMColorPreferenceTableCellView.m
//  Amalie
//
//  Created by Keith Staines on 28/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMColorPreferenceTableCellView.h"
#import "AMColorPreference.h"

@interface AMColorPreferenceTableCellView()
{
    AMColorPreference * _colorPreference;
}

@end

@implementation AMColorPreferenceTableCellView

-(void)drawRect:(NSRect)dirtyRect
{
    [self.colorPreference.backColor set];
    NSRect insetRect = NSInsetRect(self.bounds, 2, 2);
    NSRectFill(insetRect);
}
-(NSColor*)backColor
{
    return self.colorPreference.backColor;
}
-(void)setBackColor:(NSColor*)color
{
    self.colorPreference.backColor = color;
    [self colorsChanged];
}
-(NSColor*)textColor
{
    return self.colorPreference.fontColor;
}
-(void)setTextColor:(NSColor*)color
{
    self.colorPreference.fontColor = color;
    [self colorsChanged];
}
-(AMColorPreference *)colorPreference
{
    return _colorPreference;
}
-(void)setColorPreference:(AMColorPreference *)colorPreference
{
    _colorPreference = colorPreference;
    self.imageView.image = colorPreference.icon;
    self.textField.stringValue = colorPreference.title;
    [self colorsChanged];
}
-(void)colorsChanged
{
    self.textField.backgroundColor = self.colorPreference.backColor;
    self.textField.textColor = self.colorPreference.fontColor;
    [self setNeedsDisplay:YES];
}
@end
