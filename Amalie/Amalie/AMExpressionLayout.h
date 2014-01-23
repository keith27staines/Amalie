//
//  AMExpressionLayout.h
//  NodeLayout
//
//  Created by Keith Staines on 10/01/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class KSMExpression;

#import <Foundation/Foundation.h>
#import "KSMConstants.h"

typedef struct AMRect {
    CGFloat left;
    CGFloat top;
    CGFloat bottom;
    CGFloat right;
    CGFloat width;
    CGFloat height;
} AMRect;

typedef struct AMBracketPlacementInfo  {
    CGFloat height;
    CGFloat width;
    CGFloat ascender;
    CGFloat descender;
    CGFloat deltaAboveTextBB;
    CGFloat deltaBelowTextBB;
    CGFloat minimumEnclosingHeight;
} AMBracketPlacementInfo;

NSRect AMNSRectFromAMRect(AMRect amRect);

@interface AMExpressionLayout : NSObject

+(id)expressionLayoutWithLeftRect:(NSRect)leftRect
                   exponentOffset:(NSPoint)exponentOffset
                     operatorRect:(NSRect)operatorRect
                     operatorType:(KSMOperatorType)operatorType
                        rightRect:(NSRect)rightRect
                      isBracketed:(BOOL)isBracketed
                            space:(CGFloat)space
                        ruleWidth:(CGFloat)ruleWidth
                          xHeight:(CGFloat)xHeight
                        capHeight:(CGFloat)capHeight
                        descender:(CGFloat)descender
                  minusSignHeight:(CGFloat)minusSignHeight;


@property (readonly) NSRect innerBounds;
@property (readonly) NSRect bounds;
@property (readonly) AMRect boundingAMRect;
@property (readonly) AMRect innerAMRect;
@property (readonly) AMBracketPlacementInfo bracketInfo;
@property (readonly) AMRect leftAMRect;
@property (readonly) AMRect rightAMRect;
@property (readonly) AMRect operatorAMRect;
@property (readonly) AMRect leftBracketAMRect;
@property (readonly) AMRect rightBracketAMRect;
@property (readonly) KSMOperatorType operatorType;
@property (readonly) BOOL   isBracketed;
@property (readonly) CGFloat space;
@property (readonly) CGFloat ruleWidth;
@property (readonly) CGFloat xHeight;
@property (readonly) CGFloat capHeight;
@property (readonly) CGFloat descender;
@property (readonly) CGFloat minusSignHeight;
@property (readonly) CGFloat baselineOffsetFromBottom;
@property (readonly) CGFloat baselineOffsetFromTop;
@property (readonly) NSPoint exponentOffsetFromBottomLeft;

@property (readonly) CGFloat hGapToLeftNode;
@property (readonly) CGFloat hGapToOperator;
@property (readonly) CGFloat hGapToRightNode;
@property (readonly) CGFloat vGapToLeftNode;
@property (readonly) CGFloat vGapToOperator;
@property (readonly) CGFloat vGapToRightNode;

@end
