//
//  AMFunctionContentView.h
//  Amalie
//
//  Created by Keith Staines on 03/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMExpressionNodeView;
@class AMTextView;
@class AMArgumentListView;

#import "AMContentView.h"

@interface AMFunctionContentView : AMContentView
@property (weak) IBOutlet AMTextView *nameView;
@property (weak) IBOutlet AMExpressionNodeView *expressionView;
@property (weak) IBOutlet NSTextField *expressionStringView;
@property (weak) AMArgumentListView * argumentListView;
-(void)removeDynamicConstraints;
@end
