//
//  AMExpressionContentView.h
//  Amalie
//
//  Created by Keith Staines on 05/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMExpressionNodeView;

#import <Cocoa/Cocoa.h>
#import "AMContentView.h"

@interface AMExpressionContentView : AMContentView

@property (weak) IBOutlet AMExpressionNodeView *expressionView;
@property (weak) IBOutlet NSTextField *expressionStringView;

@end
