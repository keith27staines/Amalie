//
//  AMDVariableDef.h
//  Amalie
//
//  Created by Keith Staines on 24/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AMDInsertedObject.h"

@class AMDExpression, AMDMathValue;

@interface AMDVariableDef : AMDInsertedObject

@property (nonatomic, retain) NSNumber * isConstant;
@property (nonatomic, retain) NSString * symbol;
@property (nonatomic, retain) NSSet *expressions;
@property (nonatomic, retain) AMDMathValue *mathValue;
@end

@interface AMDVariableDef (CoreDataGeneratedAccessors)

- (void)addExpressionsObject:(AMDExpression *)value;
- (void)removeExpressionsObject:(AMDExpression *)value;
- (void)addExpressions:(NSSet *)values;
- (void)removeExpressions:(NSSet *)values;

@end
