//
//  AMExpressionLayout.m
//  NodeLayout
//
//  Created by Keith Staines on 10/01/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMExpressionLayout.h"
#import "AMGraphics.h"

@interface AMExpressionLayout()
{
    AMRect _leftBracketAMRect;
    AMRect _leftAMRect;
    AMRect _operatorAMRect;
    AMRect _rightAMRect;
    AMRect _rightBracketAMRect;
    AMRect _innerAMRect;
    AMRect _boundingAMRect;
    AMBracketPlacementInfo _bracketInfo;
    BOOL   _isBracketed;
    KSMOperatorType _operatorType;
}
@property BOOL needsLayout;
@property (readwrite) CGFloat space;
@property (readwrite) CGFloat ruleWidth;
@property (readwrite) CGFloat xHeight;
@property (readwrite) CGFloat capHeight;
@property (readwrite) NSPoint exponentOffsetFromBottomLeft;
@property (readwrite) CGFloat minusSignHeight;
@property (readwrite) BOOL    isBracketed;
@property (readwrite) KSMOperatorType operatorType;
@end

@implementation AMExpressionLayout

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
                  minusSignHeight:(CGFloat)minusSignHeight
{
    AMExpressionLayout * layout = [[self alloc] initWithLayoutWithLeftRect:leftRect
                                                            exponentOffset:exponentOffset
                                                              operatorRect:operatorRect
                                                              operatorType:operatorType
                                                                 rightRect:rightRect
                                                               isBracketed:isBracketed
                                                                     space:space
                                                                 ruleWidth:ruleWidth
                                                                   xHeight:xHeight
                                                                 capHeight:capHeight
                                                           minusSignHeight:minusSignHeight];
    
    return layout;
}

- (id)initWithLayoutWithLeftRect:(NSRect)leftRect
                   exponentOffset:(NSPoint)exponentOffset
                    operatorRect:(NSRect)operatorRect
                    operatorType:(KSMOperatorType)operatorType
                       rightRect:(NSRect)rightRect
                     isBracketed:(BOOL)isBracketed
                           space:(CGFloat)space
                       ruleWidth:(CGFloat)ruleWidth
                         xHeight:(CGFloat)xHeight
                       capHeight:(CGFloat)capHeight
                 minusSignHeight:(CGFloat)minusSignHeight
{
    self = [super init];
    if (self) {
        self.leftAMRect      = AMRectFromNSRect(leftRect);
        self.exponentOffsetFromBottomLeft = exponentOffset;
        self.operatorAMRect  = AMRectFromNSRect(operatorRect);
        self.rightAMRect     = AMRectFromNSRect(rightRect);
        self.isBracketed     = isBracketed;
        self.space           = space;
        self.ruleWidth       = ruleWidth;
        self.capHeight       = capHeight;
        self.minusSignHeight = minusSignHeight;
        self.needsLayout     = YES;
        self.operatorType    = operatorType;
        [self layoutRectangles];
    }
    return self;
}

-(CGFloat)baselineOffsetFromBottom
{
    return AMbaselineOffsetFromBottomForAMRect(self.boundingAMRect);
}

-(NSRect)bounds
{
    return AMNSRectFromAMRect(self.boundingAMRect);
}

-(NSRect)innerBounds
{
    return AMNSRectFromAMRect(self.innerAMRect);
}

/* bounds is the bounding rectangle of the nodes andenclosing brackets or other decoration */
-(AMRect)boundingAMRect
{
    return _boundingAMRect;
}

/* innerBounds is the bounding rectangle of the nodes, exluding any enclosing brackets or other decoration */
-(AMRect)innerAMRect
{
    return _innerAMRect;
}

-(AMRect)leftBracketAMRect
{
    return _leftBracketAMRect;
}
-(void)setLeftBracketAMRect:(AMRect)leftBracketRect
{
    _leftBracketAMRect = leftBracketRect;
}
-(AMRect)leftAMRect
{
    return _leftAMRect;
}
-(void)setLeftAMRect:(AMRect)leftNodeRect
{
    _leftAMRect = leftNodeRect;
}
-(AMRect)operatorAMRect
{
    return _operatorAMRect;
}
-(void)setOperatorAMRect:(AMRect)operatorRect
{
    _operatorAMRect = operatorRect;
}
-(AMRect)rightAMRect
{
    return _rightAMRect;
}
-(void)setRightAMRect:(AMRect)rightNodeRect
{
    _rightAMRect = rightNodeRect;
}
-(AMRect)rightBracketAMRect
{
    return _rightBracketAMRect;
}
-(void)setRightBracketAMRect:(AMRect)rightBracketRect
{
    _rightBracketAMRect = rightBracketRect;
}
-(AMBracketPlacementInfo)bracketPlacementInfo
{
    return _bracketInfo;
}

