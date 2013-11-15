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
#import "AMFunctionEditorViewController.h"
#import "AMArgumentListViewController.h"
#import "AMArgumentListView.h"


// core data generated objects
#import "AMDInsertedObject.h"
#import "AMDFunctionDef.h"
#import "AMDIndexedExpression.h"
#import "AMDExpression.h"
#import "AMDName.h"
#import "AMDataStore.h"
#import "AMDArgumentList+Methods.h"

static NSUInteger const kAMIndexRHS;

@interface AMFunctionContentViewController ()
{
    __weak NSTextField                  * _nameField;
    __weak NSTextField                  * _expressionStringView;
    __weak AMArgumentListViewController * _argumentListViewController;
    NSMutableDictionary                 * _viewDictionary;
}
@property (weak) IBOutlet AMArgumentListViewController * argumentListViewController;

@property (readonly) AMArgumentListView * argumentListView;
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
    [self setupNameView];
    [self setupEqualsView];
    [self setupExpressionStringView];
}


-(BOOL)isConstant
{
    return NO;
}

-(BOOL)isVariable
{
    return NO;
}

-(AMArgumentListView *)argumentListView
{
    return (AMArgumentListView *)self.argumentListViewController.view;
}

-(void)setupNameView
{
    [self.nameView setDelegate:self];
    [self.nameView setFont:self.standardFont];
    SEL callback;
    callback = NSSelectorFromString(@"nameStringDidBeginEditing:");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:callback name:NSControlTextDidBeginEditingNotification object:self.nameView];
    
    callback = NSSelectorFromString(@"nameStringDidChange:");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:callback name:NSControlTextDidChangeNotification object:self.nameView];
    
    callback = NSSelectorFromString(@"nameStringDidEndEditing:");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:callback name:NSControlTextDidEndEditingNotification object:self.nameView];
    [self.nameView sizeToFit];
}

-(void)setupEqualsView
{
    [self.equalsSignView setFont:self.standardFont];
    self.equalsSignView.stringValue = self.equalsSignView.stringValue;
    [self.equalsSignView sizeToFit];
}

-(NSDictionary*)viewDictionary
{
    if (!_viewDictionary) {
        _viewDictionary = [@{@"nameView": self.nameView,
                            @"expressionView":      self.expressionView,
                            @"expressionString":    self.expressionStringView,
                            @"argumentView":        self.argumentListView,
                            @"popupButton":         self.popupButton
                            } mutableCopy];
    }
    return _viewDictionary;
}

-(void)setupArgumentListView
{
    // Before we can do anything with the view we have to load it
    self.argumentListViewController.argumentList = self.amdFunctionDef.argumentList;
    [self.argumentListViewController setFont:self.standardFont];
    [self.argumentListView setAutoFitContent:YES];
    
    [self.contentView addSubview:self.argumentListView];
    NSArray * constraints;
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[nameView]-[argumentView]"
                                                                              options:NSLayoutFormatAlignAllBaseline
                                                                              metrics:nil
                                                           views:self.viewDictionary];
    
    for (NSLayoutConstraint * constraint in constraints) {
        NSView * v1 = constraint.firstItem;
        NSView * v2 = constraint.secondItem;
        NSView * ancestor = [v1 ancestorSharedWithView:v2];
        [ancestor addConstraint:constraint];
    }
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

-(void)nameStringDidBeginEditing:(NSNotification*)notification
{

}

- (void)nameStringDidChange:(NSNotification*)notification
{
    [self nameWasEdited];
}

-(void)nameStringDidEndEditing:(NSNotification*)notification
{
    [self nameStringWantsChange];

}

-(void)nameStringWantsChange
{
    NSAttributedString * proposedName = self.nameView.attributedStringValue;
    if ( [proposedName.string isEqualToString:self.attributedName.string] ) {
        // Nothing to do because the name has been changed back to the value already stored
        return;
    }
    
    NSError * error = nil;
    BOOL changed = [self changeNameIfValid:self.nameView.attributedStringValue error:&error];
    if (changed) {
        // Change accepted
        [self setFocusOnView:self.expressionStringView];
    } else {
        // Change rejected
        if (error) [NSApp presentError:error];
    }
}

