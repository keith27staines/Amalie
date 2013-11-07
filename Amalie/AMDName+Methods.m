//
//  AMDName+Methods.m
//  Amalie
//
//  Created by Keith Staines on 07/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

static NSString * const kAMDENTITYNAME = @"AMDNames";

#import "AMDName+Methods.h"
#import "NSManagedObject+SharedDataStore.h"

@implementation AMDName (Methods)

+(AMDName*)makeAMDNameForType:(AMInsertableType)type;
{
    NSString * defaultName = nil;
    AMDName * aName;
    BOOL mustBeUnique;
    
    switch (type) {
        case AMInsertableTypeConstant:
        {
            defaultName = @"K";
            mustBeUnique = YES;
            break;
        }
        case AMInsertableTypeVariable:
        {
            defaultName = @"x";
            mustBeUnique = YES;
            break;
        }
        case AMInsertableTypeDummyVariable:
        {
            defaultName = @"x";
            mustBeUnique = NO;
            break;
        }
        case AMInsertableTypeFunction:
        {
            defaultName = @"f";
            mustBeUnique = YES;
            break;
        }
        default:
            // TODO: replace default with explicit cases
            mustBeUnique = YES;
            NSAssert(NO, @"NO IMPLEMENTATION");
            break;
    }
    
    if (!mustBeUnique) {
        aName = [self fetchDummyVariableWithName:defaultName];
    }
    
    if (!aName) {
        aName = [NSEntityDescription insertNewObjectForEntityForName:kAMDENTITYNAME
                                              inManagedObjectContext:self.moc];
        aName.string = [self suggestMustBeUniqueNameBasedOn:defaultName];
        aName.attributedString = [[NSAttributedString alloc] initWithString:aName.string attributes:nil];
    }
    
    aName.mustBeUnique = @(mustBeUnique);
    return aName;
}

+(NSString*)suggestMustBeUniqueNameBasedOn:(NSString*)string
{
    NSString * try = [string copy];
    BOOL isUnique = NO;
    NSUInteger i = 0;
    while (!isUnique) {
        isUnique = YES;
        NSArray * similarNames = [self fetchMustBeUniqueNamesBeginningWith:string];
        for (AMDName * otherName in similarNames) {
            if ([otherName.string isEqualToString:try]) {
                isUnique = NO;
                i++;
                try = [string stringByAppendingString:[NSString stringWithFormat:@"%lu",i]];
                break;
            }
        }
    }
    return try;
}

+(AMDName*)fetchDummyVariableWithName:(NSString*)name
{
    NSArray * allNames = [self fetchNames];
    NSPredicate * predicate;
    predicate = [NSPredicate predicateWithFormat:@"(string like %@) AND (mustBeUnique == %@)", name, @(NO)];
    NSArray * filtered = [allNames filteredArrayUsingPredicate:predicate];
    if (filtered.count == 0) {
        return nil;
    } else {
        return filtered[0];
    }
}

+(NSArray*)fetchNames
{
    NSManagedObjectContext * moc = self.moc;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    NSError * fetchError;
    NSEntityDescription * namesEntity = [NSEntityDescription entityForName:kAMDENTITYNAME
                                                    inManagedObjectContext:moc];
    [fetchRequest setEntity:namesEntity];
    NSArray * names = [moc executeFetchRequest:fetchRequest error:&fetchError];
    return names;
}

+(NSArray*)fetchMustBeUniqueNamesBeginningWith:(NSString*)start
{
    NSArray * allNames = [self fetchNames];
    NSPredicate * predicate;
    predicate = [NSPredicate predicateWithFormat:@"(string beginsWith %@) AND (mustBeUnique == %@)", start,@(YES)];
    NSArray * result = [allNames filteredArrayUsingPredicate:predicate];
    return result;
}


@end