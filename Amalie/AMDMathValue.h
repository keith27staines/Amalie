//
//  AMDMathValue.h
//  Amalie
//
//  Created by Keith Staines on 24/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AMDArgument, AMDVariableDef;

@interface AMDMathValue : NSManagedObject

@property (nonatomic, retain) NSNumber * mathType;
@property (nonatomic, retain) id value;
@property (nonatomic, retain) AMDArgument *argument;
@property (nonatomic, retain) AMDVariableDef *variableDef;

@end
