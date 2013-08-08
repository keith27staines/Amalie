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
#import "AMPreferences.h"

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

- (IBAction)nameWasEdited:(NSTextField *)sender
{
    NSAttributedString * proposedName = sender.attributedStringValue;
    if ( ! [self changeNameIfValid:proposedName error:nil] )
        sender.attributedStringValue = self.attributedName;

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

-(void)populateContent
{
    self.nameField.attributedStringValue = self.record.attributedName;
    KSMExpression * expr = [self.record expressionForIndex:0];
    self.expressionString.stringValue = expr.string;
    
    NSDictionary * fonts = [AMPreferences fonts];
    NSFont * standardFont = fonts[kAMFontNameKey];
    NSFont * fixedWidthFont = fonts[kAMFixedWidthFontNameKey];
    
    [self.expressionString setFont:fixedWidthFont];
    [self.nameField setFont:standardFont];

    self.expressionView.standardFont = standardFont;
    self.expressionView.expression = expr;
}

@end
