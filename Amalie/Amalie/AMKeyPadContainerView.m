//
//  AMAMKeyPadContainerView.m
//  Amalie
//
//  Created by Keith Staines on 10/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "AMKeyPadContainerView.h"
#import "AMKeyboardButtonView.h"
#import "AMKeyboardsViewController.h"
#import "AMKeyboardKeyModel.h"

@interface AMKeyPadContainerView()
{
    __weak AMKeyboardsViewController * _keyboardsViewController;
    __weak NSViewController        * _symbolViewController;
    __weak NSView                  * _keyPad;
}

@end


@implementation AMKeyPadContainerView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)awakeFromNib
{
    CGFloat kAMKEYWIDTH  = 48.0;
    CGFloat kAMKEYHEIGHT = 48.0;
    CGFloat kSpace = 5.0;
    NSUInteger const MAX_ROW_BUTTONS = 10;
    NSUInteger const MAX_COL_BUTTONS = 5;
    for (NSUInteger iRow = 0; iRow < MAX_COL_BUTTONS; iRow++) {
        for (NSUInteger iCol = 0; iCol < MAX_ROW_BUTTONS; iCol++) {
            NSRect keyButtonFrame = NSMakeRect(2*kSpace + iCol * (kAMKEYWIDTH + kSpace),
                                               2*kSpace + iRow * (kAMKEYHEIGHT + kSpace),
                                               kAMKEYWIDTH,
                                               kAMKEYHEIGHT);
            AMKeyboardButtonView * keyButton = [self makeKeyViewWithFrame:keyButtonFrame];
            keyButton.tag = iRow * MAX_ROW_BUTTONS + iCol;
            [keyButton setAlphaValue:1];
            [self.keyPad addSubview:keyButton];
        }
    }
}

-(BOOL)isFlipped
{
    return YES;
}

-(AMKeyboardButtonView*)makeKeyViewWithFrame:(NSRect)frame
{
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    
    // traits: NSBoldFontMask|NSItalicFontMask
    NSFont * font = [fontManager fontWithFamily:@"STIXGeneral"
                                              traits:NSItalicFontMask
                                              weight:0
                                                size:20];
    
    AMKeyboardButtonView * keyButton = [[AMKeyboardButtonView alloc] initWithFrame:frame];
    keyButton.keyboardsViewController = self.keyboardsViewController;
    
    [keyButton setFont:font];
    return keyButton;
}

-(BOOL)translatesAutoresizingMaskIntoConstraints
{
    return YES;
}


-(void)reloadKeys
{
    NSUInteger nKeys = [self.keyboardsViewController numberOfKeys];

    for (NSView * view in self.keyPad.subviews) {
        // Only the subviews representing keys are affected, so exit early if not one of these.
        if (view.class != [AMKeyboardButtonView class]) continue;
        
        // All views below here represent keys
        AMKeyboardButtonView * keyButton = (AMKeyboardButtonView*)view;
        if (keyButton.tag < nKeys) {
            [keyButton setAlphaValue:1];
            [keyButton setEnabled:YES];
            keyButton.keyboardKey = [self.keyboardsViewController keyForIndex:keyButton.tag];
        } else {
            [keyButton setAlphaValue:0];
            [keyButton setEnabled:NO];
        }
    }
}

-(void)resizeWithOldSuperviewSize:(NSSize)oldSize
{
    self.frame = self.superview.bounds;
}

-(void)viewDidMoveToSuperview
{
    self.frame = self.superview.bounds;
    [self setNeedsDisplay:YES];
}

-(BOOL)autoresizesSubviews
{
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor colorWithCalibratedRed:222.0/255.0
                               green:223.0/255.0
                                blue:231.0/255.0
                               alpha:1.0] set];
    NSRectFill(dirtyRect);
}

@end
