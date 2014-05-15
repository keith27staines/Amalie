//
//  AMFunctionContentViewController.m
//  Amalie
//
//  Created by Keith Staines on 03/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMExpressionNodeView;
@class AMEquationContentView;

#import "AMFunctionContentViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "KSMMathSheet.h"
#import "KSMExpression.h"
#import "AMExpressionFormatContextNode.h"
#import "AMEquationContentViewController.h"
#import "AMFunctionContentView.h"
#import "AMExpressionNodeView.h"
#import "AMUserPreferences.h"
#import "AMAmalieDocument.h"
#import "AMTextView.h"
#import "AMFunctionPropertiesViewController.h"
#import "AMArgumentListViewController.h"
#import "AMArgumentListView.h"
#import "AMPersistedObjectWithArgumentsNameProvider.h"
#import "AMNameProviding.h"

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
    NSString                            * _expressionString;
    __weak NSTextField                  * _nameField;
    __weak NSTextField                  * _expressionStringView;
    __weak AMArgumentListViewController * _argumentListViewController;
    NSMutableDictionary                 * _viewDictionary;
    AMExpressionFormatContextNode             * _contextNode;
    AMPersistedObjectWithArgumentsNameProvider * _persistedObjectNameProvider;
}
@property (weak) IBOutlet AMArgumentListViewController * argumentListViewController;
@property (strong) AMExpressionFormatContextNode * contextNode;
@property (copy) NSString * expressionString;
@property (readonly) AMArgumentListView * argumentListView;
@end

@implementation AMFunctionContentViewController

-(NSString *)nibName
{
    return @"AMFunctionContentView";
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupNotifications];
    self.argumentListViewController.nameProvider = self.nameProvider;
}

-(void)applyUserPreferences
{
    [super applyUserPreferences];
    [self.expressionStringView setFont:self.fixedWidthFont];
}

-(BOOL)isConstant
{
    return NO;
}

-(BOOL)isVariable
{
    return NO;
}

-(AMAmalieDocument *)document
{
    return super.document;
}
-(void)setDocument:(AMAmalieDocument *)document
{
    super.document = document;
}

-(AMArgumentListView *)argumentListView
{
    AMArgumentListView * argumentListView;
    argumentListView = (AMArgumentListView *)self.argumentListViewController.view;
    [argumentListView setTranslatesAutoresizingMaskIntoConstraints:NO];
    return argumentListView;
}

-(void)setupNotifications
{
    SEL callback;
    
    // Notifications from nameView
    callback = NSSelectorFromString(@"nameStringDidBeginEditing:");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:callback name:NSControlTextDidBeginEditingNotification object:self.nameView];
    
    callback = NSSelectorFromString(@"nameStringDidChange:");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:callback name:NSControlTextDidChangeNotification object:self.nameView];
    
    callback = NSSelectorFromString(@"nameStringDidEndEditing:");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:callback name:NSControlTextDidEndEditingNotification object:self.nameView];
    
    // Notifications from expressionStringView
    callback = NSSelectorFromString(@"expressionStringDidBeginEditing:");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:callback name:NSControlTextDidBeginEditingNotification object:self.expressionStringView];
    
    callback = NSSelectorFromString(@"expressionStringDidChange:");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:callback name:NSControlTextDidChangeNotification object:self.expressionStringView];
    
    callback = NSSelectorFromString(@"expressionStringDidEndEditing:");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:callback name:NSControlTextDidEndEditingNotification object:self.expressionStringView];
    
    // Notification from function properties editor
    callback = @selector(functionPropertiesDidEndEditing:);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:callback name:AMFunctionPropertiesDidEndEditingNotification object:self.editPopover.contentViewController];

}