-(CGFloat)hGapToLeftNode
{
    return self.leftAMRect.left - self.boundingAMRect.left;
}
-(CGFloat)hGapToOperator
{
    return self.operatorAMRect.left - self.boundingAMRect.left;
}
-(CGFloat)hGapToRightNode
{
    return self.rightAMRect.left - self.boundingAMRect.left;
}
-(CGFloat)vGapToLeftNode
{
    return self.leftAMRect.top - self.boundingAMRect.top;
}
-(CGFloat)vGapToOperator
{
    return self.operatorAMRect.top - self.boundingAMRect.top;
}
-(CGFloat)vGapToRightNode
{
    return self.rightAMRect.top - self.boundingAMRect.top;
}

-(void)layoutRectangles
{
    [self calculateInnerBounds];
    [self calculateBounds];
}
-(void)calculateBounds
{
    _boundingAMRect = _innerAMRect;
    if (self.isBracketed) {
        [self calculateBracketPlacementInfo];
        AMBracketPlacementInfo info = self.bracketPlacementInfo;
        _boundingAMRect.width += 2 * info.width; // takes into account left & right
        _boundingAMRect.left -= info.width;
        _boundingAMRect.top = (_innerAMRect.top < -info.ascender)? _innerAMRect.top : -info.ascender;
        _boundingAMRect.bottom = (_innerAMRect.bottom > info.descender) ? _innerAMRect.bottom : info.descender ;
        _boundingAMRect.height = _boundingAMRect.bottom - _boundingAMRect.top;
    }
}

-(void)calculateBracketPlacementInfo
{
    CGFloat baselineOffsetFromBottom = AMbaselineOffsetFromBottomForAMRect(_innerAMRect);
    CGFloat midPointAboveBaseline = self.minusSignHeight;
    CGFloat maxAboveMidPoint = fabsf(_innerAMRect.top) - midPointAboveBaseline + self.ruleWidth/2.0;
    CGFloat maxBelowMidPoint = _innerAMRect.bottom + midPointAboveBaseline;
    CGFloat max = fmaxf(maxAboveMidPoint, maxBelowMidPoint);
    CGFloat capAboveMidpoint = self.capHeight - midPointAboveBaseline;
    max = (max > capAboveMidpoint) ? max : capAboveMidpoint;
    _bracketInfo = AMBracketPlacementInfoZeroed();
    _bracketInfo.height = 2 * max;
    NSBezierPath * leftBracket = [[AMGraphics sharedGraphics] leftBracketWithHeight:_bracketInfo.height];
    _bracketInfo.width = leftBracket.bounds.size.width;
    _bracketInfo.ascender = midPointAboveBaseline + max;  // relative to baseline
    _bracketInfo.descender = max-midPointAboveBaseline;   // relative to baseline
    _bracketInfo.deltaAboveTextBB = _bracketInfo.ascender - (_innerAMRect.height-baselineOffsetFromBottom);
    _bracketInfo.deltaBelowTextBB = _bracketInfo.descender - baselineOffsetFromBottom;
    _bracketInfo.minimumEnclosingHeight = (_bracketInfo.height > _innerAMRect.height) ? _bracketInfo.height : _innerAMRect.height;
}

-(void)calculateInnerBounds
{
    switch (self.operatorType) {
        case KSMOperatorTypeAdd:
        case KSMOperatorTypeMultiply:
        case KSMOperatorTypeSubtract:
        case KSMOperatorTypeScalarMultiply:
        case KSMOperatorTypeVectorMultiply:
        {
            [self space:&_operatorAMRect toRightOf:_leftAMRect];
            [self space:&_rightAMRect toRightOf:_operatorAMRect];
            break;
        }
        case KSMOperatorTypeDivide:
        {
            [self setDivisionRectWidthToWiderOfNumeratorAndDenominator];
            [self positionDivRectOnBaseline];
            [self positionNumeratorAboveDivideSign];
            [self positionDenominatorBelowDivideSign];
            break;
        }
        case KSMOperatorTypePower:
        {
            [self positionRightNodeAtExponentPoint];
            break;
        }
        case KSMOperatorTypeUnrecognized:
        {
            NSAssert(NO, @"unrecognised operator type.");
            break;
        }
    }

    NSRect inner = unionRect(_leftAMRect, _rightAMRect);
    inner = NSUnionRect(inner, unionRect(_leftAMRect, _operatorAMRect));
    _innerAMRect = AMRectFromNSRect(inner);
}

