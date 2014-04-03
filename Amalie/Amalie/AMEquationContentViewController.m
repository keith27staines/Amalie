//
//  AMEquationContentViewController.m
//  Amalie
//
//  Created by Keith Staines on 03/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AMEquationContentViewController.h"
#import "KSMExpression.h"
//#import "AMEquationContentView.h"
#import "AMDInsertedObject.h"
#import "AMExpressionNodeView.h"
#import "AMUserPreferences.h"
#import "AMAmalieDocument.h"
#import "AMArgumentsNameProvider.h"

#import "AMDName.h"

static NSUInteger const kAMIndexRHS;

@interface AMEquationContentViewController ()

@end

@implementation AMEquationContentViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"AMEquationContentView" bundle:nil];
    if (self) {

    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];

}

- (IBAction)expressionStringWasEdited:(NSTextField *)sender
{
    AMExpressionNodeView * expressionView = self.expressionView;
    KSMExpression * expr;
    expr = [self expressionFromString:sender.stringValue atIndex:kAMIndexRHS];
    expressionView.expression = expr;
    [expressionView setNeedsDisplay:YES];
}

-(void)populateView:(AMContentView *)view
{

}

@end