-(void)setupArgumentListView
{
    self.argumentListViewController.nameProvider = self.nameProvider;
    self.argumentListViewController.argumentList = self.amdFunctionDef.argumentList;
    AMArgumentListView * argumentsView = self.argumentListView;
    [argumentsView setTranslatesAutoresizingMaskIntoConstraints:NO];
    argumentsView.showEqualsSign = YES;
    argumentsView.scriptingLevel = 0;
    [self.contentView addSubview:argumentsView];
    AMFunctionContentView * fv = (AMFunctionContentView *)self.contentView;
    fv.argumentListView = argumentsView;
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
    NSString * expressionString = self.expressionStringView.stringValue;
    [self setExpressionString:expressionString];
}
-(void)setExpressionString:(NSString*)expressionString
{
    
    if (_expressionString && [_expressionString isEqualToString:expressionString]) {
        return;
    }
    _expressionString = [expressionString copy];
    KSMExpression * expr;
    expr = [self expressionFromString:expressionString atIndex:kAMIndexRHS];
    [self resetExpressionViewWithExpression:expr];
    [self.contentView setNeedsUpdateConstraints:YES];
    [self.contentView setNeedsDisplay:YES];
}
-(NSString*)expressionString
{
    return [_expressionString copy];
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

-(void)resetExpressionViewWithExpression:(KSMExpression*)expr
{
    self.contextNode = [[AMExpressionFormatContextNode alloc]
                        initWithExpression:expr
                        parent:nil
                        asLeftNode:NO
                        asRightNode:NO
                        dataSource:self
                        hideRedundantBrackets:YES
                        cascadeBracketHiding:YES];
    
    [self.expressionView resetWithgroupID:self.groupID
                               expression:expr
                           scriptingLevel:0
                                 delegate:self
                               dataSource:self
                           displayOptions:nil
                              scaleFactor:1
                              contextNode:self.contextNode];
    [self.expressionView setNeedsDisplay:YES];
}

-(void)populateView:(AMContentView *)view
{
    // populate from the top view down
    if (view == self.contentView) {
        [self reloadData];
        [self setupArgumentListView];
    } else {
        // Other views that are subviews of self.functionView, but these might arrive out of order and need to be populated from the top down, so we do nothing here.
    }
}

-(void)reloadData
{
    [self.contentView removeDynamicConstraints];
    AMDFunctionDef * funcDef = self.amdFunctionDef;
    AMDExpression * amdExpr = [self expression];
    
    NSString * originalString = amdExpr.originalString;
    KSMExpression * expr = [self expressionFromString:originalString atIndex:0];
    self.expressionStringView.stringValue = expr.originalString;
    [self resetExpressionViewWithExpression:expr];
    self.nameView.attributedString = [self.nameProvider attributedStringForObject:funcDef];
    [self.argumentListViewController reloadData];
    [self.argumentListView setNeedsUpdateConstraints:YES];
    
    [self.expressionView setNeedsUpdateConstraints:YES];
    [self.nameView setNeedsUpdateConstraints:YES];
    [self.contentView setNeedsUpdateConstraints:YES];
    [self.contentView setNeedsDisplay:YES];
}
-(AMDIndexedExpression*)indexedExpression
{
    return [self objectWithIndex:0 fromSet:self.amdFunctionDef.indexedExpressions];
}
-(AMDExpression*)expression
{
    AMDIndexedExpression * iexpr = [self indexedExpression];
    AMDExpression * amdExpr = iexpr.expression;
    return amdExpr;
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
    AMFunctionPropertiesViewController * vc = ((AMFunctionPropertiesViewController*)self.editPopover.contentViewController);
    vc.functionDef = self.amdFunctionDef;
    vc.nameProvider = self.nameProvider;
    self.editPopover.delegate = self;
    [vc reloadData];
    [self.editPopover showRelativeToRect:sender.bounds ofView:self.contentView preferredEdge:NSMaxYEdge];
}

- (void)functionPropertiesDidEndEditing:(NSNotification*)notification
{
    [self.editPopover close]; // will trigger popoverDidCloseNotifiation,where edits are processed by reloading data
}

#pragma mark - NSPopover delegate -
-(void)popoverDidClose:(NSNotification *)notification
{
    [self reloadData];
}

#pragma mark - AMContentViewDataSource overrides -

-(id<AMNameProviding>)viewRequiresNameProvider:(AMContentView *)view
{
    return [self nameProvider];
}
#pragma mark - Name provider -
-(id<AMNameProviding>)nameProvider
{
    if (!_persistedObjectNameProvider) {
        _persistedObjectNameProvider = [self.document argumentsNameProviderWithArguments:self.amdFunctionDef.argumentList];
    }
    return _persistedObjectNameProvider;
}
#pragma mark - Show expression editor -

- (IBAction)showExpressionEditor:(id)sender {
    [self.document showExpressionEditorWithExpression:self.expression nameProvider:self.nameProvider target:self action:@selector(expressionEditorFinishedWithString:)];
}
-(void)expressionEditorFinishedWithString:(NSString*)string
{
    [self setExpressionString:string];
}
@end
