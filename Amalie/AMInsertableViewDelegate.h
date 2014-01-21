//
//  AMInsertableViewDelegate.h
//  Amalie
//
//  Created by Keith Staines on 22/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMInsertableView;
@class AMContentView;

#import "AMContentViewController.h"
#import <Foundation/Foundation.h>
#import "AMConstants.h"
#import "AMNameProviding.h"

@protocol AMInsertableViewDelegate <NSObject>

-(AMContentView*)insertableView:(AMInsertableView*)view
      requiresContentViewOfType:(AMInsertableType)type;

-(void)insertableViewWantsRemoval:(AMInsertableView*)view;

-(void)insertableViewReceivedClick:(AMInsertableView*)view;

-(id<AMNameProviding>)insertedObjectNameProvider;


@end
