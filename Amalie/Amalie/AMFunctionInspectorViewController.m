//
//  AMFunctionInspectorViewController.m
//  Amalie
//
//  Created by Keith Staines on 18/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMFunctionInspectorViewController.h"
#import "AMAmalieDocument.h"
#import "AMFunctionContentViewController.h"
#import "AMFunctionInspectorView.h"
#import "AMInspectorsViewController.h"
#import "AMInspectorView.h"
#import "AMDataRenamer.h"
#import "AMArgumentListViewController.h"
#import "AMDExpression.h"
#import "AMDArgument.h"
#import "AMArgument.h"
#import "AMDArgumentList+Methods.h"
#import "AMDFunctionDef+Methods.h"
#import "AMDName+Methods.h"
#import "AMDataStore.h"
#import "AMNameProviding.h"
#import "KSMExpression.h"
#import "AMArgumentTableRowViewController.h"
#import "AMArgumentTableRowView.h"
#import "AMNamedAndTypedObject.h"
#import "AMKeyboardEditorViewController.h"

@interface AMFunctionInspectorViewController ()
{
    id<AMNameProviding>     _nameProvider;
}

@property (weak, readonly) AMFunctionInspectorView * functionInspectorView;
@property (weak, readonly) AMAmalieDocument * document;
@property (weak, readonly) AMFunctionContentViewController * functionContentViewController;
@end

@implementation AMFunctionInspectorViewController

-(NSString *)nibName
{
    return @"AMFunctionInspectorViewController";
}
- (IBAction)addArgument:(NSButton *)sender {
    NSTableView * argumentTable = self.functionInspectorView.argumentTable;
    NSInteger selectedRow = argumentTable.selectedRow;
    
    // Update datastore. If a row is selected (ie >= 0), we insert beneath that, otherwise we add to the end.
    if (selectedRow >=0) selectedRow++;
    AMDArgument * argument = [self.argumentList addArgumentAtIndex:selectedRow withNameProvider:self.nameProvider];
    if ( argument ) {
        
        selectedRow = [argument.index integerValue];
        
        // Keep the displayed table in sync
        [argumentTable insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:selectedRow] withAnimation:NSTableViewAnimationSlideDown];
        
        NSTableCellView * view = [argumentTable viewAtColumn:0 row:selectedRow makeIfNecessary:NO];
        [self populateTableNameView:(AMArgumentTableRowView*)view withArgument:argument];
        
        // Make sure new row is visible
        [argumentTable scrollRowToVisible:selectedRow];
        
        [argumentTable selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] byExtendingSelection:NO];
        
        [self.argumentListViewController reloadData];
        
    }
    [self dataWasUpdated];
}
- (IBAction)removeArgument:(NSButton *)sender {
    NSTableView * argumentTable = self.functionInspectorView.argumentTable;
    NSInteger selectedRow = argumentTable.selectedRow;
    
    // Quick exit if no row is selected - we aren't just going to delete a random one!
    if (selectedRow < 0) return;
    
    if ([self.argumentList removeArgumentAtIndex:selectedRow]) {
        // Keep the displayed table in sync with the datastore
        [argumentTable removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:selectedRow] withAnimation:NSTableViewAnimationSlideDown];
    }
    [argumentTable selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] byExtendingSelection:NO];
    
    self.argumentListViewController.argumentList = self.argumentList;
    [self dataWasUpdated];
}
- (IBAction)showNameEditor:(id)sender {
    [self showNameEditorForFunctionName:self];
}
- (IBAction)showNameEditorForargumentSubView:(id)sender {
    NSTableView * argumentTable = self.functionInspectorView.argumentTable;
    NSInteger rowIndex = [argumentTable rowForView:sender];
    if (rowIndex >= 0) {
        [self showNameEditorForArgumentAtIndex:rowIndex];
    }
}
-(AMFunctionContentViewController*)functionContentViewController {
    return (AMFunctionContentViewController*)self.delegate.contentViewController;
}
-(id<AMNameProviding>)nameProvider
{
    if (!_nameProvider) {
        _nameProvider = [self.delegate argumentsNameProviderWithArguments:self.functionDef.argumentList];
    }
    return _nameProvider;
}

-(void)reloadData
{
    [super reloadData];
    [[self inspectorView] reloadData];
    self.argumentListViewController.nameProvider = self.nameProvider;
    [self.argumentListViewController reloadData];
}

