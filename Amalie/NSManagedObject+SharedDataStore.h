//
//  NSManagedObject+SharedDataStore.h
//  Amalie
//
//  Created by Keith Staines on 07/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (SharedDataStore)

+(NSManagedObjectContext*)moc;
-(NSManagedObjectContext*)moc;

@end
