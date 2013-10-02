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

#import <Foundation/Foundation.h>

@interface AMDataStore : NSObject

@property (weak, readwrite) NSManagedObjectContext * moc;

-(id)initWithManagedObjectContext:(NSManagedObjectContext*)moc;

// Inserted objects
-(AMDInsertedObject*)amdInsertedObjectForInsertedView:(AMInsertableView*)view;
-(AMDInsertedObject*)fetchInsertedObjectWithGroupID:(NSString * )groupID;
-(NSArray*)fetchInsertedObjectsInDisplayOrder;

// Names
-(NSArray*)fetchNames;
-(NSArray*)fetchNamesLikeThis:(NSString*)pattern;
-(NSString*)suggestUniqueNameStringBasedOn:(NSString*)string;

// Expressions
-(AMDExpression *)fetchOrMakeExpressionMatching:(KSMExpression*)ksmExpression;
-(AMDExpression*)fetchExpressionWithSymbol:(NSString*)symbol;
-(AMDExpression*)fetchExpressionWithOriginalString:(NSString*)originalString;

// Functions

@end
