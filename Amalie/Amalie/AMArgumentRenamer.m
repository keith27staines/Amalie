//
//  AMArgumentRenamer.m
//  Amalie
//
//  Created by Keith Staines on 04/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMArgumentRenamer.h"
#import "AMDArgument+Methods.h"

@implementation AMArgumentRenamer

+(id)renamerForArgument:(AMDArgument*)argument nameProvider:(id<AMNameProviding>)nameProvider
{
    return [[AMArgumentRenamer alloc] initWithObject:argument name:argument.name mathType:argument.mathType.integerValue nameProvider:nameProvider];
}
@end
