//
//  InsertedObject.h
//  Amalie
//
//  Created by Keith Staines on 22/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InsertedObject : NSManagedObject

@property (nonatomic, retain) NSNumber * xPosition;
@property (nonatomic, retain) NSNumber * yPosition;
@property (nonatomic, retain) NSNumber * type;

@end
