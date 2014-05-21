//
//  AMFunctionInspectorViewController.m
//  Amalie
//
//  Created by Keith Staines on 18/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMFunctionInspectorViewController.h"
#import "AMFunctionInspectorView.h"
#import "AMInspectorsViewController.h"
#import "AMInspectorView.h"
#import "AMDataRenamer.h"
#import "AMArgumentListViewController.h"
#import "AMDArgument.h"
#import "AMArgument.h"
#import "AMDArgumentList+Methods.h"
#import "AMDFunctionDef+Methods.h"
#import "AMDName.h"
#import "AMDataStore.h"
#import "AMNameProviding.h"

@interface AMFunctionInspectorViewController ()
{
    id<AMNameProviding>     _nameProvider;
}

@property (weak,readonly) AMFunctionInspectorView * functionInspectorView;
@end

@implementation AMFunctionInspectorViewController

-(NSString *)nibName
{
    return @"AMFunctionInspectorViewController";
}
- (IBAction)showNameEditor:(id)sender {
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
        [self populateTableNameView:view withArgument:argument];
        
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
- (IBAction)showExpressionEditor:(id)sender {
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
    NSView * returnView = nil;
    if (tableView == self.functionInspectorView.argumentsTable) {
        AMDArgument * argument = [self.argumentList argumentAtIndex:row];
        NSAssert(argument, @"argument in list is nil");
        if ( [tableColumn.identifier isEqualToString:@"NameColumn"] ) {
            NSTableCellView * view = nil;
            view = [tableView makeViewWithIdentifier:@"NameColumnView" owner:self];
            [self populateTableNameView:view withArgument:argument];
            returnView = view;
        } else if ([tableColumn.identifier isEqualToString:@"TypeColumn"] ) {
            NSPopUpButton * view = nil;
            view = [tableView makeViewWithIdentifier:@"TypeColumnView" owner:self];
            NSPopUpButton * popupButton = (NSPopUpButton*)view;
            [self populateTableTypeView:popupButton withArgument:argument];
            returnView = view;
        }
    }
    return returnView;
}

-(void)populateTableNameView:(NSTableCellView*)view withArgument:(AMDArgument*)argument
{
    view.textField.attributedStringValue = argument.name.attributedString;
    view.textField.delegate = self;
}

-(void)populateTableTypeView:(NSPopUpButton*)button withArgument:(AMDArgument*)argument
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
-(void)controlTextDidEndEditing:(NSNotification *)notification
{
    KSMValueType mathValue;
    if (notification.object == self.functionInspectorView.nameField) {
        NSString * proposedName = self.functionInspectorView.nameField.stringValue;
        mathValue = self.functionDef.returnType.integerValue;
        [self updateFunctionName:proposedName];
    } else {
        NSInteger selectedRow = self.functionInspectorView.argumentTable.selectedRow;
        AMDArgument * argument = [self.argumentList argumentAtIndex:selectedRow];
        AMArgument * arg = [AMArgument argumentFromDataArgument:argument];
        arg.name.string = ((NSTextField*)notification.object).stringValue;
        [self updateArgumentListWithArgument:arg];
    }
}

#pragma mark - Update methods and undo manager -
-(void)updateFunctionName:(NSString*)name
{
    AMDataRenamer * renamer = [AMDataRenamer renamerForObject:self.functionDef nameProvider:self.nameProvider];
    [[self undoManager] registerUndoWithTarget:self selector:@selector(updateFunctionName:) object:self.functionDef.name.string];
    [renamer updateNameString:[name copy]];
    [self reloadData];
    [self dataWasUpdated];
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

-(NSUndoManager*)undoManager
{
    return [AMDataStore sharedDataStore].moc.undoManager;
}


@end
