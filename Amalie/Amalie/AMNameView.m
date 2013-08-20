//
//  AMNameView.m
//  Amalie
//
//  Created by Keith Staines on 20/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMNameView.h"

@interface AMNameView()
{
    NSAttributedString * _attributedStringValue;
    BOOL _useQuotientBaselining;
}

@end


@implementation AMNameView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.attributedStringValue = [[NSAttributedString alloc] initWithString:@"Name" attributes:nil];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor colorWithCalibratedRed:5 green:.8 blue:1 alpha:1] set];
    NSRectFill(dirtyRect);
    [self.attributedStringValue drawAtPoint:NSMakePoint(0, 0)];
}

-(NSAttributedString *)attributedStringValue
{
    if (!_attributedStringValue) {
        _attributedStringValue = [[NSAttributedString alloc] initWithString:self.stringValue attributes:nil];
    }
    return _attributedStringValue;
}

-(void)setAttributedStringValue:(NSAttributedString *)attributedString
{
    _attributedStringValue = attributedString;
}

-(NSSize)intrinsicContentSize
{
    return [self.attributedStringValue size];
}

-(CGFloat)baselineOffsetFromBottom
{
    if (self.useQuotientBaselining) {
        return self.intrinsicContentSize.height / 2.0;
    } else {
        return 0;
    }
}

#pragma mark - AMQuotientBaselining -

-(CGFloat)extentAboveOwnBaseline
{
    if (self.useQuotientBaselining) {
        return self.intrinsicContentSize.height / 2.0f;
    } else {
        return self.intrinsicContentSize.height;
    }
}

-(AMOperatorView *)baselineDefiningDivideView
{
    return nil;
}

-(BOOL)useQuotientBaselining
{
    return _useQuotientBaselining;
}

-(void)setUseQuotientBaselining:(BOOL)useQuotientBaselining
{
    _useQuotientBaselining = useQuotientBaselining;
}

-(BOOL)requiresQuotientBaselining
{
    return self.useQuotientBaselining;
}

-(CGFloat)verticalMidPoint
{
    return self.frame.origin.y + self.intrinsicContentSize.height / 2.0f;
}

@end
