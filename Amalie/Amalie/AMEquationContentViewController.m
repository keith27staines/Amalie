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
#import "AMInsertableRecord.h"
#import "AMExpressionNodeView.h"
#import "AMPreferences.h"
#import "AMWorksheetController.h"
#import "AMNameView.h"

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
    NSAttributedString * proposedName = sender.attributedStringValue;
    if ( ! [self changeNameIfValid:proposedName error:nil] )
        sender.attributedStringValue = self.attributedName;
}

- (IBAction)expressionStringWasEdited:(NSTextField *)sender
{
    AMExpressionNodeView * expressionView = self.expressionView;
    AMInsertableRecord * record;
    record = self.record;
    KSMExpression * expr;
    expr = [record expressionFromString:sender.stringValue atIndex:kAMIndexRHS];
    expressionView.expression = expr;
    [self layoutInsertedView];
    [expressionView setNeedsDisplay:YES];
}

-(void)layoutInsertedView
{
    CGFloat viewMargin = 15.0f;

    AMExpressionNodeView * expressionView = self.expressionView;
    NSView * expressionString = self.expressionStringView;
    AMEquationContentView * equationView = self.equationView;
    NSView * container = [equationView superview];
    AMNameView * name = [equationView nameView];
    [name setFrameSize:[name intrinsicContentSize]];
    [name setUseQuotientBaselining:expressionView.requiresQuotientBaselining];
    [expressionString setFrameSize:NSMakeSize(150.0f, expressionString.frame.size.height)];

    // The sizes of the important nested and sibling views
    NSSize expressionSize   = expressionView.intrinsicContentSize;
    NSSize stringSize = expressionString.frame.size;
    if (expressionSize.width < 100) expressionSize.width = 100;
    expressionSize.width = fmaxf(expressionSize.width, stringSize.width);
    stringSize.width = expressionSize.width;
    NSSize equationSize = NSMakeSize(viewMargin + name.frame.size.width + viewMargin + expressionSize.width + viewMargin,
                                      viewMargin + expressionSize.height + viewMargin + stringSize.height + viewMargin);
    
    // do the resizing
    [CATransaction begin];
    [[equationView animator]     setFrameSize:equationSize];
    [[expressionView animator]   setFrameSize:expressionSize];
    [[expressionString animator] setFrameSize:stringSize];
    
    // and repositioning

    NSPoint expressionOrigin = NSMakePoint(viewMargin + name.intrinsicContentSize.width + viewMargin,
                                           equationSize.height - viewMargin - expressionSize.height);
    
    if (expressionView.useQuotientBaselining) {
        NSPoint baseline = NSMakePoint(0,[expressionView baselineOffsetFromBottom]);
        baseline = [equationView convertPoint:baseline fromView:expressionView];
        [name setFrameOrigin:NSMakePoint(viewMargin, baseline.y - name.baselineOffsetFromBottom)];
    } else {
        [name setFrameOrigin:NSMakePoint(viewMargin, expressionOrigin.y)];
    }

    
    NSPoint stringOrigin = NSMakePoint(expressionOrigin.x, expressionOrigin.y - viewMargin - stringSize.height);
    [[expressionString animator] setFrameOrigin:stringOrigin];
    [[expressionView animator]   setFrameOrigin:expressionOrigin];
    
    // Make the box fit the equation view
    [container setFrameSize:NSMakeSize(equationSize.width+2*viewMargin, equationSize.height + 2*viewMargin)];
    [equationView setFrameOrigin:NSMakePoint(viewMargin, viewMargin)];

    [CATransaction commit];
    [[self parentWorksheetController] contentViewController:self isResizingContentTo:expressionView.frame.size  usingAnimationTransaction:NO];
}

-(void)populateContent
{
    self.nameView.attributedStringValue = self.record.attributedName;
    KSMExpression * expr = [self.record expressionForIndex:0];
    self.expressionStringView.stringValue = expr.string;
    
    NSDictionary * fonts = [AMPreferences fonts];
    NSFont * standardFont = fonts[kAMFontNameKey];
    NSFont * fixedWidthFont = fonts[kAMFixedWidthFontNameKey];
    
    [self.expressionStringView setFont:fixedWidthFont];
    [self.nameView setFont:standardFont];

    self.expressionView.expression = expr;
    [self layoutInsertedView];
}

@end
