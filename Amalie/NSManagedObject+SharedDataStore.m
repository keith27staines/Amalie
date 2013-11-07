//
//  NSManagedObject+SharedDataStore.m
//  Amalie
//
//  Created by Keith Staines on 07/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "NSManagedObject+SharedDataStore.h"

#import "AMDataStore.h"

@implementation NSManagedObject (SharedDataStore)

+(NSManagedObjectContext*)moc
{
    return [AMDataStore sharedDataStore].moc;
}

-(NSManagedObjectContext*)moc
{
    return [self.class moc];
}

@end
