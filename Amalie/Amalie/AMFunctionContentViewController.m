//
//  AMFunctionContentViewController.m
//  Amalie
//
//  Created by Keith Staines on 03/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMExpressionNodeView;
@class AMEquationContentView;
@class AMNameView;

#import "AMFunctionContentViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "KSMWorksheet.h"
#import "KSMExpression.h"
#import "AMEquationContentViewController.h"
#import "AMFunctionContentView.h"
#import "AMExpressionNodeView.h"
#import "AMPreferences.h"
#import "AMWorksheetController.h"
#import "AMNameView.h"

// core data generated objects
#import "AMDInsertedObject.h"
#import "AMDFunctionDef.h"
#import "AMDName.h"

static NSUInteger const kAMIndexRHS;

@interface AMFunctionContentViewController ()
{

}
@property (weak, readonly) AMDFunctionDef * amdFunctionDef;

@end

@implementation AMFunctionContentViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"AMFunctionContentView" bundle:nil];
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
    KSMExpression * expr;
    expr = [self expressionFromString:sender.stringValue atIndex:kAMIndexRHS];
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
    AMFunctionContentView * functionView = self.functionView;
    NSView * container = [functionView superview];
    AMNameView * name = [functionView nameView];
    [name sizeToFit];
    [name setUseQuotientBaselining:expressionView.requiresQuotientBaselining];
    
    // The sizes of the important nested and sibling views
    NSSize expressionViewSize   = expressionView.intrinsicContentSize;
    NSSize stringSize =  NSMakeSize( [[expressionString stringValue] sizeWithAttributes:@{NSFontAttributeName: expressionString.font}].width + 10, expressionString.frame.size.height);
    
    if (stringSize.width < AM_MIN_STRING_WIDTH) stringSize.width = AM_MIN_STRING_WIDTH;
    stringSize.width = fmaxf(expressionViewSize.width, stringSize.width);
    
    NSSize functionViewSize = NSMakeSize(AM_VIEW_MARGIN + name.frame.size.width + AM_VIEW_MARGIN + stringSize.width + AM_VIEW_MARGIN,
                                     AM_VIEW_MARGIN + expressionViewSize.height + AM_VIEW_MARGIN + stringSize.height + AM_VIEW_MARGIN);
    
    // do the resizing
    [[functionView animator] setFrameSize:functionViewSize];
    [[expressionView animator]   setFrameSize:expressionViewSize];
    [[expressionString animator] setFrameSize:stringSize];
    
    // and repositioning
    
    NSPoint expressionOrigin = NSMakePoint(AM_VIEW_MARGIN + name.frame.size.width + AM_VIEW_MARGIN,
                                           functionViewSize.height - AM_VIEW_MARGIN - expressionViewSize.height);
    
    if (expressionView.useQuotientBaselining) {
        NSPoint baseline = NSMakePoint(0,[expressionView baselineOffsetFromBottom]);
        baseline = [functionView convertPoint:baseline fromView:expressionView];
        [name setFrameOrigin:NSMakePoint(AM_VIEW_MARGIN, baseline.y - name.baselineOffsetFromBottom)];
    } else {
        [name setFrameOrigin:NSMakePoint(AM_VIEW_MARGIN, expressionOrigin.y)];
    }
    
    
    NSPoint stringOrigin = NSMakePoint(expressionOrigin.x, expressionOrigin.y - AM_VIEW_MARGIN - stringSize.height);
    [expressionView setFrameOrigin:expressionOrigin];
    [[expressionString animator] setFrameOrigin:stringOrigin];
    
    // Make the box fit the equation view
    [container setFrameSize:NSMakeSize(functionViewSize.width+4*AM_VIEW_MARGIN, functionViewSize.height + 4*AM_VIEW_MARGIN)];
    [functionView setFrameOrigin:NSMakePoint(2*AM_VIEW_MARGIN, 2*AM_VIEW_MARGIN)];
    
    [CATransaction commit];
    [[self parentWorksheetController] contentViewController:self isResizingContentTo:expressionView.frame.size  usingAnimationTransaction:NO];
}

-(void)populateView:(AMContentView *)view
{    
    if (view == self.functionView) {
        self.nameView.attributedStringValue = self.amdInsertedObject.name.attributedString;
        KSMExpression * expr = self.expressions[0];
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

-(AMDFunctionDef*)amdFunctionDef
{
    return (AMDFunctionDef*)self.amdInsertedObject;
}

-(void)deleteContent
{
    [super deleteContent];
    // TODO: AMFunctionContentController - specific cleanup.

}

@end
