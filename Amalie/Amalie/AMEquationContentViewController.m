//
//  AMEquationContentViewController.m
//  Amalie
//
//  Created by Keith Staines on 03/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMEquationContentViewController.h"
#import "KSMExpression.h"
#import "AMInsertableRecord.h"
#import "AMInteriorExpressionView.h"

static NSUInteger const kAMIndexRHS;

@interface AMEquationContentViewController ()

@end

@implementation AMEquationContentViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"AMEquationContentView" bundle:nil];
    if (self) {
        // Expression content specific initialization
    }
    return self;
}

- (IBAction)nameWasEdited:(NSTextField *)sender
{
    ;

}

- (IBAction)expressionStringWasEdited:(NSTextField *)sender
{
    AMInsertableRecord * record;
    record = self.record;
    KSMExpression * expr;
    expr = [record expressionFromString:sender.stringValue atIndex:kAMIndexRHS];
    self.expressionView.expression = expr;
    [self.expressionView setNeedsDisplay:YES];
}


@end
