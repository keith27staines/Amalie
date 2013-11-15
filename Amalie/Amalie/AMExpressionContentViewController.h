//
//  AMExpressionContentViewController.h
//  Amalie
//
//  Created by Keith Staines on 21/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMExpressionNodeView;
@class AMExpressionContentView;

#import <Cocoa/Cocoa.h>
#import "AMContentViewController.h"


@interface AMExpressionContentViewController : AMContentViewController <NSTextFieldDelegate>


@property (weak) IBOutlet NSTextField *expressionStringView;
@property (weak) IBOutlet AMExpressionNodeView * expressionView;
@property (weak) IBOutlet AMExpressionContentView * contentView;

@end
