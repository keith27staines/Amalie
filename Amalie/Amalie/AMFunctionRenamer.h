//
//  AMFunctionRenamer.h
//  Amalie
//
//  Created by Keith Staines on 03/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMDataRenamer.h"

@interface AMFunctionRenamer : AMDataRenamer

+(id)renamerForFunction:(AMDFunctionDef*)function nameProvider:(id<AMNameProviding>)nameProvider;

@end
