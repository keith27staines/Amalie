//
//  AMRefTree.m
//  Amalie
//
//  Created by Keith Staines on 26/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMRefTree.h"
#import "AMRefTreeNode.h"
#import "AMReferencedObjectHolder.h"

@interface AMRefTree()
{
    NSMutableDictionary * _topLevelNodes;
    NSMutableDictionary * _referencedObjectHolders;
    NSMutableSet        * _referencedObjectSet;
}
@end

@implementation AMRefTree

- (id)init
{
    self = [super init];
    if (self) {
        _topLevelNodes = [NSMutableDictionary dictionary];
        _referencedObjectHolders = [NSMutableDictionary dictionary];
        _referencedObjectSet = [NSMutableSet set];
    }
    return self;
}

-(AMReferencedObjectHolder*)referenceHolderForobject:(id)object
{
    AMReferencedObjectHolder * holder;
    if ([_referencedObjectSet containsObject:object]) {
        for (holder in _referencedObjectHolders.allValues) {
            if ([holder referencedObject] == object) {
                break;
            }
        }
    } else {
        [_referencedObjectSet addObject:object];
        holder = [[AMReferencedObjectHolder alloc] initWithTree:self referencedObject:object];
    }
    return holder;
}

-(void)removeTopLevelNode:(AMRefTreeNode*)node
{
    [_topLevelNodes removeObjectForKey:node.uuid];
}

-(AMRefTreeNode*)makeTopLevelNodeReferencingObject:(id)object
{
//    AMRefTreeNode * node = _topLevelNodes[object.uuid];
//    
//    node = [[AMRefTreeNode alloc] initWithTree:self parent:Nil objectToReference:object];
    return nil;
}

-(void)referenceCountZeroedForReferenceHolder:(AMReferencedObjectHolder*)holder
{
//    [_referencedObjectSet removeObject:holder.referencedObject];
//    [_referencedObjectHolders removeObjectForKey:holder.uuid];
}
@end
