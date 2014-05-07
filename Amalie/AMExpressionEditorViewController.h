//
//  AMExpressionEditorViewController.h
//  Amalie
//
//  Created by Keith Staines on 06/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMExpressionNodeController, AMExpressionNodeView;

#import <Cocoa/Cocoa.h>
#import "AMExpressionNodeControllerDelegate.h"

@interface AMExpressionEditorViewController : NSViewController <AMExpressionNodeControllerDelegate>

@property (readonly, copy) NSString * expressionString;

-(void)presentExpressionEditorWithExpressionString:(NSString*)expressionString nameProvider:(id<AMNameProviding>)nameProvider completionHandler:(void (^)(void))completionHandler;

@end
