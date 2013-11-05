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

// Inserted objects
-(AMDInsertedObject*)amdInsertedObjectForInsertedView:(AMInsertableView*)view;
-(AMDInsertedObject*)fetchInsertedObjectWithGroupID:(NSString * )groupID;
-(NSArray*)fetchInsertedObjectsInDisplayOrder;

// Names
-(NSArray*)fetchNames;
-(NSArray*)fetchMustBeUniqueNamesBeginningWith:(NSString*)start;
-(NSString*)suggestMustBeUniqueNameBasedOn:(NSString*)string;

// Expressions
-(AMDExpression *)fetchOrMakeExpressionMatching:(KSMExpression*)ksmExpression;
-(AMDExpression*)fetchExpressionWithSymbol:(NSString*)symbol;
-(AMDExpression*)fetchExpressionWithOriginalString:(NSString*)originalString;

// Functions

// Argument List
-(AMDArgument*)addArgumentOfType:(KSMValueType)mathType toArgumentList:(AMDArgumentList*)argumentList;
-(void)deleteArgument:(AMDArgument*)argument;

@end
