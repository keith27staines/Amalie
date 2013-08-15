//
//  AMOperatorView.h
//  Amalie
//
//  Created by Keith Staines on 14/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMExpressionNodeView;

#import <Cocoa/Cocoa.h>

@interface AMOperatorView : NSView

@property (copy) NSString             * operatorString;
@property NSDictionary                * attributes;
@property (weak) AMExpressionNodeView * parentExpressionNode;
@property BOOL                          useQuotientAlignment;
@end