-(void)nameWasEdited
{
    NSSize size = [self.nameView.attributedStringValue size];
    [self.nameView sizeToFit];
    [self.nameView setFrameSize:NSMakeSize(size.width + 15, self.nameView.frame.size.height)];
    [self layoutInsertedViewAndCloseTransaction:YES];
    [self.nameView setNeedsDisplay:YES];
    if ( [self.nameView.attributedStringValue isEqualToAttributedString:self.attributedName] ) {
        return;
    }
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
        [self setFocusOnView:self.nameView];
    } else {
        // Change rejected
    }
}

-(void)expressionStringWasEdited
{
    AMExpressionNodeView * expressionView = self.expressionView;
    KSMExpression * expr;
    expr = [self expressionFromString:self.expressionStringView.stringValue atIndex:kAMIndexRHS];
    expressionView.expression = expr;
    [self layoutInsertedViewAndCloseTransaction:YES];
    [expressionView setNeedsDisplay:YES];
}

-(void)setFocusOnView:(NSView*)view
{
    BOOL changedFirstResponder = [self.contentView.window makeFirstResponder:view];
    if (changedFirstResponder) {
        [self putInsertionPointAtEndOfField];
    }
}

-(void)putInsertionPointAtEndOfField
{
    NSText* textEditor = [self.nameView.window fieldEditor:YES forObject:self.nameView];
    NSRange range = NSMakeRange(textEditor.string.length, 0);
    [textEditor setSelectedRange:range];
}

-(void)layoutInsertedViewAndCloseTransaction:(BOOL)closeTransaction
{
    [super layoutInsertedViewAndCloseTransaction:NO];
    
    CGFloat const AM_VIEW_MARGIN      = 19.0f;
    CGFloat const AM_MIN_STRING_WIDTH = 300.0f;
    
    AMExpressionNodeView * expressionView = self.expressionView;
    NSTextField * expressionString = self.expressionStringView;
    AMFunctionContentView * functionView = self.contentView;
    NSView * container = [functionView superview];
    AMNameView * name = [functionView nameView];
    [name setUseQuotientBaselining:expressionView.requiresQuotientBaselining];
    AMArgumentListView * argumentView = self.argumentListView;
    NSView * equalsView = self.equalsSignView;
    
    // The sizes of the important nested and sibling views
    NSSize expressionViewSize   = expressionView.intrinsicContentSize;
    NSSize stringSize =  NSMakeSize( [[expressionString stringValue] sizeWithAttributes:@{NSFontAttributeName: expressionString.font}].width + 10, expressionString.frame.size.height);
    NSSize argumentListSize = NSZeroSize;
    [argumentView setHidden:YES];
    if (self.amdFunctionDef.argumentList.arguments.count > 0) {
        argumentListSize = self.argumentListView.fittingSize;
        [argumentView setHidden:NO];
        [argumentView setNeedsDisplay:YES];
    }

    if (stringSize.width < AM_MIN_STRING_WIDTH) stringSize.width = AM_MIN_STRING_WIDTH;
    stringSize.width = fmaxf(expressionViewSize.width, stringSize.width);
    
    NSSize functionViewSize = NSMakeSize(AM_VIEW_MARGIN + name.frame.size.width + argumentListSize.width + equalsView.fittingSize.width + AM_VIEW_MARGIN + stringSize.width + AM_VIEW_MARGIN,
                                     AM_VIEW_MARGIN + expressionViewSize.height + AM_VIEW_MARGIN + stringSize.height + AM_VIEW_MARGIN);
    
    // do the resizing
    [[functionView animator] setFrameSize:functionViewSize];
    [[expressionView animator]   setFrameSize:expressionViewSize];
    [[expressionString animator] setFrameSize:stringSize];
    
    // and repositioning
    

    CGFloat expressionY = functionViewSize.height - AM_VIEW_MARGIN - expressionViewSize.height;
    NSPoint baseline = NSMakePoint(0,[expressionView baselineOffsetFromBottom]);
    baseline = [functionView convertPoint:baseline fromView:expressionView];
    if (expressionView.useQuotientBaselining) {
        [name setFrameOrigin:NSMakePoint(AM_VIEW_MARGIN, baseline.y - name.baselineOffsetFromBottom)];
    } else {
        [name setFrameOrigin:NSMakePoint(AM_VIEW_MARGIN, expressionY)];
    }
    // [argumentView setFrameOrigin:NSMakePoint(name.frame.origin.x + name.frame.size.width, baseline.y)];
    
    [equalsView setFrameOrigin:NSMakePoint(name.frame.origin.x + name.frame.size.width + argumentListSize.width, baseline.y)];

    
    NSPoint expressionOrigin = NSMakePoint(2*AM_VIEW_MARGIN + name.frame.size.width + argumentListSize.width+equalsView.fittingSize.width,
                                           
                                           functionViewSize.height - AM_VIEW_MARGIN - expressionViewSize.height);
    NSPoint stringOrigin = NSMakePoint(expressionOrigin.x, expressionOrigin.y - AM_VIEW_MARGIN - stringSize.height);
    [expressionView setFrameOrigin:expressionOrigin];
    [[expressionString animator] setFrameOrigin:stringOrigin];
    
    // Make the box fit the function view
    [container setFrameSize:NSMakeSize(functionViewSize.width+2*AM_VIEW_MARGIN, functionViewSize.height + 2*AM_VIEW_MARGIN)];
    [functionView setFrameOrigin:NSMakePoint(1*AM_VIEW_MARGIN, 1*AM_VIEW_MARGIN)];
    
    if (closeTransaction) {
        [super closeLayoutTransaction];
    }
}

