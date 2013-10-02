//
//  AMDIntervalDef.h
//  Amalie
//
//  Created by Keith Staines on 01/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AMDInsertedObject.h"


@interface AMDIntervalDef : AMDInsertedObject

@property (nonatomic, retain) id endMathValue;
@property (nonatomic, retain) NSNumber * includeEnd;
@property (nonatomic, retain) NSNumber * includeStart;
@property (nonatomic, retain) id startMathValue;

@end
