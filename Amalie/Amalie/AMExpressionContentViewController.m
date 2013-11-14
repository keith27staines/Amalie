//
//  AMExpressionContentViewController.m
//  Amalie
//
//  Created by Keith Staines on 21/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AMExpressionContentViewController.h"
#import "AMExpressionNodeView.h"
#import "KSMExpression.h"
#import "AMWorksheetController.h"
#import "AMDExpression+Methods.h"
#import "AMDInsertedObject+Methods.h"
#import "AMDIndexedExpression+Methods.h"

@interface AMExpressionContentViewController ()
{
    __weak NSTextField * _expressionStringView;
    __weak AMExpressionNodeView * _expressionView;
}
@end

@implementation AMExpressionContentViewController


-(id)initWithNibName:(NSString *)nibNameOrNil
              bundle:(NSBundle *)nibBundleOrNil
{
    // Note: unusual logic here because we are implementing a class cluster. We aren't calling super's designated initializer, but rather an initializer that super passes straight on to its own super.
    self = [super initWithNibName:@"AMExpressionContentView" bundle:nil];
    if (self) {
        // Expression content specific initialization
    }
    return self;
}

-(void)setupExpressionStringView
{
    [self.expressionStringView setFont:self.fixedWidthFont];
    
    SEL callback;
    
    callback = NSSelectorFromString(@"expressionStringDidBeginEditing:");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:callback name:NSControlTextDidBeginEditingNotification object:self.expressionStringView];
    
    callback = NSSelectorFromString(@"expressionStringDidChange:");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:callback name:NSControlTextDidChangeNotification object:self.expressionStringView];
    
    callback = NSSelectorFromString(@"expressionStringDidEndEditing:");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:callback name:NSControlTextDidEndEditingNotification object:self.expressionStringView];
}


-(void)expressionStringDidBeginEditing:(NSNotification*)notification
{
    
}

-(void)expressionStringDidEndEditing:(NSNotification*)notification
{
    [self expressionStringWantsChange];
}

- (void)expressionStringDidChange:(NSNotification*)notification
{
    [self expressionStringWasEdited];
}

-(void)expressionStringWantsChange
{
    [self expressionStringWasEdited];
    if ( self.expressionView.expression.valid ) {
        // Change accepted
    } else {
        // Change rejected
    }
}

-(void)expressionStringWasEdited
{
    AMExpressionNodeView * expressionView = self.expressionView;
    KSMExpression * expr;
    expr = [self expressionFromString:self.expressionStringView.stringValue atIndex:0];
    expressionView.expression = expr;
    [self layoutInsertedView];
    [expressionView setNeedsDisplay:YES];
}

-(void)layoutInsertedView
{
    [CATransaction begin];
    
    CGFloat const AM_VIEW_MARGIN      = 19.0f;
    CGFloat const AM_MIN_STRING_WIDTH = 300.0f;
    
    AMExpressionNodeView * expressionView = self.expressionView;
    NSTextField * expressionString = self.expressionStringView;
    AMContentView * contentView = self.contentView;
    NSView * container = [contentView superview];
    
    // The sizes of the important nested and sibling views
    NSSize expressionViewSize   = expressionView.intrinsicContentSize;
    NSSize stringSize =  NSMakeSize( [[expressionString stringValue] sizeWithAttributes:@{NSFontAttributeName: expressionString.font}].width + 10, expressionString.frame.size.height);
    
    if (stringSize.width < AM_MIN_STRING_WIDTH) stringSize.width = AM_MIN_STRING_WIDTH;
    stringSize.width = fmaxf(expressionViewSize.width, stringSize.width);
    
    NSSize contentViewSize = NSMakeSize(AM_VIEW_MARGIN + AM_VIEW_MARGIN + stringSize.width + AM_VIEW_MARGIN,
                                         AM_VIEW_MARGIN + expressionViewSize.height + AM_VIEW_MARGIN + stringSize.height + AM_VIEW_MARGIN);
    
    // do the resizing
    [[contentView animator] setFrameSize:contentViewSize];
    [[expressionView animator]   setFrameSize:expressionViewSize];
    [[expressionString animator] setFrameSize:stringSize];
    
    // and repositioning
    
    
    CGFloat expressionY = contentViewSize.height - AM_VIEW_MARGIN - expressionViewSize.height;
    NSPoint baseline = NSMakePoint(0,[expressionView baselineOffsetFromBottom]);
    baseline = [contentView convertPoint:baseline fromView:expressionView];
    
    NSPoint expressionOrigin = NSMakePoint(AM_VIEW_MARGIN, - AM_VIEW_MARGIN - expressionViewSize.height);
    NSPoint stringOrigin = NSMakePoint(expressionOrigin.x, expressionOrigin.y - AM_VIEW_MARGIN - stringSize.height);
    [expressionView setFrameOrigin:expressionOrigin];
    [[expressionString animator] setFrameOrigin:stringOrigin];
    
    // Make the box fit the function view
    [container setFrameSize:NSMakeSize(contentViewSize.width+2*AM_VIEW_MARGIN, contentViewSize.height + 2*AM_VIEW_MARGIN)];
    [contentView setFrameOrigin:NSMakePoint(1*AM_VIEW_MARGIN, 1*AM_VIEW_MARGIN)];
    
    [CATransaction commit];
    [[self parentWorksheetController] contentViewController:self isResizingContentTo:expressionView.frame.size  usingAnimationTransaction:NO];
}

-(void)populateView:(AMContentView *)view
{
    // populate from the top view down
    if (view == self.contentView) {
        // Okay, we have the topmost view
        AMDIndexedExpression * iexpr = [self objectWithIndex:0 fromSet:self.amdInsertedObject.indexedExpressions];
        AMDExpression * amdExpr = iexpr.expression;
        
        NSString * originalString = amdExpr.originalString;
        KSMExpression * expr = [self expressionFromString:originalString atIndex:0];
        self.expressionStringView.stringValue = expr.originalString;
        self.expressionView.expression = expr;
        [self layoutInsertedView];
    } else {
        // Other views that are sub to self.functionView, but these might arrive out of order and need to be populated from the top down, so we do nothing here.
    }
}

-(void)deleteContent
{
    [super deleteContent];
    
    // AMFunctionContentController specific delete
    [self.moc deleteObject:self.amdInsertedObject];
}

@end
