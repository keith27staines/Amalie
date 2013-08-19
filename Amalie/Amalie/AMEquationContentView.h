//
//  AMEquationContentView.h
//  Amalie
//
//  Created by Keith Staines on 03/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMExpressionNodeView;

#import "AMContentView.h"

@interface AMEquationContentView : AMContentView
@property (weak) IBOutlet NSTextField *nameView;
@property (weak) IBOutlet AMExpressionNodeView *expressionView;
@property (weak) IBOutlet NSTextField *expressionStringView;
@property (weak) IBOutlet NSTextField *equalsSignView;

@end
