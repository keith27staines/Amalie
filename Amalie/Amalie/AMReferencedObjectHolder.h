//
//  AMReferencedObjectHolder.h
//  Amalie
//
//  Created by Keith Staines on 26/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//


#import <Foundation/Foundation.h>

@class AMRefTree;

@interface AMReferencedObjectHolder : NSObject

-(id)initWithTree:(AMRefTree*)tree referencedObject:(id)object;

@property AMRefTree * tree;
@property id referencedObject;

-(void)incrementReference;
-(void)decrementReference;

@end
