//
//  AMFunctionRenamer.m
//  Amalie
//
//  Created by Keith Staines on 03/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMFunctionRenamer.h"
#import "AMDFunctionDef+Methods.h"
#import "AMDName+Methods.h"

@implementation AMFunctionRenamer


+(id)renamerForFunction:(AMDFunctionDef*)function nameProvider:(id<AMNameProviding>)nameProvider
{
    return [[AMFunctionRenamer alloc] initWithObject:function name:function.name valueType:function.returnType nameProvider:nameProvider];
}

@end
