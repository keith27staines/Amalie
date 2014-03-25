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

-(NSUInteger)libraryItemCount
{
    return [[self dictionaryOfAllLibraryItems] count];
}

-(NSDictionary*)dictionaryOfAllLibraryItems
{
    if (!_libraryItems) {
        
        _libraryItems = [NSMutableDictionary dictionary];
        NSColor * backgroundColor;
        NSColor * fontColor;
        AMColorSettings * colorSettings = self.colorSettings;
        
        for ( NSString * key in [self libraryItemKeys] ) {
            AMLibraryItem * item;
            NSString * title = [self StringByStrippingKeyPrefixAndSuffix:key];
            NSString * iconKey = title;
            NSString * info;
            NSString * className;
            AMInsertableType insertableType = 0;
            [self getInsertableClassName:&className
                           insertableTye:&insertableType
                                    info:&info
                      forLibraryItemWithKey:key];
            backgroundColor = [colorSettings backColorForInsertableObjectType:insertableType];
            fontColor = [colorSettings fontColorForInsertableObjectType:insertableType];
            item = [[AMLibraryItem alloc] initWithKey:key
                                           iconKey:iconKey
                                             title:title
                                              info:info
                                   backgroundColor:backgroundColor
                                         fontColor:fontColor
                                   insertableClass:className
                                    insertableType:insertableType];
            
            [_libraryItems setObject:item forKey:key];
        }
    }
    return _libraryItems;
}

-(void)getInsertableClassName:(NSString**)className
                insertableTye:(AMInsertableType*)insertableType
                         info:(NSString**)info
           forLibraryItemWithKey:(NSString*)key
{
    
    *className = [AMInsertableView description];
    
    if ( [key isEqualToString:kAMConstantKey] ) {
        *insertableType = AMInsertableTypeConstant;
        *info = NSLocalizedString(@"Define a constant and assigns it a value. Once a constant is defined, you may refer to it anywhere on the worksheet, but you cannot change its value.",nil);
        return;
    }
    
    if ( [key isEqualToString:kAMVariableKey] ) {
        *insertableType = AMInsertableTypeVariable;
        *info = NSLocalizedString(@"Define a variable and assigns it a value. Once a variable is defined, you may refer to it anywhere on the worksheet below the position where it is introduced. At any later position, you can change its value either by explicitly assiging it a new value or implicitly, by referencing it in a set or range of values.",nil);
        return;
    }
    
    if ( [key isEqualToString:kAMExpressionKey] ) {
        *insertableType = AMInsertableTypeExpression;
        *info = NSLocalizedString(@"Define an algebraic expression. The expression can reference other mathematic objects defined above it. If all the objects it references can be evaluated, the expression itself can be evaluated.",nil);
        return;
    }
    
    if ( [key isEqualToString:kAMFunctionKey]) {
        *insertableType = AMInsertableTypeFunction;
        *info = NSLocalizedString(@"Define a function, including its name, argument list and return type. The function can also reference other mathematical objects defined above it.",nil);
        return;
    }
    
    if ( [key isEqualToString:kAMEquationKey] ) {
        *insertableType = AMInsertableTypeEquation;
        *info = NSLocalizedString(@"Define an equation.",nil);
        return;
    }
    
    if ( [key isEqualToString:kAMVectorKey] ) {
        *insertableType = AMInsertableTypeVector;
        *info = NSLocalizedString(@"Define a vector.",nil);
        return;
    }
    
    if ( [key isEqualToString:kAMMatrixKey] ) {
        *insertableType = AMInsertableTypeMatrix;
        *info = NSLocalizedString(@"Define a matrix.",nil);
        return;
    }
    
    if ( [key isEqualToString:kAMMathematicalSetKey] ) {
        *insertableType = AMInsertableTypeMathematicalSet;
        *info = NSLocalizedString(@"Define a set (technically a finite set).",nil);
        return;
    }
    
    if ( [key isEqualToString:kAMGraph2DKey] ) {
        *insertableType = AMInsertableTypeGraph2D;
        *info = NSLocalizedString(@"Defines a 2D graph.",nil);
        return;
    }
    
    // Coding error - we either forgot one of the insertable objects, or its key is not being passed in correctly.
    [NSException raise:@"There is no class name associated with the tray item." format:@"Unknown library item: %@.",key];
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

-(NSString*)StringByStrippingKeyPrefixAndSuffix:(NSString*)string
{
    NSString * affix = [string substringFromIndex:([string length] - 3)];
    if ([affix isEqualToString:kAMKeySuffix]) {
        string = [string substringToIndex:([string length] - 3)];
    }
    affix = [string substringToIndex:[kAMKeyPrefix length]];
    if ([affix isEqualToString:kAMKeyPrefix]) {
        string = [string substringFromIndex:[kAMKeyPrefix length]];
    }
    
    return string;
}

-(NSString*)keyForType:(AMInsertableType)type
{
    switch (type) {
        case AMInsertableTypeConstant:
            return kAMConstantKey;
            break;
        case AMInsertableTypeVariable:
            return kAMVariableKey;
            break;
            
        case AMInsertableTypeExpression:
            return kAMExpressionKey;
            break;
            
        case AMInsertableTypeFunction:
            return kAMFunctionKey;
            break;
            
        case AMInsertableTypeEquation:
            return kAMEquationKey;
            break;
            
        case AMInsertableTypeVector:
            return kAMVectorKey;
            break;
            
        case AMInsertableTypeMatrix:
            return kAMMatrixKey;
            break;
            
        case AMInsertableTypeMathematicalSet:
            return kAMMathematicalSetKey;
            break;
            
        case AMInsertableTypeGraph2D:
            return kAMGraph2DKey;
            break;
        case AMInsertableTypeDummyVariable:
        {
            [NSException raise:@"Dummy variables should never be top-level objects" format:nil];
            return nil;
        }
    }
}

-(AMInsertableType)typeForKey:(NSString*)key
{
    if ([key isEqualToString:kAMConstantKey])   return AMInsertableTypeConstant;
    if ([key isEqualToString:kAMVariableKey])   return AMInsertableTypeVariable;
    if ([key isEqualToString:kAMExpressionKey]) return AMInsertableTypeExpression;
    if ([key isEqualToString:kAMFunctionKey])   return AMInsertableTypeFunction;
    if ([key isEqualToString:kAMEquationKey])   return AMInsertableTypeEquation;
    if ([key isEqualToString:kAMVectorKey])     return AMInsertableTypeVector;
    if ([key isEqualToString:kAMMatrixKey])     return AMInsertableTypeMatrix;
    if ([key isEqualToString:kAMMathematicalSetKey]) return AMInsertableTypeMathematicalSet;
    if ([key isEqualToString:kAMGraph2DKey]) return AMInsertableTypeGraph2D;
    [NSException raise:@"Unknown key" format:@"There is no known type for key %@",key];
    return 0;
}

@end
