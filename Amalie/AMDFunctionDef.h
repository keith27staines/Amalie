//
//  AMDFunctionDef.h
//  Amalie
//
//  Created by Keith Staines on 01/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AMDInsertedObject.h"

@class AMDArgument, AMDArgumentList;

@interface AMDFunctionDef : AMDInsertedObject

@property (nonatomic, retain) NSNumber * returnType;
@property (nonatomic, retain) AMDArgumentList *argumentList;
@property (nonatomic, retain) NSSet *transformsArguments;
@end

@interface AMDFunctionDef (CoreDataGeneratedAccessors)

- (void)addTransformsArgumentsObject:(AMDArgument *)value;
- (void)removeTransformsArgumentsObject:(AMDArgument *)value;
- (void)addTransformsArguments:(NSSet *)values;
- (void)removeTransformsArguments:(NSSet *)values;

@end
