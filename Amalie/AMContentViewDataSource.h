//
//  AMContentViewDataSource.h
//  Amalie
//
//  Created by Keith Staines on 05/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMContentView, KSMExpression;

#import <Foundation/Foundation.h>

@protocol AMContentViewDataSource <NSObject>

-(KSMExpression*)view:(AMContentView*)view requiresExpressionForString:(NSString*)string atIndex:(NSUInteger)index;

-(KSMExpression*)view:(AMContentView*)view wantsExpressionAtIndex:(NSUInteger)index;

-(NSAttributedString*)viewWantsAttributedName:(AMContentView*)view;


@end
