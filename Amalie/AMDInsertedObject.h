//
//  AMDInsertedObject.h
//  Amalie
//
//  Created by Keith Staines on 01/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AMDIndexedExpression, AMDName;

@interface AMDInsertedObject : NSManagedObject

@property (nonatomic, retain) NSString * groupID;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * insertType;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * xPosition;
@property (nonatomic, retain) NSNumber * yPosition;
@property (nonatomic, retain) NSSet *indexedExpressions;
@property (nonatomic, retain) AMDName *name;
@end

@interface AMDInsertedObject (CoreDataGeneratedAccessors)

- (void)addIndexedExpressionsObject:(AMDIndexedExpression *)value;
- (void)removeIndexedExpressionsObject:(AMDIndexedExpression *)value;
- (void)addIndexedExpressions:(NSSet *)values;
- (void)removeIndexedExpressions:(NSSet *)values;

@end
