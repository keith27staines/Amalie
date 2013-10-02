//
//  AMDArgumentList.h
//  Amalie
//
//  Created by Keith Staines on 01/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AMDArgument, AMDFunctionDef;

@interface AMDArgumentList : NSManagedObject

@property (nonatomic, retain) NSSet *arguments;
@property (nonatomic, retain) AMDFunctionDef *functionDef;
@end

@interface AMDArgumentList (CoreDataGeneratedAccessors)

- (void)addArgumentsObject:(AMDArgument *)value;
- (void)removeArgumentsObject:(AMDArgument *)value;
- (void)addArguments:(NSSet *)values;
- (void)removeArguments:(NSSet *)values;

@end
