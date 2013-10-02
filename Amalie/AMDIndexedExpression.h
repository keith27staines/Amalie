//
//  AMDIndexedExpression.h
//  Amalie
//
//  Created by Keith Staines on 01/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AMDExpression, AMDInsertedObject;

@interface AMDIndexedExpression : NSManagedObject

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) AMDExpression *expression;
@property (nonatomic, retain) AMDInsertedObject *insertedObject;

@end
