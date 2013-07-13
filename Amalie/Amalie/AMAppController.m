//
//  AMAppController.m
//  Amalie
//
//  Created by Keith Staines on 07/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMAppController.h"
#import "AMPreferences.h"
#import "AMPreferencesWindowController.h"
#import "AMConstants.h"
#import "AMTrayItem.h"
#import "AMInsertables.h"

NSString * const kAMPreferencesWindowNibName = @"AMPreferencesWindow";
NSMutableDictionary * _trayDictionary;

@interface AMAppController()
{
    AMPreferencesWindowController * _preferencesController;
}

@property (strong,readonly) AMPreferencesWindowController * preferencesController;

@end

@implementation AMAppController

- (IBAction)showPreferencesPanel:(id)sender {
    
    if (!_preferencesController) {
        _preferencesController = [[AMPreferencesWindowController alloc] initWithWindowNibName:kAMPreferencesWindowNibName];
        [_preferencesController setTrayDatasource:self];
    }
    [_preferencesController showWindow:self];
}

// Called before any other method of this class
+(void)initialize
{
    [AMPreferences registerDefaultPreferences];
}

#pragma mark -Implementation of AMTrayDatasourceProtocol-

-(NSUInteger)trayItemCount
{
    return [[self dictionaryOfAllTrayItems] count];
}

-(void)mergeTrayPreferences
{
    NSDictionary * trayPreferences = [[AMPreferences defaults] objectForKey:kAMTrayDictionaryKey];
    
    for (NSString * key in trayPreferences) {
        
        NSDictionary * itemPreferences = trayPreferences[key];
        AMTrayItem * item = [self dictionaryOfAllTrayItems][key];

        item.backgroundColor = colorFromData( itemPreferences[kAMBackColorKey] );
        item.fontColor = colorFromData( itemPreferences[kAMFontColorKey] );
    }
}

-(NSDictionary*)dictionaryOfAllTrayItems
{
    if (!_trayDictionary) {
        
        _trayDictionary = [NSMutableDictionary dictionary];
        
        NSDictionary * trayPreferences = [[AMPreferences defaults] objectForKey:kAMTrayDictionaryKey];
        
        for (NSString * key in trayPreferences) {
            NSDictionary * itemPreferences = trayPreferences[key];
            AMTrayItem * item;
            NSString * title = [self StringByStrippingKeyPrefixAndSuffix:key];
            NSString * iconKey = title;
            NSString * info;
            NSString * className;
            
            [self getClassName:&className info:&info forTrayItemWithKey:key];
            
            NSColor * backgroundColor = colorFromData(itemPreferences[kAMBackColorKey]);
            NSColor * fontColor = colorFromData(itemPreferences[kAMFontColorKey]);
            item = [[AMTrayItem alloc] initWithKey:key
                                           iconKey:iconKey
                                             title:title
                                       info:info
                                   backgroundColor:backgroundColor
                                         fontColor:fontColor
                                    insertableType:className];
            [_trayDictionary setObject:item forKey:key];
        }
    }
    return _trayDictionary;
}

-(void)getClassName:(NSString**)className info:(NSString**)info forTrayItemWithKey:(NSString*)key
{
    if ( [key isEqualToString:kAMConstantKey] ) {
        *className = [AMInsertableConstantView description];
        *info = @"Define a constant and assigns it a value. Once a constant is defined, you may refer to it anywhere on the worksheet, but you cannot change its value.";
        return;
    }

    if ( [key isEqualToString:kAMVariableKey] ) {
        *className = [AMInsertableVariableView description];
        *info = @"Define a variable and assigns it a value. Once a variable is defined, you may refer to it anywhere on the worksheet below the position where it is introduced. At any later position, you can change its value either by explicitly assiging it a new value or implicitly, by referencing it in a set or range of values.";
        return;
    }

    if ( [key isEqualToString:kAMExpressionKey] ) {
        *className = [AMInsertableExpressionView description];
        *info = @"Define an algebraic expression. The expression can reference other mathematic objects defined above it. If all the objects it references can be evaluated, the expression itself can be evaluated.";
        return;
    }
    
    if ( [key isEqualToString:kAMEquationKey] ) {
        *className = [AMInsertableEquationView description];
        *info = @"Define an equation.";
        return;
    }

    if ( [key isEqualToString:kAMVectorKey] ) {
        *className = [AMInsertableVectorView description];
        *info = @"Define a vector.";
        return;
    }
    
    if ( [key isEqualToString:kAMMatrixKey] ) {
        *className = [AMInsertableMatrixView description];
        *info = @"Define a matrix.";
        return;
    }

    if ( [key isEqualToString:kAMMathematicalSetKey] ) {
        *className = [AMInsertableMathematicalSetView description];
        *info = @"Define a set (technically a finite set).";
        return;
    }
    
    if ( [key isEqualToString:kAMGraph2DKey] ) {
        *className = [AMInsertableGraph2DView description];
        *info = @"Defines a 2D graph.";
        return;
    }
    
    // Coding error - we either forgot one of the insertable objects, or its key is not being passed in correctly.
    [NSException raise:@"There is no class name associated with the tray item." format:@"The tray item %@ is not known.",key];
}

-(AMTrayItem*)trayItemWithKey:(NSString *)key
{
    return [[self dictionaryOfAllTrayItems] objectForKey:key];
}

-(AMTrayItem*)trayItemAtIndex:(NSUInteger)index
{
    return [self arrayOfAllTrayItems][index];
}

-(NSArray*)arrayOfAllTrayItems
{
    return [[self dictionaryOfAllTrayItems] allValues];
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

@end
