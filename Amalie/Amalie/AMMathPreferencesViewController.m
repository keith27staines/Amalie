//
//  AMMathPreferencesViewController.m
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMMathPreferencesViewController.h"

@interface AMMathPreferencesViewController ()

@end

@implementation AMMathPreferencesViewController

-(NSString *)nibName
{
    return @"AMMathPreferencesViewController";
}
-(AMSettingsSectionType)sectionType
{
    return AMSettingsSectionMathsStyle;
}
-(void)reloadData
{
    [super reloadData];
}

@end
