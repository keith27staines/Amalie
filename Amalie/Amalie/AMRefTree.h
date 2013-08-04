//
//  AMRefTree.h
//  Amalie
//
//  Created by Keith Staines on 26/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMRefTree;
@class AMRefTreeNode;
@class AMReferencedObjectHolder;

#import <Foundation/Foundation.h>

@interface AMRefTree : NSObject

-(AMReferencedObjectHolder*)referenceHolderForobject:(id)object;

-(void)removeTopLevelNode:(AMRefTreeNode*)node;

-(AMRefTreeNode*)makeTopLevelNodeReferencingObject:(id)object;

-(void)referenceCountZeroedForReferenceHolder:(AMReferencedObjectHolder*)holder;

@end
