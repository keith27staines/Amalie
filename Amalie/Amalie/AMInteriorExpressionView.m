//
//  AMInteriorExpressionView.m
//  Amalie
//
//  Created by Keith Staines on 06/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMInteriorExpressionView.h"
#import "KSMExpression.h"

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
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:dirtyRect];
    [[NSColor blackColor] set];
    [NSBezierPath strokeRect:dirtyRect];
    
    if (self.expression) {
        NSString * string = [self.expression string];
        NSSize size = [string sizeWithAttributes:nil];
        NSRect txtBounds = am_rectFromSize(size);
        NSRect centered = am_centeredRectInRect(txtBounds, self.bounds);
        [string drawInRect:centered withAttributes:nil];
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
