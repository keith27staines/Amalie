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
#import "AMTextView.h"
#import "AMFunctionEditorViewController.h"
#import "AMArgumentListViewController.h"
#import "AMArgumentListView.h"
#import "AMNameProvider.h"

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

-(void)applyUserPreferences
{
    [super applyUserPreferences];
    [self.expressionStringView setFont:self.fixedWidthFont];
    [self.equalsSignView sizeToFit];
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
    AMArgumentListView * argumentListView;
    argumentListView = (AMArgumentListView *)self.argumentListViewController.view;
    [argumentListView setTranslatesAutoresizingMaskIntoConstraints:NO];
    return argumentListView;
}

-(void)setupNameView
{
    SEL callback;
    callback = NSSelectorFromString(@"nameStringDidBeginEditing:");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:callback name:NSControlTextDidBeginEditingNotification object:self.nameView];
    
    callback = NSSelectorFromString(@"nameStringDidChange:");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:callback name:NSControlTextDidChangeNotification object:self.nameView];
    
    callback = NSSelectorFromString(@"nameStringDidEndEditing:");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:callback name:NSControlTextDidEndEditingNotification object:self.nameView];
}

-(void)setupEqualsView
{
    self.equalsSignView.stringValue = self.equalsSignView.stringValue;
}

-(void)setupArgumentListView
{
    // Before we can do anything with the view we have to load it
    self.argumentListViewController.argumentList = self.amdFunctionDef.argumentList;
    AMArgumentListView * argumentsView = self.argumentListView;
    [argumentsView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:argumentsView];
    AMFunctionContentView * fv = (AMFunctionContentView *)self.contentView;
    fv.argumentListView = argumentsView;
}

-(void)setupExpressionStringView
{
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
    NSAttributedString * proposedName = self.nameView.attributedString;
    if ( [proposedName.string isEqualToString:self.attributedName.string] ) {
        // Nothing to do because the name has been changed back to the value already stored
        return;
    }
    
    NSError * error = nil;
    BOOL changed = [self changeNameIfValid:self.nameView.attributedString error:&error];
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
    NSSize size = [self.nameView.attributedString size];
    [self.nameView setFrameSize:NSMakeSize(size.width + 15, self.nameView.frame.size.height)];
    [self.nameView setNeedsDisplay:YES];
    if ( [self.nameView.attributedString isEqualToAttributedString:self.attributedName] ) {
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
        [self.expressionView resetWithgroupID:self.groupID
                                   expression:expr
                               scriptingLevel:0
                                     delegate:self
                               displayOptions:nil
                                  scaleFactor:1];
        
        self.nameView.attributedString = funcDef.name.attributedString;
        [self setupArgumentListView];
        [self.expressionView setNeedsDisplay:YES];
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
}

#pragma mark - AMContentViewDataSource overrides -

-(id<AMNameProviding>)viewRequiresNameProvider:(AMContentView *)view
{
    return [self nameProvider];
}
#pragma mark - Misc -
-(id<AMNameProviding>)nameProvider
{
    static AMNameProvider * _nameProvider;
    if (!_nameProvider) {
        _nameProvider = [AMNameProvider nameProviderWithDummyVariables:self.amdFunctionDef.argumentList];
    }
    return _nameProvider;
}
#pragma mark - Misc -



@end
