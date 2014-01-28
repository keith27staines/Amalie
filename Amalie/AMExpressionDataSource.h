//
//  AMExpressionDataSource.h
//  Amalie
//
//  Created by Keith Staines on 28/01/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class KSMExpression;

#import <Foundation/Foundation.h>

@protocol AMExpressionDataSource <NSObject>

-(KSMExpression*)expressionForSymbol:(NSString*)symbol;

@end
