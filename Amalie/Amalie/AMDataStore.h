//
//  AMDataStore.h
//  Amalie
//
//  Created by Keith Staines on 25/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class NSManagedObjectContext;
@class AMDInsertedObject;
@class AMInsertableView;

#import <Foundation/Foundation.h>

@interface AMDataStore : NSObject

@property (weak, readwrite) NSManagedObjectContext * moc;

-(id)initWithManagedObjectContext:(NSManagedObjectContext*)moc;

-(AMDInsertedObject*)amdInsertedObjectForInsertedView:(AMInsertableView*)view;
-(AMDInsertedObject*)fetchInsertedObjectWithGroupID:(NSString * )groupID;
-(NSArray*)fetchInsertedObjectsInDisplayOrder;

@end
