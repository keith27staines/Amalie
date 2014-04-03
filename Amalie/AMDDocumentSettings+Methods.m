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

+(AMDDocumentSettings*)makeDocumentSettings
{
    AMDDocumentSettings * settings = [NSEntityDescription insertNewObjectForEntityForName:kAMDENTITYNAME inManagedObjectContext:self.moc];
    return settings;
}
+(AMDDocumentSettings*)fetchDocumentSettings
{
    NSArray * results = [self.dataStore fetchObjectsFromEntityWithName:kAMDENTITYNAME withSortDescriptors:nil predicate:nil];
    NSAssert(results.count < 2, @"Unexpected number of results.");
    
    switch (results.count) {
        case 0:
            return nil;
        case 1:
            return results[0];
        default:
            NSAssert(NO, @"There is more than one set of document settings associated with this document");
            return results[0];
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
