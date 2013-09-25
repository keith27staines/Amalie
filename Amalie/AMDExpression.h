//
//  AMDExpression.h
//  Amalie
//
//  Created by Keith Staines on 24/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AMDFunctionDef, AMDVariableDef;

@interface AMDExpression : NSManagedObject

@property (nonatomic, retain) NSString * originalString;
@property (nonatomic, retain) NSSet *functionDefs;
@property (nonatomic, retain) NSSet *variableDefs;
@end

@interface AMDExpression (CoreDataGeneratedAccessors)

- (void)addFunctionDefsObject:(AMDFunctionDef *)value;
- (void)removeFunctionDefsObject:(AMDFunctionDef *)value;
- (void)addFunctionDefs:(NSSet *)values;
- (void)removeFunctionDefs:(NSSet *)values;

- (void)addVariableDefsObject:(AMDVariableDef *)value;
- (void)removeVariableDefsObject:(AMDVariableDef *)value;
- (void)addVariableDefs:(NSSet *)values;
- (void)removeVariableDefs:(NSSet *)values;

@end
