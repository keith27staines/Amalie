//
//  AMDInsertedObject+Methods.h
//  Amalie
//
//  Created by Keith Staines on 07/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMInsertableView;
@class AMDExpression;

#import "AMDInsertedObject.h"
#import "AMNameProviding.h"

@interface AMDInsertedObject (Methods)

+(AMDInsertedObject*)amdInsertedObjectForInsertedView:(AMInsertableView*)view withNameProvider:(id<AMNameProviding>)nameProvider;
+(AMDInsertedObject*)fetchInsertedObjectWithGroupID:(NSString * )groupID;
+(NSArray*)fetchInsertedObjectsInDisplayOrder;


-(AMDExpression*)expressionAtIndex:(NSUInteger)index;

@end