-(void)setupValuePopup:(NSPopUpButton*)popup
{
    [popup removeAllItems];
    [popup addItemWithTitle:@"Integer"];
    [popup addItemWithTitle:@"Real"];
    [popup addItemWithTitle:@"Vector"];
    [popup addItemWithTitle:@"Matrix"];
    [popup itemAtIndex:0].tag = KSMValueInteger;
    [popup itemAtIndex:1].tag = KSMValueDouble;
    [popup itemAtIndex:2].tag = KSMValueVector;
    [popup itemAtIndex:3].tag = KSMValueMatrix;
    [popup selectItemAtIndex:1];
}
- (IBAction)valueTypePopupChanged:(NSPopUpButton *)sender {
    if (sender == self.functionInspectorView.returnTypePopup) {
        [self updateFunctionReturnType:@(sender.selectedTag)];
    } else {
        NSTableView * argumentTable = self.functionInspectorView.argumentsTable;
        NSInteger row = [argumentTable rowForView:sender];
        AMDArgument * argument = [self.argumentList argumentAtIndex:row];
        AMArgument * arg = [AMArgument argumentFromDataArgument:argument];
        arg.valueType = @(sender.selectedTag);
        [self updateArgumentListWithArgument:arg];
    }
}
-(AMDArgumentList*)argumentList
{
    return self.functionDef.argumentList;
}
-(AMDFunctionDef*)functionDef
{
    return (AMDFunctionDef*)[self amdObject];
}
-(NSString*)expressionString
{
    KSMExpression * expr = [self.delegate.contentViewController expressionForIndex:0];
    return [expr.originalString copy];
}
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (tableView == self.functionInspectorView.argumentsTable) {
        NSUInteger count = self.argumentList.arguments.count;
        return count;
    }
    return 0;
}

-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    AMArgumentTableRowView * returnView = nil;
    if (tableView == self.functionInspectorView.argumentsTable) {
        AMDArgument * argument = [self.argumentList argumentAtIndex:row];
        NSAssert(argument, @"argument in list is nil");
        returnView = [self makeArgumentTableRowView];
        [self populateTableNameView:returnView withArgument:argument];
    }
    return returnView;
}
-(AMArgumentTableRowView*)makeArgumentTableRowView
{
    AMArgumentTableRowViewController * vc = [[AMArgumentTableRowViewController alloc] init];
    AMArgumentTableRowView * rowView = vc.rowView;
    [rowView.showNameEditor setTarget:self];
    [rowView.showNameEditor setAction:@selector(showNameEditorForargumentSubView:)];
    [self setupValuePopup:rowView.valueTypePopup];
    return rowView;
}
-(void)populateTableNameView:(AMArgumentTableRowView*)view withArgument:(AMDArgument*)argument
{
    view.argumentName.attributedString = argument.name.attributedString;
}

-(void)populateTableTypePopupButton:(NSPopUpButton*)button withArgument:(AMDArgument*)argument
{
    [self setupValuePopup:button];
    KSMValueType valueType = argument.valueType.integerValue;
    [button selectItemWithTag:valueType];
    [button setTarget:self];
    [button setAction:NSSelectorFromString(@"valueTypePopupChanged:")];
}
-(AMFunctionInspectorView*)functionInspectorView
{
    return (AMFunctionInspectorView*)self.inspectorView;
}
-(BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    NSString * proposedName = fieldEditor.string;
    if (control == self.functionInspectorView.nameField) {
        return [self isValidFunctionName:proposedName];
    }
    return YES;
}
-(void)controlTextDidChange:(NSNotification *)obj
{
    if (obj.object == self.functionInspectorView.nameField) {
        [self updateFunctionName:self.functionInspectorView.nameField.stringValue];
    }
}
-(void)controlTextDidEndEditing:(NSNotification *)notification
{
    KSMValueType mathValue;
    NSError * error;
    if (notification.object == self.functionInspectorView.nameField) {
        NSString * proposedName = self.functionInspectorView.nameField.stringValue;
        mathValue = self.functionDef.returnType.integerValue;
        if (![self updateFunctionName:proposedName]) {
            //
            error = [self validationErrorForProposedFunctionName:proposedName];
            
        }
    } else if (notification.object == self.functionInspectorView.expressionString) {
        [self updateExpression:self.functionInspectorView.expressionString.stringValue];
    } else {
        NSInteger selectedRow = self.functionInspectorView.argumentTable.selectedRow;
        AMDArgument * argument = [self.argumentList argumentAtIndex:selectedRow];
        AMArgument * arg = [AMArgument argumentFromDataArgument:argument];
        arg.name.string = ((NSTextField*)notification.object).stringValue;
        [self updateArgumentListWithArgument:arg];
    }
}

