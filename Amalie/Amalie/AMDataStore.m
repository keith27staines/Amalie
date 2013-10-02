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
#import "KSMExpression.h"

#import "AMDataStore.h"
#import "AMDInsertedObject.h"
#import "AMDFunctionDef.h"
#import "AMDExpression.h"
#import "AMDVariableDef.h"
#import "AMDArgumentList.h"
#import "AMDArgument.h"
#import "AMDIndexedExpression.h"

#import "KSMVector.h"
#import "KSMMatrix.h"

#import "AMDName.h"

static NSString * const kAMDEntityNames              = @"AMDNames";
static NSString * const kAMDEntityInsertedObjects    = @"AMDInsertedObjects";
static NSString * const kAMDEntityFunctionDefs       = @"AMDFunctionDefs";
static NSString * const kAMDEntityExpressions        = @"AMDExpressions";
static NSString * const kAMDEntityArgumentLists      = @"AMDArgumentLists";
static NSString * const kAMDEntityArguments          = @"AMDArguments";
static NSString * const kAMDEntityMathValues         = @"AMDMathValues";
static NSString * const kAMDEntityIndexedExpressions = @"AMDIndexedExpressions";

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

#pragma mark - Inserted Objects -

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
    amd.groupID    = view.groupID;
    amd.name       = [self makeAMDNameForType:view.insertableType];
    amd.xPosition  = @(view.frame.origin.x);
    amd.yPosition  = @(view.frame.origin.y);
    amd.width      = @(view.frame.size.width);
    amd.height     = @(view.frame.size.height);
    amd.insertType = @(view.insertableType);

    AMDIndexedExpression * iexpr = [self makeIndexedExpression];
    [amd addIndexedExpressionsObject:iexpr];
    
    return amd;
}

-(AMDInsertedObject*)fetchInsertedObjectWithGroupID:(NSString * )groupID
{
    NSPredicate * predicate;
    predicate = [NSPredicate predicateWithFormat:@"(groupID == %@)", groupID];
    NSArray * results = [self fetchObjectsFromEntityWithName:kAMDEntityInsertedObjects withSortDescriptors:nil predicate:predicate];
    NSAssert(results.count < 2, @"Unexpected number of results.");
    
    if (results.count == 1) {
        return results[0];
    } else {
        return nil;
    }
}

-(NSArray*)fetchInsertedObjectsInDisplayOrder
{
    NSSortDescriptor * sortByY = [[NSSortDescriptor alloc] initWithKey:@"yPosition" ascending:NO];
    NSSortDescriptor * sortByX = [[NSSortDescriptor alloc] initWithKey:@"xPosition" ascending:YES];
    return [self fetchObjectsFromEntityWithName:kAMDEntityInsertedObjects withSortDescriptors:@[sortByY, sortByX] predicate:nil];
}


#pragma mark - Function Defs -

-(AMDFunctionDef*)makeFunctionDef
{
    AMDFunctionDef * f = nil;
    f = [NSEntityDescription insertNewObjectForEntityForName:kAMDEntityFunctionDefs
                                      inManagedObjectContext:self.moc];
    f.argumentList = [self makeArgumentList];
    f.returnType = @(KSMValueDouble);
   // f.transformsArguments = [NSMutableSet set];
    
    return f;
}

#pragma mark - Argument Lists -

-(AMDArgumentList*)makeArgumentList
{
    AMDArgumentList * l = [NSEntityDescription insertNewObjectForEntityForName:kAMDEntityArgumentLists
                                                        inManagedObjectContext:self.moc];
    
    AMDArgument * a = [self makeArgumentOfType:KSMValueDouble];
    a.index = @(0);
    a.name.string = @"x";
    a.name.attributedString = [[NSAttributedString alloc] initWithString:a.name.string];
    [l addArgumentsObject:a];
    return l;
}

