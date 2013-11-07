//
//  AMDExpression+Methods.m
//  Amalie
//
//  Created by Keith Staines on 07/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMDExpression+Methods.h"
#import "NSManagedObject+SharedDataStore.h"
#import "NSString+KSMMath.h"
#import "KSMExpression.h"
#import "AMDataStore.h"

static NSString * const kAMDENTITYNAME = @"AMDExpressions";

@implementation AMDExpression (Methods)


+(AMDExpression*)makeExpression
{
    AMDExpression * e = [NSEntityDescription insertNewObjectForEntityForName:kAMDENTITYNAME
                         
                                                      inManagedObjectContext:self.moc];
    return e;
}

+(AMDExpression *)fetchOrMakeExpressionMatching:(KSMExpression*)ksmExpression
{
    AMDExpression * fetchResult = [self fetchExpressionWithSymbol:ksmExpression.symbol originalString:ksmExpression.originalString];
    if (!fetchResult) {
        fetchResult = [self makeExpression];
        fetchResult.symbol = ksmExpression.symbol;
        fetchResult.originalString = ksmExpression.originalString;
    }
    return fetchResult;
}

+(AMDExpression *)fetchExpressionWithSymbol:(NSString *)symbol
{
    NSPredicate * predicate;
    predicate = [NSPredicate predicateWithFormat:@"(symbol == %@)", symbol];
    NSArray * results = [self.dataStore fetchObjectsFromEntityWithName:kAMDENTITYNAME withSortDescriptors:nil predicate:predicate];
    NSAssert(results.count < 2, @"Unexpected number of results.");
    if (results.count == 0) return nil;
    return results[0];
}

+(AMDExpression *)fetchExpressionWithOriginalString:(NSString *)originalString
{
    NSPredicate * predicate;
    predicate = [NSPredicate predicateWithFormat:@"(originalString == %@)", originalString];
    NSArray * results = [self.dataStore fetchObjectsFromEntityWithName:kAMDENTITYNAME withSortDescriptors:nil predicate:predicate];
    NSAssert(results.count < 2, @"Unexpected number of results.");
    if (results.count == 0) return nil;
    return results[0];
}

+(AMDExpression *)fetchExpressionWithSymbol:(NSString*)symbol originalString:(NSString *)originalString
{
    NSPredicate * predicate;
    predicate = [NSPredicate predicateWithFormat:@"(symbol == %@ AND originalString == %@)", symbol, originalString];
    NSArray * results = [self.dataStore fetchObjectsFromEntityWithName:kAMDENTITYNAME withSortDescriptors:nil predicate:predicate];
    NSAssert(results.count < 2, @"Unexpected number of results.");
    if (results.count == 0) return nil;
    return results[0];
}

+(AMDataStore*)dataStore
{
    return [AMDataStore sharedDataStore];
}

@end
