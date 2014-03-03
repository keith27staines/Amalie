//
//  AMUserPreferencesBaseView.m
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMUserPreferencesBaseView.h"

@implementation AMUserPreferencesBaseView

CGFloat const kAMMINPREFERENCEPANEWIDTH = 900;  // minimum pane width in points

-(void)awakeFromNib
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:kAMMINPREFERENCEPANEWIDTH]];
}

@end
