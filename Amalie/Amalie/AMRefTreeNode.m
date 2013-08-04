//
//  AMRefTreeNode.m
//  Amalie
//
//  Created by Keith Staines on 26/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMRefTreeNode.h"
#import "AMRefTree.h"
#import "AMReferencedObjectHolder.h"

@interface AMRefTreeNode()
{
    NSMutableSet * _children;
    AMRefTree * _tree;
    AMRefTreeNode * _parentNode;
    AMReferencedObjectHolder * _holder;
}

/*!
 Deletes the child node, decrementing the reference count of the referenced object
 @Param childNode The node to delete.
 */
-(void)removeChild:(AMRefTreeNode*)childNode;

@end

@implementation AMRefTreeNode

- (id)initWithTree:(AMRefTree*)tree parent:(AMRefTreeNode*)parent objectToReference:(id)object
{
    self = [super init];
    if (self) {
        _tree = tree;
        _parentNode = parent;
        _children = [NSMutableSet set];
        _holder = [_tree referenceHolderForobject:object];
        [_holder incrementReference];
    }
    return self;
}

-(void)addChildNodeReferencingObject:(id)object
{
    AMRefTreeNode * child = [[AMRefTreeNode alloc] initWithTree:_tree parent:self objectToReference:object];
    [_children addObject:child];
}

-(void)removeFromTree
{
    [_holder decrementReference];
    
    for (AMRefTreeNode * node in _children) {
        [node removeFromTree];
    }
    
    if (_parent) {
        // tell the parent to release us
        [_parent removeChild:self];
    } else {
        // top level node in tree
    }
}

-(void)removeChild:(AMRefTreeNode*)node
{
    [node removeFromTree];
    [_children removeObject:node];
}

@end
