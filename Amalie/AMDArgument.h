//
//  AMDArgument.h
//  Amalie
//
//  Created by Keith Staines on 01/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AMDArgumentList, AMDFunctionDef, AMDName;

@interface AMDArgument : NSManagedObject

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) id mathValue;
@property (nonatomic, retain) AMDArgumentList *argumentList;
@property (nonatomic, retain) AMDName *name;
@property (nonatomic, retain) AMDFunctionDef *transformedByFunction;
@property (nonatomic, retain) NSNumber * mathType;
@end
