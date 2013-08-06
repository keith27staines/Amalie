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

-(BOOL)view:(AMInsertableView*)view wantsNameChangedTo:(NSAttributedString*)attributedName error:(NSError**)error;

@end
