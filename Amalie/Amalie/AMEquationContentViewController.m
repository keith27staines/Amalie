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
    [CATransaction begin];

    CGFloat const AM_VIEW_MARGIN      = 15.0f;
    CGFloat const AM_MIN_STRING_WIDTH = 300.0f;

    AMExpressionNodeView * expressionView = self.expressionView;
    NSTextField * expressionString = self.expressionStringView;
    AMEquationContentView * equationView = self.equationView;
    NSView * container = [equationView superview];
    AMNameView * name = [equationView nameView];
    [name sizeToFit];
    NSLog(@"name width %f",name.frame.size.width);
    [name setUseQuotientBaselining:expressionView.requiresQuotientBaselining];
    
    // The sizes of the important nested and sibling views
    NSSize expressionSize   = expressionView.intrinsicContentSize;
    NSSize stringSize =  NSMakeSize( [[expressionString stringValue] sizeWithAttributes:@{NSFontAttributeName: expressionString.font}].width + 10, expressionString.frame.size.height);
    
    if (stringSize.width < AM_MIN_STRING_WIDTH) stringSize.width = AM_MIN_STRING_WIDTH;
    stringSize.width = fmaxf(expressionSize.width, stringSize.width);

    NSSize equationSize = NSMakeSize(AM_VIEW_MARGIN + name.frame.size.width + AM_VIEW_MARGIN + stringSize.width + AM_VIEW_MARGIN,
                                      AM_VIEW_MARGIN + expressionSize.height + AM_VIEW_MARGIN + stringSize.height + AM_VIEW_MARGIN);
    
    // do the resizing
    [[equationView animator] setFrameSize:equationSize];
    [[expressionView animator]   setFrameSize:expressionSize];
    [[expressionString animator] setFrameSize:stringSize];
    
    // and repositioning

    NSPoint expressionOrigin = NSMakePoint(AM_VIEW_MARGIN + name.frame.size.width + AM_VIEW_MARGIN,
                                           equationSize.height - AM_VIEW_MARGIN - expressionSize.height);
    
    if (expressionView.useQuotientBaselining) {
        NSPoint baseline = NSMakePoint(0,[expressionView baselineOffsetFromBottom]);
        baseline = [equationView convertPoint:baseline fromView:expressionView];
        [name setFrameOrigin:NSMakePoint(AM_VIEW_MARGIN, baseline.y - name.baselineOffsetFromBottom)];
    } else {
        [name setFrameOrigin:NSMakePoint(AM_VIEW_MARGIN, expressionOrigin.y)];
    }

    
    NSPoint stringOrigin = NSMakePoint(expressionOrigin.x, expressionOrigin.y - AM_VIEW_MARGIN - stringSize.height);
    [expressionView setFrameOrigin:expressionOrigin];
    [[expressionString animator] setFrameOrigin:stringOrigin];
    
    // Make the box fit the equation view
    [container setFrameSize:NSMakeSize(equationSize.width+2*AM_VIEW_MARGIN, equationSize.height + 2*AM_VIEW_MARGIN)];
    [equationView setFrameOrigin:NSMakePoint(AM_VIEW_MARGIN, AM_VIEW_MARGIN)];

    [CATransaction commit];
    [[self parentWorksheetController] contentViewController:self isResizingContentTo:expressionView.frame.size  usingAnimationTransaction:NO];
}

-(void)populateView:(AMContentView *)view
{
    if (view == self.equationView) {
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
}

@end
