//
//  AMDFunctionDef.h
//  Amalie
//
//  Created by Keith Staines on 26/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AMDInsertedObject.h"

@class AMDArgumentList;

@interface AMDFunctionDef : AMDInsertedObject

@property (nonatomic, retain) NSNumber * returnType;
@property (nonatomic, retain) AMDArgumentList *argumentList;

@end