#pragma mark - Update methods and undo manager -
-(BOOL)updateExpression:(NSString*)expressionString
{
    return YES;
}
-(BOOL)updateFunctionName:(NSString*)name
{
    if ( ![self isValidFunctionName:name] ) {
        return NO;
    }
    AMDataRenamer * renamer = [AMDataRenamer renamerForObject:self.functionDef nameProvider:self.nameProvider];
    [[self undoManager] registerUndoWithTarget:self selector:@selector(updateFunctionName:) object:self.functionDef.name.string];
    [renamer updateNameString:[name copy]];
    [self reloadData];
    [self dataWasUpdated];
    return YES;
}
-(void)updateFunctionReturnType:(NSNumber*)returnType
{
    AMDataRenamer * renamer = [AMDataRenamer renamerForObject:self.functionDef nameProvider:self.nameProvider];
    [[self undoManager] registerUndoWithTarget:self selector:@selector(updateFunctionReturnType:)   object:self.functionDef.returnType];
    [renamer updateValueType:returnType];
    [self reloadData];
    [self dataWasUpdated];
}
-(void)updateArgumentListWithArgument:(AMArgument*)arg
{
    NSInteger index = arg.index.integerValue;
    AMDArgument * argD = [self.argumentList argumentAtIndex:index];
    AMArgument * oldArg = [AMArgument argumentFromDataArgument:argD];
    [[self undoManager] registerUndoWithTarget:self selector:@selector(updateArgumentListWithArgument:) object:oldArg];
    
    AMDataRenamer * renamer = [AMDataRenamer renamerForObject:argD nameProvider:self.nameProvider];
    [renamer updateNameString:[arg.name.string copy]];
    [renamer updateValueType:arg.valueType];
    [self reloadData];
    [self dataWasUpdated];
}
-(BOOL)isValidFunctionName:(NSString*)string
{
    AMDName * name = self.functionDef.name;
    return [name isValidNameString:string];
}
-(NSError*)validationErrorForProposedFunctionName:(NSString*)proposedName
{
    NSError * error;
    AMDName * name = self.functionDef.name;
    [name isValidNameString:proposedName error:&error];
    return error;
}
-(NSUndoManager*)undoManager
{
    return [AMDataStore sharedDataStore].moc.undoManager;
}
-(AMAmalieDocument*)document
{
    return self.functionContentViewController.document;
}
-(AMDExpression*)expression
{
    return self.functionContentViewController.expression;
}

#pragma mark - Show expression and name editors -
- (IBAction)showExpressionEditor:(id)sender {
    [self.document showExpressionEditorWithExpression:self.expression nameProvider:self.nameProvider context:[self expression] target:self action:@selector(expressionEditorDidFinish:)];
}
- (void)showNameEditorForFunctionName:(id)sender {
    [self.document showNameEditorWithName:self.functionDef.name nameProvider:self.nameProvider context:self.functionDef target:self action:@selector(nameEditorDidFinish:)];
}
- (void)showNameEditorForArgumentAtIndex:(NSUInteger)index {
    AMDArgument * argument = [self.functionDef.argumentList argumentAtIndex:index];
    AMDName * amdName = argument.name;
    [self.document showNameEditorWithName:amdName nameProvider:self.nameProvider context:argument target:self action:@selector(nameEditorDidFinish:)];
}
-(void)expressionEditorDidFinish:(AMKeyboardEditorViewController*)editor
{
    
}
-(void)nameEditorDidFinish:(AMKeyboardEditorViewController*)editor
{
    id context = editor.context;
    if ([context isKindOfClass:[AMDFunctionDef class]]) {
        [self updateFunctionName:editor.stringValue];
        [self reloadData];
        return;
    } else if ([context isKindOfClass:[AMDArgument class]]) {
        AMArgument * arg = [AMArgument argumentFromDataArgument:context];
        arg.name.string = editor.stringValue;
        [self updateArgumentListWithArgument:arg];
        return;
    }
    NSAssert(NO, @"The context was not recognised so we can't work out what to do");
}


@end
