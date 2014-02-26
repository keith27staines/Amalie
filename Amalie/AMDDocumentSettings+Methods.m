//
//  AMDDocumentSettings+Methods.m
//  Amalie
//
//  Created by Keith Staines on 26/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMDDocumentSettings+Methods.h"

#import "NSManagedObject+SharedDataStore.h"
#import "AMConstants.h"
#import "AMDataStore.h"

static NSString * const kAMDENTITYNAME = @"AMDDocumentSettings";

@implementation AMDDocumentSettings (Methods)

+(AMDDocumentSettings*)fetchOrMakeDocumentSettings
{
    AMDDocumentSettings * settings = [self fetchDocumentSettings];
    if (!settings) {
        settings = [self makeDocumentSettings];
    }
    return settings;
}

+(AMDDocumentSettings*)makeDocumentSettings
{
    AMDDocumentSettings * settings = [NSEntityDescription insertNewObjectForEntityForName:kAMDENTITYNAME inManagedObjectContext:self.moc];
    return settings;
}
+(AMDDocumentSettings*)fetchDocumentSettings
{
    NSArray * results = [self.dataStore fetchObjectsFromEntityWithName:kAMDENTITYNAME withSortDescriptors:nil predicate:nil];
    NSAssert(results.count < 2, @"Unexpected number of results.");
    
    if (results.count == 1) {
        return results[0];
    } else {
        return nil;
    }
}
-(NSUndoManager*)undoManager
{
    return self.managedObjectContext.undoManager;
}
+(AMDataStore*)dataStore
{
    return [AMDataStore sharedDataStore];
}

@end
