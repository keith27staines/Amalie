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
#import "AMExpandingTextFieldView.h"
#import "AMKeyboardEditorViewController.h"

// core data generated objects
#import "AMDInsertedObject.h"
#import "AMDFunctionDef.h"
#import "AMDIndexedExpression.h"
#import "AMDExpression.h"
#import "AMDArgument+Methods.h"
#import "AMDName+Methods.h"
#import "AMDataStore.h"
#import "AMDArgumentList+Methods.h"

static NSUInteger const kAMIndexRHS;

@interface AMFunctionContentViewController ()
{
    NSString                            * _expressionString;
    NSString                            * _nameString;
    __weak NSTextField                  * _nameField;
    __weak AMExpandingTextFieldView     * _expressionStringView;
    __weak AMArgumentListViewController * _argumentListViewController;
    NSMutableDictionary                 * _viewDictionary;
    AMExpressionFormatContextNode       * _contextNode;
    AMPersistedObjectWithArgumentsNameProvider * _persistedObjectNameProvider;
    BOOL                                  _viewPrepared;
}
@property (weak) IBOutlet AMArgumentListViewController * argumentListViewController;
@property (strong) AMExpressionFormatContextNode * contextNode;
@property (weak,readonly) AMArgumentListView * argumentListView;
@property (weak) AMTextView * nameView;
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
    argumentsView.showEqualsSign = YES;
    argumentsView.scriptingLevel = 0;
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

-(NSString *)nameString
{
    return [_nameString copy];
}
-(void)setNameString:(NSString *)nameString
{
    if (!nameString) {
        nameString = @"";
    }
    if ([nameString isEqualToString:_nameString]) {
        return;
    }
    AMPersistedObjectNameProvider * namer = self.nameProvider;
    if ( [namer validateProposedName:nameString forType:AMInsertableTypeFunction error:nil] ) {
        [self.undoManager registerUndoWithTarget:self selector:@selector(setNameString:) object:self.nameString];
        [self.amdInsertedObject.name setNameAndGenerateAttributedNameFrom:nameString valueType:KSMValueInteger nameProvider:namer];
        _nameString = nameString;
    }
}
-(void)setArgumentString:(AMDArgument*)argument string:(NSString*)string
{
    NSAssert(argument && string, @"Cannot set a null argument or object");
    if (!string) {
        string = @"";
    }
    if ([argument.name.string isEqualToString:string]) {
        return;
    }
    NSMutableDictionary * dictionary;
    dictionary = [@{@"argument": argument, @"string":argument.name.string} mutableCopy];
    [self.undoManager registerUndoWithTarget:self selector:@selector(setArgumentStringFromDictionary:) object:dictionary];
    dictionary[@"string"] = string;
    [self setArgumentStringFromDictionary:dictionary];
    [self reloadData];
}
-(void)setArgumentStringFromDictionary:(NSDictionary*)dictionary
{
    AMDArgument * argument = dictionary[@"argument"];
    NSString * string = dictionary[@"string"];
    argument.name.string = string;
}
-(void)setExpressionString:(NSString*)expressionString
{
    if (!expressionString) {
        expressionString = @"";
    }
    if (_expressionString && [_expressionString isEqualToString:expressionString]) {
        return;
    }
    [self.undoManager registerUndoWithTarget:self selector:@selector(setExpressionString:) object:_expressionString];
    _expressionString = [expressionString copy];
    KSMExpression * expr;
    expr = [self expressionFromString:expressionString atIndex:kAMIndexRHS];
    [self reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:AMNotificationExpressionStringWasEdited object:self];

}
-(NSString*)expressionString
{
    return [_expressionString copy];
}
-(void)setFocusOnView:(NSView*)view
{
    BOOL changedFirstResponder = [self.view.window makeFirstResponder:view];
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
-(NSView *)view
{
    NSView * view = [super view];
    if (!_viewPrepared) {
        _viewPrepared = YES;
        AMFunctionContentView * fview = (AMFunctionContentView*)view;
        self.expressionView = fview.expressionView;
        self.expressionStringView = fview.expressionStringView;
        self.expressionView.delegate = self;
        self.expressionView.dataSource = self;
        self.expressionStringView.delegate = self;
        self.nameView = fview.nameView;
        fview.propertiesButton.target = self;
        fview.propertiesButton.action = @selector(showPopover:);
        fview.expressionEditorButton.target = self;
        //fview.expressionEditorButton.action = @selector(showExpressionEditor:);
        [self setupArgumentListView];
        [self reloadData];
    }
    return view;
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
    if (view == self.view) {
        [self reloadData];
    } else {
        // Other views that are subviews of self.functionView, but these might arrive out of order and need to be populated from the top down, so we do nothing here.
    }
}

-(void)reloadData
{
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
    [self.view setNeedsUpdateConstraints:YES];
    [self.view setNeedsDisplay:YES];
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
    [self.editPopover showRelativeToRect:sender.bounds ofView:self.view preferredEdge:NSMaxYEdge];
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
    NSAssert(_persistedObjectNameProvider, @"Failed to return a name provider");
    return _persistedObjectNameProvider;
}
@end
