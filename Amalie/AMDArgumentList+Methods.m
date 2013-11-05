//
//  AMDArgumentList+Methods.m
//  Amalie
//
//  Created by Keith Staines on 04/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMDArgumentList+Methods.h"

@implementation AMDArgumentList (Methods)

-(AMDArgument *)argumentAtIndex:(NSUInteger)index
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"index == %lu",index];
    return [[self.arguments filteredSetUsingPredicate:predicate] anyObject];
}

@end
