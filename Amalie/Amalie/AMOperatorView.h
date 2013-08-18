//
//  AMOperatorView.h
//  Amalie
//
//  Created by Keith Staines on 14/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMExpressionNodeView;

#import <Cocoa/Cocoa.h>
#import "AMQuotientBaselining.h"

@interface AMOperatorView : NSView <AMQuotientBaselining>

@property (copy) NSString             * operatorString;
@property NSDictionary                * attributes;
@property (weak) AMExpressionNodeView * parentExpressionNode;

-(NSPoint)midPointInCoordinatesOfView:(NSView*)view;

@end
