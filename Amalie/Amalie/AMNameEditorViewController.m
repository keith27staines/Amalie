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

@property (readwrite, copy) NSString * nameString;

@end

@implementation AMNameEditorViewController

-(NSString *)nibName {
    return @"AMNameEditorViewController";
}

-(void)presentNameEditorWithName:(AMDName*)amdName nameProvider:(id<AMNameProviding>)nameProvider completionHandler:(void (^)(void))completionHandler
{
    [self view]; // ensure view is loaded so all outlets are connected
    //self.expressionNodeController.delegate = self;
    self.nameProvider = nameProvider;
    self.nameString = amdName.string;
    self.completionHandler = completionHandler;
    [self reloadData];
}
-(void)reloadData
{
    self.nameField.stringValue = self.nameString;
    self.nameDisplay.attributedString = [self.nameProvider attributedStringForObjectWithName:self.nameString];
}
-(void)updateWithString:(NSString*)name
{
    self.nameString = name;
    [self reloadData];
}

#pragma mark - NSTextFieldDelegate -
-(void)controlTextDidBeginEditing:(NSNotification *)obj
{
    
}
-(void)controlTextDidEndEditing:(NSNotification *)obj
{
    NSTextField * tf = obj.object;
    NSString * string = tf.stringValue;
    [self updateWithString:string];
}
-(void)controlTextDidChange:(NSNotification *)obj
{
}

@end
