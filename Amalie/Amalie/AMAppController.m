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
#import "AMInsertableView.h"

NSString * const kAMPreferencesWindowNibName = @"AMPreferencesWindow";
NSMutableDictionary * _trayDictionary;

@interface AMAppController()
{
    AMPreferencesWindowController * _preferencesWindowController;
}

@property (strong,readonly) AMPreferencesWindowController * preferencesWindowController;

@end

@implementation AMAppController

- (IBAction)showPreferencesPanel:(id)sender {
    
    if (!_preferencesWindowController) {
        _preferencesWindowController = [[AMPreferencesWindowController alloc] initWithWindowNibName:kAMPreferencesWindowNibName];
        [_preferencesWindowController setTrayDatasource:self];
    }
    [_preferencesWindowController showWindow:self];
}

-(void)awakeFromNib
{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(applicationWillTerminateNotification:)
               name:NSApplicationWillTerminateNotification
             object:nil];
}

// Called before any other method of this class
+(void)initialize
{
    [AMPreferences registerDefaultPreferences];
}

-(void)applicationWillTerminateNotification:(NSNotification*)notification
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

#pragma mark - Implementation of AMTrayDatasourceProtocol -

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
            AMInsertableType insertableType = 1000;
            
            [self getInsertableClassName:&className
                           insertableTye:&insertableType
                                    info:&info
                      forTrayItemWithKey:key];
            
            NSColor * backgroundColor = colorFromData(itemPreferences[kAMBackColorKey]);
            NSColor * fontColor = colorFromData(itemPreferences[kAMFontColorKey]);
            item = [[AMTrayItem alloc] initWithKey:key
                                           iconKey:iconKey
                                             title:title
                                              info:info
                                   backgroundColor:backgroundColor
                                         fontColor:fontColor
                                   insertableClass:className
                                    insertableType:insertableType];
            
            [_trayDictionary setObject:item forKey:key];
        }
    }
    return _trayDictionary;
}

-(void)getInsertableClassName:(NSString**)className
                insertableTye:(AMInsertableType*)insertableType
                         info:(NSString**)info
           forTrayItemWithKey:(NSString*)key
{
    
    *className = [AMInsertableView description];
    
    if ( [key isEqualToString:kAMConstantKey] ) {
        *insertableType = AMInsertableTypeConstant;
        *info = @"Define a constant and assigns it a value. Once a constant is defined, you may refer to it anywhere on the worksheet, but you cannot change its value.";
        return;
    }

    if ( [key isEqualToString:kAMVariableKey] ) {
        *insertableType = AMInsertableTypeVariable;
        *info = @"Define a variable and assigns it a value. Once a variable is defined, you may refer to it anywhere on the worksheet below the position where it is introduced. At any later position, you can change its value either by explicitly assiging it a new value or implicitly, by referencing it in a set or range of values.";
        return;
    }

    if ( [key isEqualToString:kAMExpressionKey] ) {
        *insertableType = AMInsertableTypeExpression;
        *info = @"Define an algebraic expression. The expression can reference other mathematic objects defined above it. If all the objects it references can be evaluated, the expression itself can be evaluated.";
        return;
    }
    
    if ( [key isEqualToString:kAMFunctionKey]) {
        *insertableType = AMInsertableTypeFunction;
        *info = @"Define a function, including its name, argument list and return type. The function can also reference other mathematical objects defined above it.";
        return;
    }
    
    if ( [key isEqualToString:kAMEquationKey] ) {
        *insertableType = AMInsertableTypeEquation;
        *info = @"Define an equation.";
        return;
    }

    if ( [key isEqualToString:kAMVectorKey] ) {
        *insertableType = AMInsertableTypeVector;
        *info = @"Define a vector.";
        return;
    }
    
    if ( [key isEqualToString:kAMMatrixKey] ) {
        *insertableType = AMInsertableTypeMatrix;
        *info = @"Define a matrix.";
        return;
    }

    if ( [key isEqualToString:kAMMathematicalSetKey] ) {
        *insertableType = AMInsertableTypeMathematicalSet;
        *info = @"Define a set (technically a finite set).";
        return;
    }
    
    if ( [key isEqualToString:kAMGraph2DKey] ) {
        *insertableType = AMInsertableTypeGraph2D;
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
            [NSException raise:@"Dymmy variables should never be top-level objects" format:nil];
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
