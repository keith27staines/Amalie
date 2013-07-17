//
//  AMToolboxViewController.m
//  Amalie
//
//  Created by Keith Staines on 03/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMToolboxViewController.h"
#import "AMInsertables.h"
#import "AMAppController.h"
#import "AMConstants.h"
#import "AMTrayItem.h"

@interface AMToolboxViewController()
@property (copy) NSString* dragString;

@end

@implementation AMToolboxViewController

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    // setup the table to be a drag source
    [[self tableView] setDraggingSourceOperationMask:NSDragOperationCopy forLocal:YES];
    [[self tableView] setDraggingSourceOperationMask:NSDragOperationNone forLocal:NO];
    [[self tableView] setVerticalMotionCanBeginDrag:YES];
    [[self tableView] reloadData];
}

-(BOOL)tableView:(NSTableView *)tableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation
{
    return NO;
}

-(void)tableView:(NSTableView *)tableView draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forRowIndexes:(NSIndexSet *)rowIndexes
{
    ;
}

-(void)tableView:(NSTableView *)tableView updateDraggingItemsForDrag:(id<NSDraggingInfo>)draggingInfo
{
    ;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.trayDatasource trayItemCount];
}

-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    // Which table are we dealing with?
    if ([[tableView identifier] isEqualToString:kAMTrayDictionaryKey]) {
        
        // The table is the tray (of insertable items).
        AMTrayItem * trayItem = [self.trayDatasource trayItemAtIndex:row];
        
        // Which column?
        if ( [tableColumn.identifier isEqualToString:kAMIconKey] ) {
            
            // So far, only one column, but this column's cell view has multiple subviews
            NSTableCellView * view = [tableView makeViewWithIdentifier:kAMIconKey owner:self];
            [[view imageView] setImage:trayItem.icon];
            [[view textField] setAttributedStringValue:trayItem.attributedDescription];
            NSColor * backgroundColor = trayItem.backgroundColor;
            [[view textField] setBackgroundColor:backgroundColor];
            [[view textField] setDrawsBackground:YES];
            return view;
        }
        return nil;
    }
    return nil;
}

-(id<NSPasteboardWriting>)tableView:(NSTableView *)tableView
             pasteboardWriterForRow:(NSInteger)row
{
    
    // The table is the tray (of insertable items).
    AMTrayItem * trayItem = [self.trayDatasource trayItemAtIndex:row];
    NSString * className = trayItem.insertableClassName;
    AMInsertableObjectView * insertableView = [[NSClassFromString(className) alloc] init];
    return insertableView;
}


@end
