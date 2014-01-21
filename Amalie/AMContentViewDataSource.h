//
//  AMContentViewDataSource.h
//  Amalie
//
//  Created by Keith Staines on 05/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMContentView, KSMExpression;

#import <Foundation/Foundation.h>
#import "AMConstants.h"
#import "AMNameProviding.h"

@protocol AMContentViewDataSource <NSObject>

-(KSMExpression*)view:(NSView*)view requiresExpressionForString:(NSString*)string atIndex:(NSUInteger)index;

-(KSMExpression*)view:(NSView*)view wantsExpressionAtIndex:(NSUInteger)index;

-(KSMExpression*)view:(NSView *)view requiresExpressionForSymbol:(NSString *)symbol;

-(NSAttributedString*)viewWantsAttributedName:(AMContentView*)view;

-(NSColor*)backgroundColorForType:(AMInsertableType)type;

-(void)populateView:(AMContentView*)view;

-(id<AMNameProviding>)viewRequiresNameProvider:(AMContentView*)view;

@end
