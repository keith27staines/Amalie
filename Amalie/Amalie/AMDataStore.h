//
//  AMDataStore.h
//  Amalie
//
//  Created by Keith Staines on 25/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class NSManagedObjectContext;
@class AMDExpression;
@class AMDInsertedObject;
@class AMInsertableView;
@class KSMExpression;
@class AMDArgumentList;
@class AMDArgument;

#import <Foundation/Foundation.h>
#import "KSMMathValue.h"

@interface AMDataStore : NSObject

@property (weak, readwrite) NSManagedObjectContext * moc;

+(AMDataStore*)sharedDataStore;

-(id)initWithManagedObjectContext:(NSManagedObjectContext*)moc;

-(NSArray*)fetchObjectsFromEntityWithName:(NSString*)entityName
                      withSortDescriptors:(NSArray*)sortDescriptors
                                predicate:(NSPredicate*)predicate;

@end
