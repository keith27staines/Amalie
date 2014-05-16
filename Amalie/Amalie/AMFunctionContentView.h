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
@class AMArgumentListViewController;
@class AMExpandingTextFieldView;

#import "AMContentView.h"

@interface AMFunctionContentView : AMContentView
/*!
 *  The view showing the name of the function
 */
@property AMTextView *nameView;

/*!
 *  The view showing the expression
 */
@property AMExpressionNodeView *expressionView;

/*!
 *  The view showing the ascii representation of the expression
 */
@property AMExpandingTextFieldView *expressionStringView;

/*!
 *  The view showing the function's argument list
 */
@property AMArgumentListView * argumentListView;

@property NSButton * expressionEditorButton;

@property NSButton * propertiesButton;

@property IBOutlet AMArgumentListViewController * argumentListViewController;

@end
