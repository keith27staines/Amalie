//
//  AMInsertableObjectViewDelegate.h
//  Amalie
//
//  Created by Keith Staines on 16/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMInsertableObjectView;

#import <Foundation/Foundation.h>

@protocol AMInsertableObjectViewDelegate <NSObject>
-(void)addInsertableObject:(AMInsertableObjectView*)view atPosition:(NSPoint)topLeft;
-(void)removeInsertableObject:(AMInsertableObjectView*)object;
-(void)moveInsertableObject:(AMInsertableObjectView*)object toPosition:(NSPoint)newTopLeft;
-(void)draggingDidStart;
-(void)draggingDidEnd;
@end
