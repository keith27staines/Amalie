//
//  AMExpressionNodeController.h
//  Amalie
//
//  Created by Keith Staines on 15/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//
@class AMExpressionNodeView,KSMWorksheet;
#import <Foundation/Foundation.h>
#import "AMConstants.h"
#import "AMNameProviderDelegate.h"


@interface AMExpressionNodeController : NSObject

@property IBOutlet AMExpressionNodeView * expressionNode;
@property (weak) IBOutlet id<AMNameProviderDelegate> nameProviderDelegate;
@property (readonly) KSMWorksheet * worksheet;
@end
