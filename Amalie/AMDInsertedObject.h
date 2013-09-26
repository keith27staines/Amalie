//
//  AMDInsertedObject.h
//  Amalie
//
//  Created by Keith Staines on 26/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AMDExpression, AMDName;

@interface AMDInsertedObject : NSManagedObject

@property (nonatomic, retain) NSString * groupID;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * insertType;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * xPosition;
@property (nonatomic, retain) NSNumber * yPosition;
@property (nonatomic, retain) AMDName *name;
@property (nonatomic, retain) NSOrderedSet *expressions;
@end

@interface AMDInsertedObject (CoreDataGeneratedAccessors)

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
