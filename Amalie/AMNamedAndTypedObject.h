//
//  AMNamedAndTypedObject.h
//  Amalie
//
//  Created by Keith Staines on 04/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMDName;

#import <Foundation/Foundation.h>
#import "KSMMathValue.h"
#import "AMNamedObject.h"

@protocol AMNamedAndTypedObject <NSObject, NSCopying>

@property id<AMNamedObject> name;
@property NSNumber * valueType;

@end
