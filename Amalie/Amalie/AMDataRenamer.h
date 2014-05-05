//
//  AMDataRenamer.h
//  Amalie
//
//  Created by Keith Staines on 03/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMDName, AMDFunctionDef;

#import <Foundation/Foundation.h>
#import "AMNameProviding.h"

@interface AMDataRenamer : NSObject

+(id)renamerForObject:(id)dataObject nameProvider:(id<AMNameProviding>)nameProvider;

- (instancetype)initWithObject:(id)object name:(AMDName*)name valueType:(KSMValueType)valueType nameProvider:(id<AMNameProviding>)nameProvider;
-(void)updateNameString:(NSString*)nameString;
-(void)updateValueType:(KSMValueType)valueType;

@end
