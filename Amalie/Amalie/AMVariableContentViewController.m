//
//  AMVariableContentViewController.m
//  Amalie
//
//  Created by Keith Staines on 03/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMVariableContentViewController.h"
#import "AMDFunctionDef+Methods.h"

@interface AMVariableContentViewController ()

@end

@implementation AMVariableContentViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"AMFunctionContentView" bundle:nil];
    if (self) {
        // Expression content specific initialization
    }
    return self;
}

-(BOOL)isVariable
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
