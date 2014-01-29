//
//  AMOperatorView.h
//  Amalie
//
//  Created by Keith Staines on 14/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMExpressionNodeView;

#import <Cocoa/Cocoa.h>
#import "AMTextView.h"
#import "KSMConstants.h"

@interface AMOperatorView : AMTextView

@property (weak) AMExpressionNodeView * parentExpressionNode;
@property (readonly) KSMOperatorType operatorType;
@property BOOL isLogicalViewOnly;

-(void)setOperator:(NSString*)operatorString withFont:(NSFont*)font;
-(void)setOperator:(NSString*)operatorString withFontSize:(CGFloat)fontSize;

@end
