//
//  AMDInsertedObject+Methods.h
//  Amalie
//
//  Created by Keith Staines on 07/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMInsertableView;

#import "AMDInsertedObject.h"

@interface AMDInsertedObject (Methods)

+(AMDInsertedObject*)amdInsertedObjectForInsertedView:(AMInsertableView*)view;
+(AMDInsertedObject*)fetchInsertedObjectWithGroupID:(NSString * )groupID;
+(NSArray*)fetchInsertedObjectsInDisplayOrder;

@end