-(void)populateView:(AMContentView *)view
{    
    // populate from the top view down
    if (view == self.contentView) {
        // Okay, we have the topmost view
        AMDFunctionDef * funcDef = self.amdFunctionDef;
        AMDIndexedExpression * iexpr = [self objectWithIndex:0 fromSet:funcDef.indexedExpressions];
        AMDExpression * amdExpr = iexpr.expression;
        
        NSString * originalString = amdExpr.originalString;
        KSMExpression * expr = [self expressionFromString:originalString atIndex:0];
        self.expressionStringView.stringValue = expr.originalString;
        self.expressionView.expression = expr;
        
        self.nameView.attributedStringValue = funcDef.name.attributedString;
        [self.nameView sizeToFit];
        [self setupArgumentListView];
        [self layoutInsertedViewAndCloseTransaction:YES];
    } else {
        // Other views that are sub to self.functionView, but these might arrive out of order and need to be populated from the top down, so we do nothing here.
    }
}

-(AMDFunctionDef*)amdFunctionDef
{
    return (AMDFunctionDef*)self.amdInsertedObject;
}

-(void)deleteContent
{
    [super deleteContent];

    // AMFunctionContentController specific delete
    [self.moc deleteObject:self.amdFunctionDef];

}

- (IBAction)showPopover:(NSButton *)sender {
    [self.editPopover showRelativeToRect:sender.frame ofView:self.contentView preferredEdge:NSMaxYEdge];
    AMFunctionEditorViewController * vc = ((AMFunctionEditorViewController*)self.editPopover.contentViewController);
    self.editPopover.delegate = vc;
}

- (IBAction)cancelPopover:(NSButton *)sender {
    [self.editPopover close];
    [self.undoManager undoNestedGroup];
}

- (IBAction)acceptEditPopover:(id)sender {
        [self.editPopover close];
    self.argumentListViewController.argumentList = self.amdFunctionDef.argumentList;
    [self layoutInsertedViewAndCloseTransaction:YES];
}


@end
