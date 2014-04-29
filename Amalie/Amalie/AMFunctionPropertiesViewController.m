//
//  AMFunctionPropertiesViewController.m
//  Amalie
//
//  Created by Keith Staines on 04/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMFunctionPropertiesViewController.h"
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

NSString * const AMFunctionPropertiesDidEndEditingNotification = @"AMFunctionPropertiesDidEndEditingNotification";

@interface AMFunctionPropertiesViewController ()
{
    BOOL _isSetup;
    BOOL _popoverShowing;
    NSMutableSet * _observedViews;
    __weak AMDFunctionDef * _functionDef;
}
@property (strong, readonly) NSMutableSet * observedViews;
@property (weak, readonly) AMDArgumentList * argumentList;

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
        [self setupValuePopup:self.returnTypePopup];
        [self setupArgumentListViewController];
    }
    return view;
}
-(void)setupArgumentListViewController
{
    self.argumentListViewController.nameProvider = self.nameProvider ;
    self.argumentListViewController.argumentList = self.argumentList;
}

-(void)reloadData
{
    self.argumentListViewController.argumentList = self.argumentList;
    [self.argumentTable reloadData];
    [self.returnTypePopup selectItemWithTag:self.functionDef.returnType.integerValue];
}

-(void)popoverDidClose:(NSNotification *)notification
{
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:NSUndoManagerDidUndoChangeNotification object:[self undoManager]];
    [notificationCenter removeObserver:self name:NSUndoManagerDidRedoChangeNotification object:[self undoManager]];
    self.popoverShowing = NO;
}

-(NSMutableSet*)observedViews
{
    if (!_observedViews) {
        _observedViews = [NSMutableSet setWithObjects:nil];
    }
    return _observedViews;
}

-(void)controlTextDidBeginEditing:(NSNotification *)obj
{
    [[self undoManager] beginUndoGrouping];
}

-(void)controlTextDidEndEditing:(NSNotification *)obj
{
    [[self undoManager] endUndoGrouping];
}

-(void)controlTextDidChange:(NSNotification *)obj
{
    NSInteger selectedRow = self.argumentTable.selectedRow;
    AMDArgument * argument = [self.argumentList argumentAtIndex:selectedRow];

    NSString * newName = ((NSTextField*)obj.object).stringValue;
    KSMValueType mathValue = ((NSNumber*)argument.mathValue).integerValue;
    [argument.name setNameAndGenerateAttributedNameFrom:newName valueType:mathValue nameProvider:self.nameProvider];
    self.argumentListViewController.argumentList = self.argumentList;
    NSLog(@"Text changed");
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSUInteger count = self.argumentList.arguments.count;
    return count;
}

-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    AMDArgument * argument = [self.argumentList argumentAtIndex:row];
    NSAssert(argument, @"argument in list is nil");
    if ( [tableColumn.identifier isEqualToString:@"NameColumn"] ) {
        NSTableCellView * view = nil;
        view = [tableView makeViewWithIdentifier:@"NameColumnView" owner:self];
        [self populateTableNameView:view withArgument:argument];
        return view;
    } else if ([tableColumn.identifier isEqualToString:@"TypeColumn"] ) {
        NSPopUpButton * view = nil;
        view = [tableView makeViewWithIdentifier:@"TypeColumnView" owner:self];
        NSPopUpButton * popupButton = (NSPopUpButton*)view;
        [self populateTableTypeView:popupButton withArgument:argument];
        return view;
    }
    return nil;
}

-(void)populateTableNameView:(NSTableCellView*)view withArgument:(AMDArgument*)argument
{
    view.textField.attributedStringValue = argument.name.attributedString;
    
    SEL selector = NSSelectorFromString(@"controlTextDidChange:");
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    if (![self.observedViews containsObject:view]) {
        [center addObserver:self selector:selector name:NSControlTextDidChangeNotification object:view.textField];
    }
}

-(void)populateTableTypeView:(NSPopUpButton*)button withArgument:(AMDArgument*)argument
{
    [self setupValuePopup:button];
    KSMMathValue * mathValue = argument.mathValue;
    [button selectItemWithTag:mathValue.type];
    [button setTarget:self];
    [button setAction:NSSelectorFromString(@"valueTypePopupChanged:")];
}

- (IBAction)addArgument:(NSButton *)sender {
    NSInteger selectedRow = self.argumentTable.selectedRow;
    
    // Update datastore. If a row is selected (ie >= 0), we insert beneath that, otherwise we add to the end.
    if (selectedRow >=0) selectedRow++;
    AMDArgument * argument = [self.argumentList addArgumentAtIndex:selectedRow withNameProvider:self.nameProvider];
    if ( argument ) {
        
        selectedRow = [argument.index integerValue];

        // Keep the displayed table in sync
        [self.argumentTable insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:selectedRow] withAnimation:NSTableViewAnimationSlideDown];
        
        NSTableCellView * view = [self.argumentTable viewAtColumn:0 row:selectedRow makeIfNecessary:NO];
        [self populateTableNameView:view withArgument:argument];

        // Make sure new row is visible
        [self.argumentTable scrollRowToVisible:selectedRow];
        
        [self.argumentTable selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] byExtendingSelection:NO];
        
        [self.argumentListViewController reloadData];

    }
}

- (IBAction)removeArgument:(NSButton *)sender {
    NSInteger selectedRow = self.argumentTable.selectedRow;
    
    // Quick exit if no row is selected - we aren't just going to delete a random one!
    if (selectedRow < 0) return;

    if ([self.argumentList removeArgumentAtIndex:selectedRow]) {
        // Keep the displayed table in sync with the datastore
        [self.argumentTable removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:selectedRow] withAnimation:NSTableViewAnimationSlideDown];
    }
    [self.argumentTable selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] byExtendingSelection:NO];
    
    self.argumentListViewController.argumentList = self.argumentList;

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
    if (sender == self.returnTypePopup) {
        self.functionDef.returnType = @(sender.selectedTag);
    } else {
        NSInteger row = [self.argumentTable rowForView:sender];
        AMDArgument * argument = [self.argumentList argumentAtIndex:row];
        argument.mathValue = [KSMMathValue mathValueFromValueType:sender.selectedTag];
        [argument.name setNameAndGenerateAttributedNameFrom:argument.name.string valueType:sender.selectedTag nameProvider:self.nameProvider];
    }
    [self reloadData];
}

- (IBAction)editingFinishedButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:AMFunctionPropertiesDidEndEditingNotification object:self];
}

@end
