//
//  AMPageSetupViewController.m
//  Amalie
//
//  Created by Keith Staines on 20/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMPageSetupViewController.h"
#import "AMPagePreferencesViewController.h"
#import "AMPagePreferencesView.h"
#import "AMUserPreferences.h"
#import "AMAmalieDocument.h"

@interface AMPageSetupViewController ()
{
    AMPageSettings * _pageSettings;
}
@end

@implementation AMPageSetupViewController

-(NSString *)nibName
{
    return @"AMPageSetupViewController";
}
@end
