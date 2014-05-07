//
//  AMExpressionNodeControllerDelegate.h
//  Amalie
//
//  Created by Keith Staines on 07/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMExpressionNodeController, KSMMathSheet;

#import <Foundation/Foundation.h>
#import "AMNameProviding.h"

@protocol AMExpressionNodeControllerDelegate <NSObject>
@required
-(NSString*)expressionNodeControllerRequiresExpressionString:(AMExpressionNodeController*)controller;

@optional
-(id<AMNameProviding>)expressionNodeControllerWantsNameProvider:(AMExpressionNodeController*)controller;

-(KSMMathSheet*)expressionNodeControllerWantsMathsSheet:(AMExpressionNodeController*)controller;

-(void)expressionNodeControllerDidChangeString:(AMExpressionNodeController*)controller;


@end
