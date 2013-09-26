//
//  AMDArgumentList.h
//  Amalie
//
//  Created by Keith Staines on 26/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AMDArgument, AMDFunctionDef;

@interface AMDArgumentList : NSManagedObject

@property (nonatomic, retain) NSOrderedSet *arguments;
@property (nonatomic, retain) AMDFunctionDef *functionDef;
@end

@interface AMDArgumentList (CoreDataGeneratedAccessors)

- (void)insertObject:(AMDArgument *)value inArgumentsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromArgumentsAtIndex:(NSUInteger)idx;
- (void)insertArguments:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeArgumentsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInArgumentsAtIndex:(NSUInteger)idx withObject:(AMDArgument *)value;
- (void)replaceArgumentsAtIndexes:(NSIndexSet *)indexes withArguments:(NSArray *)values;
- (void)addArgumentsObject:(AMDArgument *)value;
- (void)removeArgumentsObject:(AMDArgument *)value;
- (void)addArguments:(NSOrderedSet *)values;
- (void)removeArguments:(NSOrderedSet *)values;
@end
