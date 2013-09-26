//
//  AMDExpression.h
//  Amalie
//
//  Created by Keith Staines on 26/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AMDInsertedObject;

@interface AMDExpression : NSManagedObject

@property (nonatomic, retain) NSString * originalString;
@property (nonatomic, retain) NSSet *insertedObjects;
@end

@interface AMDExpression (CoreDataGeneratedAccessors)

- (void)addInsertedObjectsObject:(AMDInsertedObject *)value;
- (void)removeInsertedObjectsObject:(AMDInsertedObject *)value;
- (void)addInsertedObjects:(NSSet *)values;
- (void)removeInsertedObjects:(NSSet *)values;

@end
