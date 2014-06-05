//
//  AMExpressionEditorViewController.h
//  Amalie
//
//  Created by Keith Staines on 06/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMExpressionNodeController, AMExpressionNodeView;

#import <Cocoa/Cocoa.h>
#import "AMKeyboardEditorViewController.h"
#import "AMExpressionNodeControllerDelegate.h"

@interface AMExpressionEditorViewController : AMKeyboardEditorViewController <NSTextFieldDelegate,AMExpressionNodeControllerDelegate>

@end
