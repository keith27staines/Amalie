//
//  AMInteriorExpressionView.h
//  Amalie
//
//  Created by Keith Staines on 06/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class KSMExpression;

#import "AMContentView.h"

@interface AMInteriorExpressionView : AMContentView

@property (weak) KSMExpression * expression;

@property NSFont * standardFont;

@end
