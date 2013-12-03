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
#import "AMArgumentListViewController.h"
#import "AMArgumentListView.h"

@interface AMFunctionEditorViewController ()
{
    BOOL _popoverShowing;
    NSMutableSet * _observedViews;
}
@property (strong, readonly) NSMutableSet * observedViews;
@property (weak, readonly) AMDArgumentList * argumentList;

-(AMDFunctionDef*)functionDef;

@end

@implementation AMFunctionEditorViewController

-(id)init
{
    NSString *nibName = @"FunctionEditorView";
    NSBundle *bundle = nil;
    self = [super initWithNibName:nibName bundle:bundle];
    if (self) {
    
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"FunctionEditorView" bundle:nil];
    if (self) {
        
    }
    return self;
}

-(void)awakeFromNib
{
    [self setupValuePopup:self.returnTypePopup];

    self.argumentListViewController.argumentList = self.argumentList;
    AMArgumentListView * argumentListView = (AMArgumentListView *)[self.argumentListViewController view];
    argumentListView.delegate = self.argumentListViewController;
    [self.functionEditorView addSubview:argumentListView];
    NSDictionary * controls = @{@"argView": argumentListView, @"argTable" : self.argumentTable};
    NSArray * constraints;
    
    constraints =  [NSLayoutConstraint constraintsWithVisualFormat:@"V:[argView]-25.0-[argTable]"
                                                                     options:NSLayoutFormatAlignAllLeft
                                                                     metrics:nil
                                                                       views:controls];

    [self.view addConstraints:constraints];
    
    constraints =  [NSLayoutConstraint constraintsWithVisualFormat:@"H:[argView(argTable)]"
                                                           options:0
                                                           metrics:nil
                                                             views:controls];
    
    [self.view addConstraints:constraints];
    
}

-(void)reloadData
{
    self.argumentListViewController.argumentList = self.argumentList;
    [self.argumentTable reloadData];
    [self.returnTypePopup selectItemWithTag:self.functionDef.returnType.integerValue];
}

-(void)popoverWillShow:(NSNotification *)notification{

    [self reloadData];
    
    // setup notifications for undo/redo

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
    argument.name.attributedString = [[NSAttributedString alloc] initWithString:argument.name.string attributes:nil];
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
    view.textField.stringValue = argument.name.string;
    
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
    AMDArgument * argument = [self.argumentList addArgumentAtIndex:selectedRow];
    if ( argument ) {
        
        selectedRow = [argument.index integerValue];

        // Keep the displayed table in sync
        [self.argumentTable insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:selectedRow] withAnimation:NSTableViewAnimationSlideDown];
        
        NSTableCellView * view = [self.argumentTable viewAtColumn:0 row:selectedRow makeIfNecessary:NO];
        [self populateTableNameView:view withArgument:argument];

        // Make sure new row is visible
        [self.argumentTable scrollRowToVisible:selectedRow];
        
        [self.argumentTable selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] byExtendingSelection:NO];
        
        self.argumentListViewController.argumentList = self.argumentList;

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
    }
}

@end
