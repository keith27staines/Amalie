//
//  AMArgumentListView.m
//  Amalie
//
//  Created by Keith Staines on 08/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMArgumentListView.h"

@interface AMArgumentListView()
{
    BOOL _showEqualsSign;
}

@end

@implementation AMArgumentListView

-(void)awakeFromNib
{
    self.readOnly = YES;
}
-(void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}
-(CGFloat)baselineOffsetFromBottom
{
    return [super baselineOffsetFromBottom];
}
-(void)setShowEqualsSign:(BOOL)showEqualsSign
{
    _showEqualsSign = YES;
    [self reloadData];
}
-(BOOL)showEqualsSign
{
    return _showEqualsSign;
}

-(void)reloadData
{
    NSFont * bracesFont = [self.delegate bracesFontAtScriptingLevel:self.scriptingLevel];
    NSAssert(bracesFont, @"Font for braces not set");
    NSDictionary * attributes = @{NSFontAttributeName: bracesFont};
    NSAttributedString * comma = [[NSAttributedString alloc] initWithString:@", " attributes:attributes];
    NSUInteger stringCount = self.delegate.displayStringCount;

    // We will construct the argument list into displayString
    NSMutableAttributedString * displayString;
    
    if (stringCount == 0) {
        // append right bracket or right bracket and equals sign
        if (!self.showEqualsSign) {
            self.attributedString = [[NSMutableAttributedString alloc] initWithString:@" =" attributes:attributes]; // We need to do this because some string is required in order to calculate the extendedAttrs
            NSMutableDictionary * extendedAttrs = [attributes mutableCopy];
            // extendedAttrs are required because an equal sign by itself is misplaced vertically, with one of its horizontal bars on the actual string baseline
            extendedAttrs[NSBaselineOffsetAttributeName] = @([self minusSignHeightAboveBaseline]);
            displayString = [[NSMutableAttributedString alloc] initWithString:@" =" attributes:extendedAttrs]; // shifts the character up by the required displacement for a minus sign
        } else {
            [displayString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes]];
        }

    } else {
        // initialise with left bracket
        displayString = [[NSMutableAttributedString alloc] initWithString:@"(" attributes:attributes];
        
        // append comma seperated list x,y,z...
        for (NSUInteger i = 0; i < stringCount; i++) {
            [displayString appendAttributedString:[self.delegate displayStringForIndex:i atScriptingLevel:self.scriptingLevel]];
            
            if (i < stringCount - 1) {
                [displayString appendAttributedString:comma];
            }
        }
        
        // append right bracket or right bracket and equals sign
        if (!self.showEqualsSign) {
            [displayString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@")" attributes:attributes]];
        } else {
            [displayString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@") =" attributes:attributes]];
        }
    }
    self.attributedString = displayString;
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay:YES];
}


@end
