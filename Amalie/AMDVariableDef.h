//
//  AMDVariableDef.h
//  Amalie
//
//  Created by Keith Staines on 01/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AMDInsertedObject.h"


@interface AMDVariableDef : AMDInsertedObject

@property (nonatomic, retain) NSNumber * isConstant;
@property (nonatomic, retain) id mathValue;
@property (nonatomic, retain) NSString * symbol;

@end