-(void)setDivisionRectWidthToWiderOfNumeratorAndDenominator
{
    CGFloat maxWidth = fmaxf(_leftAMRect.width,_rightAMRect.width) * 1.05;
    CGFloat deltaWidth = (maxWidth - _operatorAMRect.width);
    _operatorAMRect.left  -= deltaWidth/2.0;
    _operatorAMRect.right += deltaWidth/2.0;
    _operatorAMRect.width = _operatorAMRect.right - _operatorAMRect.left;
}

-(void)positionRightNodeAtExponentPoint
{
    _rightAMRect.left = _leftAMRect.left + self.exponentOffsetFromBottomLeft.x;
    _rightAMRect.right = _rightAMRect.left + _rightAMRect.width;
    _rightAMRect.top = -self.exponentOffsetFromBottomLeft.y + _rightAMRect.top;
    _rightAMRect.bottom = _rightAMRect.top + _rightAMRect.height;
}

-(void)positionDivRectOnBaseline
{
    _operatorAMRect.bottom = self.ruleWidth / 2.0;
    _operatorAMRect.top = _operatorAMRect.bottom - _operatorAMRect.height;
}

-(void)positionNumeratorAboveDivideSign
{
    AMRect divSign = _operatorAMRect;
    CGFloat bestGapNumeratorBaselineToDiv = self.xHeight;
    CGFloat minimumGap = 2*self.ruleWidth;
    CGFloat baseline = AMbaselineOffsetFromBottomForAMRect(_leftAMRect);
    if (bestGapNumeratorBaselineToDiv - baseline > minimumGap) {
        _leftAMRect.bottom = divSign.top - bestGapNumeratorBaselineToDiv
                                        + baseline;
    } else {
        _leftAMRect.bottom = divSign.top - minimumGap;
    }
    _leftAMRect.top = _leftAMRect.bottom - _leftAMRect.height;
    _leftAMRect.left = divSign.left + (divSign.width - _leftAMRect.width)/2.0;
    _leftAMRect.right = _leftAMRect.left + _leftAMRect.width;
}

-(void)positionDenominatorBelowDivideSign
{
    AMRect divSign = _operatorAMRect;
    CGFloat minimumGap = 2*self.ruleWidth;
    CGFloat bestGapDivToDenominatorBaseline = minimumGap + self.capHeight;
    CGFloat topToBaseline = AMbaselineOffsetFromTopForAMRect(_rightAMRect);
    if (bestGapDivToDenominatorBaseline - topToBaseline > minimumGap) {
        _rightAMRect.top = divSign.bottom + bestGapDivToDenominatorBaseline
                                          - topToBaseline;
    } else {
        _rightAMRect.top = divSign.bottom + minimumGap;
    }
    _rightAMRect.bottom = _rightAMRect.top + _rightAMRect.height;
    _rightAMRect.left = divSign.left + (divSign.width - _rightAMRect.width)/2.0;
    _rightAMRect.right = _rightAMRect.left + _rightAMRect.width;
}

static NSRect rectFromAMRect(AMRect aRect)
{
    return NSMakeRect(aRect.left, aRect.top, aRect.width, aRect.height);
}

static NSRect unionRect(AMRect a, AMRect b)
{
    NSRect c = rectFromAMRect(a);
    NSRect d = rectFromAMRect(b);
    return NSUnionRect(c, d);
}

-(void)space:(AMRect*)movableRight toRightOf:(AMRect)fixedLeft
{
    movableRight->left = fixedLeft.right + self.space;
    movableRight->right = movableRight->left + movableRight->width;
}

static AMRect AMRectFromNSRect(NSRect rect)
{
    AMRect amRect;
    amRect.left = rect.origin.x;
    amRect.top  = rect.origin.y;
    amRect.width = rect.size.width;
    amRect.height = rect.size.height;
    amRect.right = amRect.left + amRect.width;
    amRect.bottom = amRect.top + amRect.height;
    return amRect;
}

NSRect AMNSRectFromAMRect(AMRect amRect)
{
    return NSMakeRect(amRect.left, amRect.top, amRect.width, amRect.height);
}

static AMBracketPlacementInfo AMBracketPlacementInfoZeroed()
{
    AMBracketPlacementInfo info;
    info.width = 0;
    info.height = 0;
    info.ascender = 0;
    info.descender = 0;
    info.deltaAboveTextBB = 0;
    info.deltaBelowTextBB = 0;
    info.minimumEnclosingHeight = 0;
    return info;
}

static CGFloat AMbaselineOffsetFromBottomForAMRect(AMRect amRect)
{
    return amRect.bottom;
}

static CGFloat AMbaselineOffsetFromTopForAMRect(AMRect amRect)
{
    return amRect.height - AMbaselineOffsetFromBottomForAMRect(amRect);
}








@end
