//
//  AMDVariableDef.h
//  Amalie
//
//  Created by Keith Staines on 26/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AMDInsertedObject.h"

@class AMDMathValue;

@interface AMDVariableDef : AMDInsertedObject

@property (nonatomic, retain) NSNumber * isConstant;
@property (nonatomic, retain) NSString * symbol;
@property (nonatomic, retain) AMDMathValue *mathValue;

@end
