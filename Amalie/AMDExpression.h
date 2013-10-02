//
//  AMDExpression.h
//  Amalie
//
//  Created by Keith Staines on 01/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AMDIndexedExpression;

@interface AMDExpression : NSManagedObject

@property (nonatomic, retain) NSString * originalString;
@property (nonatomic, retain) NSString * symbol;
@property (nonatomic, retain) AMDIndexedExpression *expressionIndices;

@end
