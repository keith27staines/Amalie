//
//  AMNameEditorViewController.m
//  Amalie
//
//  Created by Keith Staines on 28/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMNameEditorViewController.h"
#import "AMDName+Methods.h"
#import "AMTextView.h"

@interface AMNameEditorViewController ()

@end

@implementation AMNameEditorViewController

-(NSString *)nibName {
    return @"AMNameEditorViewController";
}
-(void)reloadData
{
    self.nameField.stringValue = self.stringValue;
    self.nameDisplay.attributedString = [self.nameProvider attributedStringForObjectWithName:self.stringValue];
}

#pragma mark - NSTextFieldDelegate -
-(void)controlTextDidBeginEditing:(NSNotification *)obj
{
    
}
-(void)controlTextDidEndEditing:(NSNotification *)obj
{
    NSTextField * tf = obj.object;
    self.stringValue = tf.stringValue;
}
-(void)controlTextDidChange:(NSNotification *)obj
{
}

@end
