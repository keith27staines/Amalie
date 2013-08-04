//
//  AMRefTreeNode.h
//  Amalie
//
//  Created by Keith Staines on 26/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMRefTree;
@class AMReferencedObjectHolder;

#import <Foundation/Foundation.h>

@interface AMRefTreeNode : NSObject

@property (readonly) AMRefTreeNode * parent;
@property (readonly) AMRefTree * refTree;
@property (readonly) AMReferencedObjectHolder * holder;

@property (readonly) NSString * uuid;
@property (readonly) AMRefTreeNode * parentNode;
@property (readonly) NSSet * children;

- (id)initWithTree:(AMRefTree*)tree parent:(AMRefTreeNode*)parent objectToReference:(id)object;


/*!
 Adds a child node, incrementing the reference count of the referenced object
 @Param childNode The node to add
 */
-(void)addChildNodeReferencingObject:(id)object;


/*!
 Deletes the node and all of its children, reducing the reference count of all referenced objects accordingly.
 */
-(void)removeFromTree;

@end
