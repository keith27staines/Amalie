//
//  AMKeyboardView.m
//  Amalie
//
//  Created by Keith Staines on 15/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

static CGFloat    const kAMKEYWIDTH     = 48.0;
static CGFloat    const kAMKEYHEIGHT    = 48.0;
static CGFloat    const kAMSPACER       = 5.0;
static NSUInteger const MAX_ROW_BUTTONS = 10;
static NSUInteger const MAX_COL_BUTTONS = 3;

#import "AMKeyboardView.h"
#import "AMKeyboardButtonView.h"
#import "AMKeyboardsViewController.h"

@implementation AMKeyboardView

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
    for (NSUInteger iRow = 0; iRow < MAX_COL_BUTTONS; iRow++) {
        for (NSUInteger iCol = 0; iCol < MAX_ROW_BUTTONS; iCol++) {
            NSRect keyButtonFrame = NSMakeRect(2*kAMSPACER + iCol * (kAMKEYWIDTH + kAMSPACER),
                                               2*kAMSPACER + iRow * (kAMKEYHEIGHT + kAMSPACER),
                                               kAMKEYWIDTH,
                                               kAMKEYHEIGHT);
            AMKeyboardButtonView * keyButton = [self makeKeyButtonViewWithFrame:keyButtonFrame];
            keyButton.tag = iRow * MAX_ROW_BUTTONS + iCol;
            [keyButton setAlphaValue:1];
            [self addSubview:keyButton];
        }
        [self setFrameSize:self.intrinsicContentSize];
    }
}

-(NSSize)intrinsicContentSize
{
    return NSMakeSize(3*kAMSPACER + MAX_ROW_BUTTONS * (kAMKEYWIDTH + kAMSPACER),
                      3*kAMSPACER + MAX_COL_BUTTONS * (kAMKEYHEIGHT + kAMSPACER));
}


-(AMKeyboardButtonView*)makeKeyButtonViewWithFrame:(NSRect)frame
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

-(void)reloadKeys
{
    NSUInteger nKeys = [self.keyboardsViewController numberOfKeys];
    
    for (NSView * view in self.subviews) {
        
        if ( [view class] != [AMKeyboardButtonView class] ) continue;
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
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor colorWithCalibratedRed:229.0/255.0
                               green:228.0/255.0
                                blue:226.0/255.0
                               alpha:1] set];
    NSRectFill(dirtyRect);
    NSRect insetRect = NSInsetRect(self.bounds, 1, 1);
    NSBezierPath * path = [NSBezierPath bezierPathWithRect:insetRect];
    [[NSColor blackColor] set];
    [path stroke];
}

-(BOOL)isFlipped
{
    return YES;
}

-(BOOL)translatesAutoresizingMaskIntoConstraints
{
    return NO;
}
@end
