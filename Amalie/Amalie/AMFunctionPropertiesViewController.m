//
//  AMFunctionPropertiesViewController.m
//  Amalie
//
//  Created by Keith Staines on 04/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMFunctionPropertiesViewController.h"
#import "AMFunctionPropertiesView.h"
#import "AMDataStore.h"
#import "AMDArgumentList+Methods.h"
#import "AMDArgumentList.h"
#import "AMDArgument+Methods.h"
#import "AMDFunctionDef.h"
#import "AMDName+Methods.h"
#import "KSMMathValue.h"
#import "AMFunctionContentViewController.h"
#import "NSString+KSMMath.h"
#import "AMArgumentListViewController.h"
#import "AMArgumentListView.h"
#import "AMAmalieDocument.h"
#import "AMPersistedObjectNameProvider.h"
#import "AMDataRenamer.h"

NSString * const AMFunctionPropertiesDidEndEditingNotification = @"AMFunctionPropertiesDidEndEditingNotification";

@interface AMFunctionPropertiesViewController ()
{
    BOOL _isSetup;
    BOOL _popoverShowing;
    __weak AMDFunctionDef * _functionDef;
}

@property (weak, readonly) AMDArgumentList * argumentList;
@property (weak,readonly) AMFunctionPropertiesView * functionPropertiesView;
@end

@implementation AMFunctionPropertiesViewController

-(NSString *)nibName
{
    return @"AMFunctionPropertiesViewController";
}
-(NSView *)view
{
    NSView * view = [super view]; // force nib to load early
    if (!_isSetup) {
        _isSetup = YES;
        self.functionPropertiesView.nameField.delegate = self;
        ((AMFunctionPropertiesView*)view).delegate = self;
        [self setupArgumentListViewController];
    }
    return view;
}
-(AMFunctionPropertiesView*)functionPropertiesView
{
    return (AMFunctionPropertiesView*)self.view;
}
-(void)setupArgumentListViewController
{
    self.argumentListViewController.nameProvider = self.nameProvider ;
    self.argumentListViewController.argumentList = self.argumentList;
}

-(void)reloadData
{
    [[self functionPropertiesView] reloadData];
    [self.argumentListViewController reloadData];
}

-(void)popoverDidClose:(NSNotification *)notification
{
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:NSUndoManagerDidUndoChangeNotification object:[self undoManager]];
    [notificationCenter removeObserver:self name:NSUndoManagerDidRedoChangeNotification object:[self undoManager]];
    self.popoverShowing = NO;
}

-(void)controlTextDidEndEditing:(NSNotification *)notification
{
    KSMValueType mathValue;
    if (notification.object == self.functionPropertiesView.nameField) {
        NSString * proposedName = self.functionPropertiesView.nameField.stringValue;
        mathValue = self.functionDef.returnType.integerValue;
        [self updateFunctionName:proposedName];
    } else {
        NSInteger selectedRow = self.functionPropertiesView.argumentTable.selectedRow;
        AMDArgument * argument = [self.argumentList argumentAtIndex:selectedRow];
        NSString * newName = ((NSTextField*)notification.object).stringValue;
        KSMValueType mathValue = ((NSNumber*)argument.mathValue).integerValue;
        [self updateArgument:argument withName:newName type:mathValue];
    }
}
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (tableView == self.functionPropertiesView.argumentTable) {
        NSUInteger count = self.argumentList.arguments.count;
        return count;
    }
    return 0;
}

-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSView * returnView = nil;
    if (tableView == self.functionPropertiesView.argumentTable) {
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
    KSMMathValue * mathValue = argument.mathValue;
    [button selectItemWithTag:mathValue.type];
    [button setTarget:self];
    [button setAction:NSSelectorFromString(@"valueTypePopupChanged:")];
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
- (IBAction)addArgument:(NSButton *)sender {
    NSTableView * argumentTable = self.functionPropertiesView.argumentTable;
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
}
- (IBAction)removeArgument:(NSButton *)sender {
    NSTableView * argumentTable = self.functionPropertiesView.argumentTable;
    NSInteger selectedRow = argumentTable.selectedRow;
    
    // Quick exit if no row is selected - we aren't just going to delete a random one!
    if (selectedRow < 0) return;

    if ([self.argumentList removeArgumentAtIndex:selectedRow]) {
        // Keep the displayed table in sync with the datastore
        [argumentTable removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:selectedRow] withAnimation:NSTableViewAnimationSlideDown];
    }
    [argumentTable selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] byExtendingSelection:NO];
    
    self.argumentListViewController.argumentList = self.argumentList;
}
-(void)updateFunctionName:(NSString*)name
{
    AMDataRenamer * renamer = [AMDataRenamer renamerForObject:self.functionDef nameProvider:self.nameProvider];
    [[self undoManager] registerUndoWithTarget:self selector:@selector(updateFunctionName:) object:self.functionDef.name.string];
    [renamer updateNameString:name];
    [self reloadData];
}
-(void)updateFunctionReturnType:(NSNumber*)returnType
{
    AMDataRenamer * renamer = [AMDataRenamer renamerForObject:self.functionDef nameProvider:self.nameProvider];
    [[self undoManager] registerUndoWithTarget:self selector:@selector(updateFunctionReturnType:)   object:self.functionDef.returnType];
    [renamer updateValueType:returnType.integerValue];
    [self reloadData];
}
-(void)updateArgument:(AMDArgument*)argument withName:(NSString*)name type:(KSMValueType)valueType
{
    argument.mathValue = [KSMMathValue mathValueFromValueType:valueType];
    [argument.name setNameAndGenerateAttributedNameFrom:argument.name.string valueType:valueType nameProvider:self.nameProvider];
}
-(NSUndoManager*)undoManager
{
    return [AMDataStore sharedDataStore].moc.undoManager;
}

-(AMDArgumentList*)argumentList
{
    return self.functionDef.argumentList;
}

-(AMDFunctionDef*)functionDef
{
    return _functionDef;
}
-(void)setFunctionDef:(AMDFunctionDef *)functionDef
{
    _functionDef = functionDef;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)valueTypePopupChanged:(NSPopUpButton *)sender {
    if (sender == self.returnTypePopup) {
        [self updateFunctionReturnType:@(sender.selectedTag)];
    } else {
        NSTableView * argumentTable = self.functionPropertiesView.argumentTable;
        NSInteger row = [argumentTable rowForView:sender];
        AMDArgument * argument = [self.argumentList argumentAtIndex:row];
        KSMValueType mathValue = sender.selectedTag;
        [self updateArgument:argument withName:argument.name.string type:mathValue];
    }
}

- (IBAction)editingFinishedButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:AMFunctionPropertiesDidEndEditingNotification object:self];
}

@end
