//
//  AMDName.h
//  Amalie
//
//  Created by Keith Staines on 24/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AMDArgument, AMDInsertedObject;

@interface AMDName : NSManagedObject

@property (nonatomic, retain) id attributedString;
@property (nonatomic, retain) NSString * string;
@property (nonatomic, retain) NSSet *arguments;
@property (nonatomic, retain) AMDInsertedObject *insertedObject;
@end

@interface AMDName (CoreDataGeneratedAccessors)

- (void)addArgumentsObject:(AMDArgument *)value;
- (void)removeArgumentsObject:(AMDArgument *)value;
- (void)addArguments:(NSSet *)values;
- (void)removeArguments:(NSSet *)values;

@end
