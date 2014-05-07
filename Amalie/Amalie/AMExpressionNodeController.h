//
//  AMExpressionNodeController.h
//  Amalie
//
//  Created by Keith Staines on 15/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//
@class AMExpressionNodeView,KSMMathSheet;
#import <Foundation/Foundation.h>
#import "AMConstants.h"
#import "AMNameProviderDelegate.h"
#import "AMNameProviding.h"
#import "AMExpressionNodeControllerDelegate.h"

extern NSString * const kAMDemoExpressionMathStyle;

@interface AMExpressionNodeController : NSObject

@property IBOutlet AMExpressionNodeView * expressionNode;
@property (weak) id<AMExpressionNodeControllerDelegate> delegate;
-(void)reloadData;
@end
