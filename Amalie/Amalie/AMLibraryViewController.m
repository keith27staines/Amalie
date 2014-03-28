//
//  AMLibraryViewController.m
//  Amalie
//
//  Created by Keith Staines on 31/01/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMLibraryViewController.h"
#import "AMInsertableView.h"
#import "AMConstants.h"
#import "AMLibraryItem.h"
#import "AMInsertableViewController.h"
#import "AMColorSettings.h"

@interface AMLibraryViewController ()
{
    NSMutableDictionary * _libraryItems;
    AMColorSettings * _colorSettings;
}
@property (readonly) NSMutableDictionary * libraryItems;
@property (copy) NSString* dragString;

@end

@implementation AMLibraryViewController

+(NSArray*)libraryItemKeys
{
    static NSArray * _libraryItemKeys;
    if (!_libraryItemKeys) {
        _libraryItemKeys = @[kAMConstantKey,
                             kAMVariableKey,
                             kAMVectorKey,
                             kAMMatrixKey,
                             kAMFunctionKey,
                             kAMExpressionKey,
                             kAMEquationKey,
                             kAMMathematicalSetKey,
                             kAMGraph2DKey,
                             ];
    }
    return _libraryItemKeys;
}

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

-(NSArray*)libraryItemKeys
{
    return [self.class libraryItemKeys];
}

-(AMColorSettings *)colorSettings
{
    if (!_colorSettings) {
        _colorSettings = [AMColorSettings colorSettingsWithUserDefaults];
    }
    return _colorSettings;
}
-(void)setColorSettings:(AMColorSettings *)colorSettings
{
    _colorSettings = colorSettings;
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
    return [self libraryItemKeys].count;
}

-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    // Which table are we dealing with?
    if ([[tableView identifier] isEqualToString:kAMLibraryObjectsKey]) {
        
        // The table represents the library of insertable items.
        AMLibraryItem * libraryItem = [self libraryItemAtIndex:row];
        
        // Which column?
        if ( [tableColumn.identifier isEqualToString:kAMIconKey] ) {
            
            // So far, only one column, but this column's cell view has multiple subviews
            NSTableCellView * view = [tableView makeViewWithIdentifier:kAMIconKey owner:self];
            [[view imageView] setImage:libraryItem.icon];
            [[view textField] setAttributedStringValue:libraryItem.attributedDescription];
            NSColor * backgroundColor = libraryItem.backgroundColor;
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
    
    // The table represents the library of insertable items.
    AMLibraryItem * libraryItem = [self libraryItemAtIndex:row];
    AMInsertableViewController * viewController = [[AMInsertableViewController alloc] init];
    AMInsertableView * insertableView = (AMInsertableView*)[viewController view];
    insertableView.insertableType = libraryItem.insertableType;
    
    return insertableView;
}

#pragma mark - AMLibraryDatasource -

-(NSString *)keyForType:(AMInsertableType)type
{
    return [AMLibraryItem keyForType:type];
}
-(AMInsertableType)typeForKey:(NSString *)key
{
    return [AMLibraryItem typeForKey:key];
}
-(NSUInteger)libraryItemCount
{
    return [[self dictionaryOfAllLibraryItems] count];
}

-(NSDictionary*)dictionaryOfAllLibraryItems
{
    if (!_libraryItems) {
        
        _libraryItems = [NSMutableDictionary dictionary];
        AMColorSettings * colorSettings = self.colorSettings;
        
        for ( NSString * key in [self libraryItemKeys] ) {
            AMLibraryItem * item = [AMLibraryItem libraryItemForLibraryItemKey:key withColorInfo:colorSettings];
            [_libraryItems setObject:item forKey:key];
        }
    }
    return _libraryItems;
}
-(AMLibraryItem*)libraryItemWithKey:(NSString *)key
{
    return [[self dictionaryOfAllLibraryItems] objectForKey:key];
}
-(AMLibraryItem*)libraryItemAtIndex:(NSUInteger)index
{
    return [self arrayOfLibraryItems][index];
}
-(NSArray*)arrayOfLibraryItems
{
    return [[self dictionaryOfAllLibraryItems] allValues];
}
@end
