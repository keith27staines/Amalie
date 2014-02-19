//
//  AMSplitView.m
//  Amalie
//
//  Created by Keith Staines on 19/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMSplitView.h"
#import "AMConstants.h"

@implementation AMSplitView

-(void)setHidden:(BOOL)flag
{
    [super setHidden:flag];
    if (flag) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kAMNotificationViewDidHide object:self];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kAMNotificationViewDidUnhide object:self];
    }
}

@end
