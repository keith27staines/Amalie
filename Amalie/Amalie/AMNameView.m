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
        self.allowsEditingTextAttributes = YES;
        
    }
    return self;
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
