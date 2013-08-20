//
//  AMEquationContentView.h
//  Amalie
//
//  Created by Keith Staines on 03/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMExpressionNodeView;
@class AMNameView;

#import "AMContentView.h"

@interface AMEquationContentView : AMContentView
@property (weak) IBOutlet AMNameView *nameView;
@property (weak) IBOutlet AMExpressionNodeView *expressionView;
@property (weak) IBOutlet NSTextField *expressionStringView;


@end
