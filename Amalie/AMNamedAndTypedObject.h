//
//  AMNamedAndTypedObject.h
//  Amalie
//
//  Created by Keith Staines on 04/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMDName;

#import <Foundation/Foundation.h>
#import "KSMConstants.h"

@protocol AMNamedAndTypedObject <NSObject>

@property (readonly) AMDName * name;
@property (readonly) KSMValueType valueType;

@end
