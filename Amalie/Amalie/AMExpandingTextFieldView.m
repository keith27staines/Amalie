//
//  AMExpandingTextFieldView.m
//  ExpandableText
//
//  Created by Keith Staines on 17/01/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMExpandingTextFieldView.h"

@implementation AMExpandingTextFieldView

#pragma mark - NSView overrides -

-(NSSize)intrinsicContentSize
{
    NSSize size = [super intrinsicContentSize];
    size.width = [self.stringValue sizeWithAttributes:@{NSFontAttributeName: self.font}].width + 10;
    return size;
}

#pragma mark - Notifications -

-(void)textDidChange:(NSNotification *)notification
{
    [self invalidateIntrinsicContentSize];
}

@end
