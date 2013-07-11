//
//  AMToolboxViewController.m
//  Amalie
//
//  Created by Keith Staines on 03/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMToolboxViewController.h"
#import "AMInsertableDefinition.h"
#import "AMInsertableObjectView.h"
#import "AMAppController.h"
#import "AMConstants.h"

@interface AMToolboxViewController()
@property (copy) NSString* dragString;

@end

@implementation AMToolboxViewController

-(void)awakeFromNib
{
    [super awakeFromNib];
    _insertableDefinitions = [NSMutableArray array];
    AMInsertableDefinition * insertableDef;
    
    // add constant
    insertableDef = [[AMInsertableDefinition alloc] initWithName:@"Constant Definition"
                                                            text:@" - Define a constant for use in your worksheet."];
    [_insertableDefinitions addObject:insertableDef];

    // expression
    insertableDef = [[AMInsertableDefinition alloc] initWithName:@"Expression Definition"
                                                            text:@" - Define an expression for use in your worksheet."];
    [_insertableDefinitions addObject:insertableDef];

    // function
    insertableDef = [[AMInsertableDefinition alloc] initWithName:@"Function Definition"
                                                            text:@" - Define an expression for use in your worksheet."];
    [_insertableDefinitions addObject:insertableDef];

    
    // vector
    insertableDef = [[AMInsertableDefinition alloc] initWithName:@"Vector Definition"
                                                            text:@" - Define a vector for use in your worksheet."];
    [_insertableDefinitions addObject:insertableDef];

    
    // matrix
    insertableDef = [[AMInsertableDefinition alloc] initWithName:@"Matrix Definition"
                                                            text:@" - Define a matrix for use in your worksheet."];
    [_insertableDefinitions addObject:insertableDef];
    
    
    // setup the table to be a drag source
    [[self tableView] setDraggingSourceOperationMask:NSDragOperationCopy forLocal:YES];
    [[self tableView] setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
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
    return [self.appControllerDelegate trayRowCount];
}

-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    // Which table are we dealing with?
    if ([[tableView identifier] isEqualToString:kAMTrayDictionaryKey]) {
        
        // The table is the tray of insertable items.
        NSArray * trayItems = [self.appControllerDelegate arrayOfTrayRows];
        
        // Which column?
        if ( [tableColumn.identifier isEqualToString:kAMTrayDictionaryKey] ) {
            
            // So far, only one column, but this column's cell view has multiple subviews
            NSDictionary * properties = trayItems[row];
            NSString * title = [properties objectForKey:kAMTrayItemTitleKey];
            NSString * descr = [properties objectForKey:kAMTrayItemDescriptionKey];
            NSString * iconName = [properties objectForKey:kAMTrayItemIconKey];
            NSImage * icon = [self.appControllerDelegate iconForTrayItemWithName:iconName];
            NSString * fullDescription = [title stringByAppendingString:@" - "];
            fullDescription = [fullDescription stringByAppendingString:descr];
            NSRange titleRange = NSMakeRange(0, [title length]);
            NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:fullDescription];
            [attrString addAttribute:NSFontNameAttribute value:[NSFont boldSystemFontOfSize:0] range:titleRange];
            
            NSTableCellView * view = [tableView makeViewWithIdentifier:kAMTrayDictionaryKey owner:self];
            [[view imageView] setImage:icon];
            [[view textField] setStringValue:fullDescription];
            return view;
        }
        
        return nil;
    }
    return nil;
}

-(id<NSPasteboardWriting>)tableView:(NSTableView *)tableView
             pasteboardWriterForRow:(NSInteger)row
{
    //AMInsertableDefinition * insert = _insertableDefinitions[row];
    //return [insert text];
    return [[AMInsertableObjectView alloc] init];
}


@end
