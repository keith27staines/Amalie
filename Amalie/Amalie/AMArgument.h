//
//  AMArgument.h
//  Amalie
//
//  Created by Keith Staines on 05/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMNamedAndTypedObject.h"
#import "AMDName.h"
#import "KSMMathValue.h"
#import "AMNamedObject.h"

@interface AMArgument : NSObject <NSCopying,AMNamedAndTypedObject>

+(AMArgument*)argumentFromDataArgument:(AMDArgument*)dataArgument;

@property id<AMNamedObject> name;
@property NSNumber * valueType;
@property NSNumber * index;

@end
