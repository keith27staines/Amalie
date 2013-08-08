//
//  AMInteriorExpressionView.m
//  Amalie
//
//  Created by Keith Staines on 06/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMInteriorExpressionView.h"
#import "KSMExpression.h"
#import <CoreText/CoreText.h>

@implementation AMInteriorExpressionView

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
    [[[self window] graphicsContext] setShouldAntialias:YES];
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:dirtyRect];
    [[NSColor blackColor] set];
    [NSBezierPath strokeRect:dirtyRect];
    
    if (self.expression) {
        
        NSFontManager *fontManager = [NSFontManager sharedFontManager];
        
        
        
        NSFont * normalFont = self.standardFont;
        NSFont *italicFont = [fontManager fontWithFamily:normalFont.familyName
                                                  traits:NSItalicFontMask
                                                  weight:0
                                                    size:self.standardFont.pointSize];
        
        
        NSDictionary * attributes = @{NSFontAttributeName: italicFont};
        NSString * string = [self.expression string];
        NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:string attributes:attributes];
        
        
        
        NSSize size = [attributedString size];
        NSRect txtBounds = am_rectFromSize(size);
        NSRect centered = am_centeredRectInRect(txtBounds, self.bounds);
        [attributedString drawInRect:centered];
    }
}



NSRect am_rectFromSize(NSSize size)
{
    return NSMakeRect(0, 0, size.width, size.height);
}

NSRect am_centeredRectInRect(NSRect innerRect, NSRect outerRect)
{
    CGFloat x = (outerRect.size.width - innerRect.size.width)/2.0;
    CGFloat y = (outerRect.size.height - innerRect.size.height)/2.0;
    return NSMakeRect(x,y, outerRect.size.width - 2.0*x, outerRect.size.height - 2.0*y);
}
@end
