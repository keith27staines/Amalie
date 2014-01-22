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
#import "AMEquationContentView.h"
#import "AMDInsertedObject.h"
#import "AMExpressionNodeView.h"
#import "AMPreferences.h"
#import "AMWorksheetController.h"
#import "AMNameView.h"
#import "AMNameProvider.h"

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

- (IBAction)nameAction:(AMNameView *)sender {
    NSString * proposedName = [sender.attributedStringValue string];
    AMNameProvider * namer = [AMNameProvider nameProvider];
    if ( ! [namer validateProposedName:proposedName forType:AMInsertableTypeEquation error:nil] ) {
        sender.attributedStringValue = self.attributedName;
    }
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
    if (view == self.equationView) {
        self.nameView.attributedStringValue = self.amdInsertedObject.name.attributedString;
        KSMExpression * expr = [self expressionForIndex:0];
        self.expressionStringView.stringValue = expr.string;
                
        [self.expressionStringView setFont:[AMPreferences fixedWidthFont]];
        [self.nameView setFont:[AMPreferences standardFont]];
        
        self.expressionView.expression = expr;
    }
}

@end
