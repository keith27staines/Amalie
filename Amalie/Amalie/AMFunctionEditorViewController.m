//
//  AMFunctionEditorViewController.m
//  Amalie
//
//  Created by Keith Staines on 04/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMFunctionEditorViewController.h"
#import "AMDataStore.h"
#import "AMDArgumentList+Methods.h"
#import "AMDArgumentList.h"
#import "AMDArgument.h"
#import "AMDFunctionDef.h"
#import "AMDName.h"
#import "KSMMathValue.h"
#import "AMFunctionContentViewController.h"
#import "NSString+KSMMath.h"

@interface AMFunctionEditorViewController ()
{
    BOOL _popoverShowing;
    NSMutableSet * _observedViews;
}
@property (strong, readonly) NSMutableSet * observedViews;
@property (weak, readonly) AMDArgumentList * argumentList;


@end

@implementation AMFunctionEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)awakeFromNib
{

}

-(void)reloadData
{
    [self.argumentTable reloadData];
}

-(void)popoverWillShow:(NSNotification *)notification{
    // setup notifications for undo/redo
    [self reloadData];
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];

    SEL reloadSelector = NSSelectorFromString(@"reloadData");
    [notificationCenter addObserver:self selector:reloadSelector name:NSUndoManagerDidUndoChangeNotification object:[self undoManager]];
    [notificationCenter addObserver:self selector:reloadSelector name:NSUndoManagerDidRedoChangeNotification object:[self undoManager]];
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
    argument.name.string = ((NSTextField*)obj.object).stringValue;
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
    NSTableCellView * view = [tableView makeViewWithIdentifier:@"Main cell view" owner:nil];
    [self populateRowView:view withArgument:argument];
    return view;
}

-(void)populateRowView:(NSTableCellView*)view withArgument:(AMDArgument*)argument
{
    view.textField.stringValue = argument.name.string;
    
    SEL selector = NSSelectorFromString(@"controlTextDidChange:");
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    if (![self.observedViews containsObject:view]) {
        [center addObserver:self selector:selector name:NSControlTextDidChangeNotification object:view.textField];
    }
}

- (IBAction)addArgument:(NSButton *)sender {
    NSInteger selectedRow = self.argumentTable.selectedRow;
    
    // Update datastore. If a row is selected (ie >= 0), we insert beneath that, otherwise at the end.
    if (selectedRow >=0) selectedRow++;
    AMDArgument * argument = [self.argumentList addArgumentAtIndex:selectedRow];
    if ( argument ) {
        
        selectedRow = [argument.index integerValue];

        // Keep the displayed table in sync
        [self.argumentTable insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:selectedRow] withAnimation:NSTableViewAnimationSlideDown];
        
        NSTableCellView * view = [self.argumentTable viewAtColumn:0 row:selectedRow makeIfNecessary:NO];
        [self populateRowView:view withArgument:argument];

        // Make sure new row is visible
        [self.argumentTable scrollRowToVisible:selectedRow];
        
        [self.argumentTable selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] byExtendingSelection:NO];
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
}

-(NSUndoManager*)undoManager
{
    return [AMDataStore sharedDataStore].moc.undoManager;
}

- (IBAction)changeReturnType:(NSPopUpButton *)sender
{
    AMDFunctionDef * f = self.argumentList.functionDef;
    f.returnType = @([self valueTypeForPopupButton:sender]);
}

-(KSMValueType)valueTypeForPopupButton:(NSPopUpButton *)popupButton
{
    switch (popupButton.tag) {
        case 0:
            return KSMValueInteger;
            break;
        case 1:
            return KSMValueDouble;
            break;
        case 2:
            return KSMValueVector;
            break;
        case 3:
            return KSMValueMatrix;
            break;
        default:
            NSAssert(NO, @"Unexpected tag");
            return KSMValueDouble;
            break;
    }
}

-(AMDArgumentList*)argumentList
{
    return self.functionDef.argumentList;
}

-(AMDFunctionDef*)functionDef
{
    return self.functionContentViewController.amdFunctionDef;
}

-(AMDataStore*)sharedDataStore
{
    return [AMDataStore sharedDataStore];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
