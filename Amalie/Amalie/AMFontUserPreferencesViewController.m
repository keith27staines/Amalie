//
//  AMFontUserPreferencesViewController.m
//  Amalie
//
//  Created by Keith Staines on 03/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMFontUserPreferencesViewController.h"

@interface AMFontUserPreferencesViewController ()

@end

@implementation AMFontUserPreferencesViewController

-(NSString *)nibName
{
    return @"AMFontUserPreferencesViewController";
}

-(void)awakeFromNib
{

}

- (IBAction)fontSizeStepperChanged:(NSStepper *)sender {
}

#pragma mark - NSTableView delegate
-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return [self.fontChoiceTable makeViewWithIdentifier:@"fontChoiceColumn" owner:nil];
}

#pragma mark - NSTableView datasource
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return 3;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return nil;
}

@end
