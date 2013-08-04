//
//  AMReferencedObjectHolder.m
//  Amalie
//
//  Created by Keith Staines on 26/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//


#import "AMReferencedObjectHolder.h"
#import "AMRefTree.h"

@implementation AMReferencedObjectHolder
{
    AMRefTree * _tree;
    id _referencedObject;
    NSUInteger _amRefCount;
}


-(id)initWithTree:(AMRefTree*)tree referencedObject:(id)object
{
    self = [super init];
    if (self) {
        _tree = tree;
        _referencedObject = object;
    }
    return self;
}

-(void)incrementReference
{
    _amRefCount++;
}

-(void)decrementReference
{
    NSAssert(_amRefCount > 0, @"Reference count is already zero");
    if (_amRefCount == 0) {
        [self.tree referenceCountZeroedForReferenceHolder:self];
        _referencedObject = nil;
    }
}

@end
