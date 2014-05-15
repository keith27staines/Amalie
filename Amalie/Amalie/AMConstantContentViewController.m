//
//  AMConstantContentViewController.m
//  Amalie
//
//  Created by Keith Staines on 03/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMConstantContentViewController.h"
#import "AMDFunctionDef+Methods.h"

@interface AMConstantContentViewController ()

@end

@implementation AMConstantContentViewController

-(NSString *)nibName
{
    return @"AMFunctionContentView";
}
-(BOOL)isConstant
{
    return YES;
}

-(void)setAmdInsertedObject:(AMDInsertedObject *)amdInsertedObject
{
    [super setAmdInsertedObject:amdInsertedObject];
    AMDFunctionDef * funcDef = (AMDFunctionDef*)amdInsertedObject;
    funcDef.isConstant = @(self.isConstant);
    funcDef.isVariable = @(self.isVariable);
}

@end
