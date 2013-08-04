//
//  AMInsertableViewDataSource.h
//  Amalie
//
//  Created by Keith Staines on 23/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMInsertableView;
@class KSMExpression;

#import <Foundation/Foundation.h>
#import "AMContentViewController.h"
#import "AMConstants.h"

@protocol AMInsertableViewDataSource <NSObject>

-(NSAttributedString*)attributedNameForView:(NSView*)view;

-(KSMExpression*)view:(AMInsertableView*)view requiresExpressionForString:(NSString*)string atIndex:(NSUInteger)index;

-(KSMExpression*)view:(AMInsertableView*)view wantsExpressionAtIndex:(NSUInteger)index;

-(BOOL)view:(AMInsertableView*)view wantsNameChangedTo:(NSAttributedString*)attributedName error:(NSError**)error;

@end
