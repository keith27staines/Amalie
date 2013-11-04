//
//  AMNameRules.m
//  Amalie
//
//  Created by Keith Staines on 23/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMNameRules.h"
#import "AMDataStore.h"
#import "NSString+KSMMath.h"

static AMNameRules * _sharedNameRules;

@interface AMNameRules()
{
    __weak NSManagedObjectContext * _moc;
}

@end

@implementation AMNameRules

+(AMNameRules *)sharedNameRules
{
    if (!_sharedNameRules) {
        _sharedNameRules = [[AMNameRules alloc] init];
    }
    return _sharedNameRules;
}


-(BOOL)validateProposedName:(NSString*)proposedName
         forType:(AMInsertableType)type
           error:(NSError**)error
{
    if (![self nameSyntaxValid:proposedName error:error]) {
        return NO;
    }
    
    if ( ![self nameIsUnique:proposedName error:error] ) {
        return NO;
    }
    return YES;
}

-(BOOL)nameSyntaxValid:(NSString*)name error:(NSError**)error
{
    if (!name) {
        if (error!=NULL) * error = [AMError errorWithCode:AMErrorCodeNameIsNull userInfo:nil];
        return NO;
    }
    
    if ( [name isEqualToString:@""] ) {
        if (error!=NULL) * error = [AMError errorWithCode:AMErrorCodeNameIsEmpty userInfo:nil];
        return NO;
    }
    return YES;
}

-(BOOL)nameIsUnique:(NSString*)name error:(NSError**)error
{

    AMDataStore * dataStore = [AMDataStore sharedDataStore];
    NSArray * amdNames = [dataStore fetchNames];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"string == %@",name];
    NSArray * filteredNames = [amdNames filteredArrayUsingPredicate:predicate];
    
    if (filteredNames.count > 0) {
        if (error!=NULL) * error = [AMError errorWithCode:AMErrorCodeNameIsNotUnique userInfo:nil];
        return NO;
    }
    return YES;
}


-(NSAttributedString*)suggestNameForType:(AMInsertableType)type
{
    static NSUInteger i;
    i++;
    NSString * firstLetter = @"K";
    NSString * followingString = [NSString stringWithFormat:@"%ld",i];
    NSDictionary * subscriptAttributes = @{NSSuperscriptAttributeName: @-1};
    NSAttributedString * subscript;
    subscript = [[NSAttributedString alloc] initWithString:(NSString *)followingString attributes:subscriptAttributes];
    NSMutableAttributedString * ms = [[NSMutableAttributedString alloc] initWithString:firstLetter attributes:nil];
    [ms appendAttributedString:subscript];
    return [ms copy];
}

@end
