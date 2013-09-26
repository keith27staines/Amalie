//
//  AMDArgument.h
//  Amalie
//
//  Created by Keith Staines on 26/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AMDArgumentList, AMDMathValue, AMDName;

@interface AMDArgument : NSManagedObject

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) AMDArgumentList *argumentList;
@property (nonatomic, retain) AMDMathValue *mathValue;
@property (nonatomic, retain) AMDName *name;

@end
