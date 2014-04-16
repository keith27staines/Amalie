//
//  AMExpressionNodeViewDatasource.h
//  Amalie
//
//  Created by Keith Staines on 16/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AMExpressionNodeViewDatasource <NSObject>

-(KSMExpression*)view:(NSView *)view requiresExpressionForSymbol:(NSString *)symbol;

@end
