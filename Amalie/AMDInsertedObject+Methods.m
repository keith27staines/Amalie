//
//  AMDInsertedObject+Methods.m
//  Amalie
//
//  Created by Keith Staines on 07/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMDInsertedObject+Methods.h"
#import "NSManagedObject+SharedDataStore.h"
#import "NSString+KSMMath.h"
#import "AMDataStore.h"
#import "AMInsertableView.h"
#import "AMDName+Methods.h"
#import "AMDIndexedExpression+Methods.h"
#import "AMDFunctionDef+Methods.h"

static NSString * const kAMDENTITYNAME = @"AMDInsertedObjects";

@implementation AMDInsertedObject (Methods)

+(AMDInsertedObject*)amdInsertedObjectForInsertedView:(AMInsertableView*)view
{
    AMDInsertedObject * amdInsertedObject = [self fetchInsertedObjectWithGroupID:view.groupID];
    if (!amdInsertedObject) {
        amdInsertedObject = [self makeAMDInsertedObjectForInsertedView:view];
    }
    return amdInsertedObject;
}

+(AMDInsertedObject*)makeAMDInsertedObjectForInsertedView:(AMInsertableView*)view
{
    AMDInsertedObject * amd;
    switch (view.insertableType) {
        case AMInsertableTypeFunction:
        {
            amd = [AMDFunctionDef makeFunctionDef];
            break;
        }
        default:
        {
            // TODO: eliminate default:, replace with individual cases
            NSAssert(NO, @"NOT IMPLEMENTED");
            break;
        }
    }
    amd.groupID    = view.groupID;
    amd.name       = [AMDName makeAMDNameForType:view.insertableType];
    amd.xPosition  = @(view.frame.origin.x);
    amd.yPosition  = @(view.frame.origin.y);
    amd.width      = @(view.frame.size.width);
    amd.height     = @(view.frame.size.height);
    amd.insertType = @(view.insertableType);
    
    AMDIndexedExpression * iexpr = [AMDIndexedExpression makeIndexedExpression];
    [amd addIndexedExpressionsObject:iexpr];
    
    return amd;
}

+(AMDInsertedObject*)fetchInsertedObjectWithGroupID:(NSString * )groupID
{
    NSPredicate * predicate;
    predicate = [NSPredicate predicateWithFormat:@"(groupID == %@)", groupID];
    NSArray * results = [self.dataStore fetchObjectsFromEntityWithName:kAMDENTITYNAME withSortDescriptors:nil predicate:predicate];
    NSAssert(results.count < 2, @"Unexpected number of results.");
    
    if (results.count == 1) {
        return results[0];
    } else {
        return nil;
    }
}

+(NSArray*)fetchInsertedObjectsInDisplayOrder
{
    NSSortDescriptor * sortByY = [[NSSortDescriptor alloc] initWithKey:@"yPosition" ascending:NO];
    NSSortDescriptor * sortByX = [[NSSortDescriptor alloc] initWithKey:@"xPosition" ascending:YES];
    return [self.dataStore fetchObjectsFromEntityWithName:kAMDENTITYNAME withSortDescriptors:@[sortByY, sortByX] predicate:nil];
}

+(AMDataStore*)dataStore
{
    return [AMDataStore sharedDataStore];
}

@end
