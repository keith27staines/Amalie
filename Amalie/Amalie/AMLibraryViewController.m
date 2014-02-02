//
//  AMLibraryViewController.m
//  Amalie
//
//  Created by Keith Staines on 31/01/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMLibraryViewController.h"
#import "AMInsertableView.h"
#import "AMAppController.h"
#import "AMConstants.h"
#import "AMTrayItem.h"
#import "AMInsertableViewController.h"

@interface AMLibraryViewController ()
{
    
}
@property (copy) NSString* dragString;

@end

@implementation AMLibraryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(NSString *)nibName
{
    return @"AMLibraryViewController";
}

-(void)awakeFromNib
{
    [super awakeFromNib];
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
    return [self.appController trayItemCount];
}

-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    // Which table are we dealing with?
    if ([[tableView identifier] isEqualToString:kAMTrayDictionaryKey]) {
        
        // The table is the tray (of insertable items).
        AMTrayItem * trayItem = [self.appController trayItemAtIndex:row];
        
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

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 50;
}

-(id<NSPasteboardWriting>)tableView:(NSTableView *)tableView
             pasteboardWriterForRow:(NSInteger)row
{
    
    // The table is the tray (of insertable items).
    AMTrayItem * trayItem = [self.appController trayItemAtIndex:row];
    AMInsertableViewController * viewController = [[AMInsertableViewController alloc] init];
    AMInsertableView * insertableView = (AMInsertableView*)[viewController view];
    insertableView.insertableType = trayItem.insertableType;
    
    return insertableView;
}


@end
