//
//  AMExpressionNodeViewDelegate.h
//  NodeLayout
//
//  Created by Keith Staines on 04/01/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMNameProviding.h"

@protocol AMExpressionNodeViewDelegate <NSObject>

-(id<AMNameProviding>)nameProvider;

@end
