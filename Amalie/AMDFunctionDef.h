//
//  AMDFunctionDef.h
//  Amalie
//
//  Created by Keith Staines on 24/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AMDInsertedObject.h"

@class AMDArgumentList, AMDExpression;

@interface AMDFunctionDef : AMDInsertedObject

@property (nonatomic, retain) NSNumber * returnType;
@property (nonatomic, retain) AMDArgumentList *argumentList;
@property (nonatomic, retain) NSOrderedSet *expressions;
@end

@interface AMDFunctionDef (CoreDataGeneratedAccessors)

- (void)insertObject:(AMDExpression *)value inExpressionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromExpressionsAtIndex:(NSUInteger)idx;
- (void)insertExpressions:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeExpressionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInExpressionsAtIndex:(NSUInteger)idx withObject:(AMDExpression *)value;
- (void)replaceExpressionsAtIndexes:(NSIndexSet *)indexes withExpressions:(NSArray *)values;
- (void)addExpressionsObject:(AMDExpression *)value;
- (void)removeExpressionsObject:(AMDExpression *)value;
- (void)addExpressions:(NSOrderedSet *)values;
- (void)removeExpressions:(NSOrderedSet *)values;
@end
