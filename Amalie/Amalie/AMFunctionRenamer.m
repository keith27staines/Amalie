//
//  AMFunctionRenamer.m
//  Amalie
//
//  Created by Keith Staines on 03/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMFunctionRenamer.h"
#import "AMDFunctionDef+Methods.h"

@implementation AMFunctionRenamer


+(id)renamerForFunction:(AMDFunctionDef*)function nameProvider:(id<AMNameProviding>)nameProvider
{
    return [[AMFunctionRenamer alloc] initWithName:function.name mathType:function.returnType.integerValue nameProvider:nameProvider];
}

@end