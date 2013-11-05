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
    view.textField.stringValue = argument.name.string;
    
    SEL selector = NSSelectorFromString(@"controlTextDidChange:");
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    if (![self.observedViews containsObject:view]) {
        [center addObserver:self selector:selector name:NSControlTextDidChangeNotification object:view.textField];
    }
    
    return view;
}

- (IBAction)addArgument:(NSButton *)sender {
    // If a row is selected, we insert beneath that, otherwise at the end
    NSInteger selectedRow = self.argumentTable.selectedRow;
    if (selectedRow < 0) selectedRow = self.argumentList.arguments.count;
    
    [[self undoManager] beginUndoGrouping];
    
    // Work out which arguments will need updated indexes once the insert has happened
    NSMutableArray * argumentsToReIndex = [NSMutableArray array];
    AMDArgument * argument;
    for (NSInteger i = selectedRow; i < self.argumentList.arguments.count; i++) {
        [argumentsToReIndex addObject:[self.argumentList argumentAtIndex:i]];
    }
    
    // Add a new argument to the datastore
    argument = [[self sharedDataStore] addArgumentOfType:KSMValueDouble toArgumentList:self.argumentList];
    
    // give the argument the right index
    argument.index = @(selectedRow);
    
    // give it a default name to match the index (+1)
    argument.name.string = [[argument.name.string KSMfirstCharacter] stringByAppendingString:[@(selectedRow+1) stringValue]];
    
    // Keep the displayed table in sync
    [self.argumentTable insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:selectedRow] withAnimation:NSTableViewAnimationSlideDown];
    
    // Make sure new row is visible
    [self.argumentTable scrollRowToVisible:selectedRow];
    
    // Update the indexes of any arguments that have been downshifted by the insertion
    for (AMDArgument * argument in argumentsToReIndex) {
        argument.index =  @(argument.index.integerValue + 1);
    }
    
    [[self undoManager] endUndoGrouping];
}

- (IBAction)removeArgument:(NSButton *)sender {

    // Quick exit if no row is selected - we aren't just going to delete a random one!
    NSInteger selectedRow = self.argumentTable.selectedRow;
    if (selectedRow < 0) return;

    [[self undoManager] beginUndoGrouping];
    
    // Work out which arguments will need revised indexes
    NSMutableArray * argumentsToReIndex = [NSMutableArray array];
    AMDArgument * argument;
    for (NSInteger i = selectedRow + 1; i < self.argumentList.arguments.count; i++) {
        [argumentsToReIndex addObject:[self.argumentList argumentAtIndex:i]];
    }
    
    // delete the unwanted argument from the datastore
    argument = [self.argumentList argumentAtIndex:selectedRow];
    [[self sharedDataStore] deleteArgument:argument];

    // Keep the displayed table in sync with the datastore
    [self.argumentTable removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:selectedRow] withAnimation:NSTableViewAnimationSlideDown];

    // revise the indexes of the arguments beyond the one just deleted
    for (AMDArgument * argument in argumentsToReIndex) {
        argument.index = @(argument.index.integerValue - 1);
    }
    
    [[self undoManager] endUndoGrouping];
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