-(AMDArgument*)makeArgumentOfType:(KSMValueType)mathType
{
    AMDArgument * a = [NSEntityDescription insertNewObjectForEntityForName:kAMDEntityArguments
                                                    inManagedObjectContext:self.moc];
    a.name = [self makeAMDNameForType:AMInsertableTypeVariable];
    switch (mathType) {
        case KSMValueInteger:
            a.mathValue = [KSMMathValue mathValueFromInteger:0];
            break;
        case KSMValueDouble:
            a.mathValue = [KSMMathValue mathValueFromDouble:0.0];
            break;
        case KSMValueVector:
            a.mathValue = [KSMMathValue mathValueFromVector:[KSMVector zero3DVector]];
            break;
        case KSMValueMatrix:
            a.mathValue = [KSMMathValue mathValueFromMatrix:[KSMMatrix zeroMatrixOfDimension:3]];
            break;
    }
    return a;
}

#pragma mark - Indexed expressions -
-(AMDIndexedExpression*)makeIndexedExpression
{
    return [self makeIndexedExpressionWithIndex:0];
}

-(AMDIndexedExpression*)makeIndexedExpressionWithIndex:(NSUInteger)index
{
    AMDIndexedExpression * iexpr = [NSEntityDescription insertNewObjectForEntityForName:kAMDEntityIndexedExpressions inManagedObjectContext:self.moc];
    iexpr.index = @(index);
    iexpr.expression = [self makeExpression];
    return iexpr;
}


-(AMDIndexedExpression*)makeIndexedExpressionWithIndex:(NSUInteger)index expression:(AMDExpression*)expression
{
    AMDIndexedExpression * iexpr = [self makeIndexedExpressionWithIndex:index];
    iexpr.expression = expression;
    return iexpr;
}

#pragma mark - Expressions -

-(AMDExpression*)makeExpression
{
    AMDExpression * e = [NSEntityDescription insertNewObjectForEntityForName:kAMDEntityExpressions
                         
                                                      inManagedObjectContext:self.moc];
    return e;
}

-(AMDExpression *)fetchOrMakeExpressionMatching:(KSMExpression*)ksmExpression
{
    AMDExpression * fetchResult = [self fetchExpressionWithSymbol:ksmExpression.symbol originalString:ksmExpression.originalString];
    if (!fetchResult) {
        fetchResult = [self makeExpression];
        fetchResult.symbol = ksmExpression.symbol;
        fetchResult.originalString = ksmExpression.originalString;
    }
    return fetchResult;
}

-(AMDExpression *)fetchExpressionWithSymbol:(NSString *)symbol
{
    NSPredicate * predicate;
    predicate = [NSPredicate predicateWithFormat:@"(symbol == %@)", symbol];
    NSArray * results = [self fetchObjectsFromEntityWithName:kAMDEntityExpressions withSortDescriptors:nil predicate:predicate];
    NSAssert(results.count < 2, @"Unexpected number of results.");
    if (results.count == 0) return nil;
    return results[0];
}

-(AMDExpression *)fetchExpressionWithOriginalString:(NSString *)originalString
{
    NSPredicate * predicate;
    predicate = [NSPredicate predicateWithFormat:@"(originalString == %@)", originalString];
    NSArray * results = [self fetchObjectsFromEntityWithName:kAMDEntityExpressions withSortDescriptors:nil predicate:predicate];
    NSAssert(results.count < 2, @"Unexpected number of results.");
    if (results.count == 0) return nil;
    return results[0];
}

-(AMDExpression *)fetchExpressionWithSymbol:(NSString*)symbol originalString:(NSString *)originalString
{
    NSPredicate * predicate;
    predicate = [NSPredicate predicateWithFormat:@"(symbol == %@ AND originalString == %@)", symbol, originalString];
    NSArray * results = [self fetchObjectsFromEntityWithName:kAMDEntityExpressions withSortDescriptors:nil predicate:predicate];
    NSAssert(results.count < 2, @"Unexpected number of results.");
    if (results.count == 0) return nil;
    return results[0];
}

#pragma mark - Names -

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



@end
