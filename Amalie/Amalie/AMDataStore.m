//
//  AMDataStore.m
//  Amalie
//
//  Created by Keith Staines on 25/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AMInsertableView.h"
#import "KSMMathValue.h"

#import "AMDataStore.h"
#import "AMDInsertedObject.h"
#import "AMDFunctionDef.h"
#import "AMDExpression.h"
#import "AMDMathValue.h"
#import "AMDVariableDef.h"
#import "AMDMathValue.h"
#import "AMDArgumentList.h"
#import "AMDArgument.h"

#import "AMDName.h"

static NSString * const kAMDEntityNames           = @"AMDNames";
static NSString * const kAMDEntityInsertedObjects = @"AMDInsertedObjects";
static NSString * const kAMDEntityFunctionDefs    = @"AMDFunctionDefs";
static NSString * const kAMDEntityExpressions     = @"AMDExpressions";
static NSString * const kAMDEntityArgumentLists   = @"AMDArgumentLists";
static NSString * const kAMDEntityArguments       = @"AMDArguments";
static NSString * const kAMDEntityMathValues      = @"AMDMathValues";

@interface AMDataStore()
{
    __weak NSManagedObjectContext * _moc;
}

@end

@implementation AMDataStore

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc
{
    self = [super init];
    if (self) {
        _moc = moc;
    }
    return self;
}

#pragma mark - Core data glue -

-(AMDInsertedObject*)amdInsertedObjectForInsertedView:(AMInsertableView*)view
{
    AMDInsertedObject * amdInsertedObject = [self fetchInsertedObjectWithGroupID:view.groupID];
    if (!amdInsertedObject) {
        amdInsertedObject = [self makeAMDInsertedObjectForInsertedView:view];
    }
    return amdInsertedObject;
}

-(AMDInsertedObject*)makeAMDInsertedObjectForInsertedView:(AMInsertableView*)view
{
    AMDInsertedObject * amd;
    switch (view.insertableType) {
        case AMInsertableTypeFunction:
        {
            amd = [self makeFunctionDef];
            break;
        }
        default:
        {
            // TODO: eliminate default:, replace with individual cases
            NSAssert(NO, @"NOT IMPLEMENTED");
            break;
        }
    }
    amd.groupID   = view.groupID;
    amd.name      = [self makeAMDNameForType:view.insertableType];
    amd.xPosition = @(view.frame.origin.x);
    amd.yPosition = @(view.frame.origin.y);
    amd.width     = @(view.frame.size.width);
    amd.height    = @(view.frame.size.height);
    
    return amd;
}

-(AMDFunctionDef*)makeFunctionDef
{
    AMDFunctionDef * f = nil;
    f = [NSEntityDescription insertNewObjectForEntityForName:kAMDEntityFunctionDefs
                                      inManagedObjectContext:self.moc];
    f.argumentList = [self makeArgumentList];
    f.expressions = [NSMutableOrderedSet orderedSetWithArray:@[[self makeExpression]]];
    f.returnType = @(KSMValueDouble);
    return f;
}

-(AMDArgumentList*)makeArgumentList
{
    AMDArgumentList * l = [NSEntityDescription insertNewObjectForEntityForName:kAMDEntityArgumentLists
                                                        inManagedObjectContext:self.moc];
    l.arguments = [NSMutableOrderedSet orderedSetWithArray:@[ [self makeArgument] ]];
    return l;
}

-(AMDArgument*)makeArgument
{
    AMDArgument * a = [NSEntityDescription insertNewObjectForEntityForName:kAMDEntityArguments
                                                    inManagedObjectContext:self.moc];
    a.name = [self makeAMDNameForType:AMInsertableTypeVariable];
    a.mathValue = [self makeMathValue];
    return a;
}

-(AMDExpression*)makeExpression
{
    return [NSEntityDescription insertNewObjectForEntityForName:kAMDEntityExpressions
                                         inManagedObjectContext:self.moc];
}

-(AMDMathValue*)makeMathValue
{
    // TODO: mathvalue is transformable, so need to make KSMMathValue conform to NSCoding
    return nil;
}

-(AMDName*)makeAMDNameForType:(AMInsertableType)type
{
    NSString * defaultName = nil;
    AMDName * aName = [NSEntityDescription insertNewObjectForEntityForName:kAMDEntityNames
                                                    inManagedObjectContext:self.moc];
    switch (type) {
        case AMInsertableTypeConstant:
            defaultName = @"K";
            break;
        case AMInsertableTypeVariable:
            defaultName = @"x";
            break;
        case AMInsertableTypeFunction:
            defaultName = @"f";
            break;
        default:
            // TODO: replace default with explicit cases
            NSAssert(NO, @"NO IMPLEMENTATION");
            break;
    }
    aName.string = [self suggestUniqueNameStringBasedOn:defaultName];
    aName.attributedString = [[NSAttributedString alloc] initWithString:aName.string attributes:nil];
    return aName;
}

-(NSString*)suggestUniqueNameStringBasedOn:(NSString*)string
{
    NSString * try = [string copy];
    NSArray * similarNames = [self fetchNamesLikeThis:string];
    BOOL isUnique = NO;
    NSUInteger i = 0;
    while (!isUnique) {
        isUnique = YES;
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


-(NSArray*)fetchNames
{
    NSManagedObjectContext * moc = self.moc;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    NSError * fetchError;
    NSEntityDescription * namesEntity = [NSEntityDescription entityForName:kAMDEntityNames
                                                    inManagedObjectContext:moc];
    [fetchRequest setEntity:namesEntity];
    NSArray * names = [moc executeFetchRequest:fetchRequest error:&fetchError];
    return names;
}

-(NSArray*)fetchNamesLikeThis:(NSString*)pattern
{
    NSArray * allNames = [self fetchNames];
    NSPredicate * predicate;
    predicate = [NSPredicate predicateWithFormat:@"(string like %@)", pattern];
    NSArray * result = [allNames filteredArrayUsingPredicate:predicate];
    return result;
}

-(AMDInsertedObject*)fetchInsertedObjectWithGroupID:(NSString * )groupID
{
    NSArray * insertedObjects = [self fetchInsertedObjectsWithSortDescriptors:nil];
    NSPredicate * predicate;
    predicate = [NSPredicate predicateWithFormat:@"(groupID == %@)", groupID];
    NSArray * result = [insertedObjects filteredArrayUsingPredicate:predicate];
    NSAssert(result.count < 2, @"Unexpected number of results.");
    
    if (result.count == 1) {
        return result[0];
    } else {
        return nil;
    }
}

-(NSEntityDescription*)amdInsertedObjectsEntity
{
    return [NSEntityDescription entityForName:kAMDEntityInsertedObjects
                       inManagedObjectContext:self.moc];
}

-(NSArray*)fetchInsertedObjectsWithSortDescriptors:(NSArray*)sortDescriptors
{
    NSManagedObjectContext * moc = self.moc;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError * fetchError;
    [fetchRequest setEntity:[self amdInsertedObjectsEntity]];
    return [moc executeFetchRequest:fetchRequest error:&fetchError];
}

-(NSArray*)fetchInsertedObjectsInDisplayOrder
{
    NSSortDescriptor * sortByY = [[NSSortDescriptor alloc] initWithKey:@"y" ascending:NO];
    NSSortDescriptor * sortByX = [[NSSortDescriptor alloc] initWithKey:@"x" ascending:YES];
    return [self fetchInsertedObjectsWithSortDescriptors:@[sortByY, sortByX]];
}


@end
