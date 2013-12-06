//
//  AMDataStore.m
//  Amalie
//
//  Created by Keith Staines on 25/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AMDataStore.h"
#import "AMDName+Methods.h"

static AMDataStore * _sharedDatastore;

@interface AMDataStore()
{
    __weak NSManagedObjectContext * _moc;
}

@end

@implementation AMDataStore

+(AMDataStore*)sharedDataStore
{
    if (!_sharedDatastore) {
        _sharedDatastore = [[AMDataStore alloc] init];
    }
    return _sharedDatastore;
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc
{
    self = [super init];
    if (self) {
        _moc = moc;
    }
    return self;
}

-(NSArray*)fetchObjectsFromEntityWithName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors predicate:(NSPredicate*)predicate
{
    NSManagedObjectContext * moc = self.moc;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    NSError * fetchError;
    NSEntityDescription * entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:predicate];
    NSArray * results = [moc executeFetchRequest:fetchRequest error:&fetchError];
    return results;
}

-(AMDInsertedObject*)insertedObjectWithName:(NSString*)name
{
    // Get object with the specified name (ignoring dummy variable names)
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"mustBeUnique = 1"];
    NSArray * names = [self fetchObjectsFromEntityWithName:@"AMDNames"
                                            withSortDescriptors:nil
                                                      predicate:predicate];
    NSAssert(names.count < 2, @"More than one occurence of a name (%@) that should be unique.",name);
    AMDName * amdName = names[0];
    return amdName.insertedObject;
}

@end
