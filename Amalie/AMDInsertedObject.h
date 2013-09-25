//
//  AMDInsertedObject.h
//  Amalie
//
//  Created by Keith Staines on 24/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AMDName;

@interface AMDInsertedObject : NSManagedObject

@property (nonatomic, retain) NSString * groupID;
@property (nonatomic, retain) NSNumber * insertType;
@property (nonatomic, retain) NSNumber * xPosition;
@property (nonatomic, retain) NSNumber * yPosition;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) AMDName *name;

@end
