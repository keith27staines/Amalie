//
//  AMExpressionNodeView.m
//  Amalie
//
//  Created by Keith Staines on 06/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMExpressionNodeView.h"
#import "KSMExpression.h"
#import "AMOperatorView.h"
#import "AMGraphics.h"
#import "AMExpressionLayout.h"
#import "AMNameProviding.h"

#import "AMPreferences.h"
#import "AMContentViewDataSource.h"
#import "AMExpressionDisplayOptions.h"
#import "AMConstants.h"

@interface AMExpressionNodeView()
{
    __weak AMExpressionNodeView       * _leftNodeView;
    __weak AMExpressionNodeView       * _rightNodeView;
    __weak AMOperatorView             * _operatorView;
    KSMExpression                     * _expression;
    AMExpressionLayout                * _expressionLayout;
    NSUInteger                          _scriptingLevel;
    CGFloat                             _standardSpace;
    
    AMExpressionDisplayOptions        * _displayOptions;
    NSDictionary                      * _attributes;
    NSColor                           * _backColor;
    CGFloat                             _scaleFactor;
    NSString                          * _groupID;
    __weak id<AMContentViewDataSource>  _dataSource;
}

@property (weak, readonly) AMExpressionNodeView     * leftNodeView;
@property (weak, readonly) AMExpressionNodeView     * rightNodeView;
@property (weak, readonly) AMOperatorView           * operatorView;
@property (readwrite)      AMExpressionLayout       * expressionLayout;
@property (readonly)       AMBracketPlacementInfo     bracketPlacementInfo;
@property (readonly)       id<AMNameProviding>        nameProvider;
@property (readwrite)      NSColor                  * backColor;

@end

@implementation AMExpressionNodeView

-(BOOL)autoresizesSubviews
{
    return NO;
}

-(id)initWithFrame:(NSRect)frame groupID:(NSString *)groupID
{
    return [self initWithFrame:frame
                       groupID:groupID
                    expression:nil
                scriptingLevel:0
                      delegate:nil
                displayOptions:nil
                   scaleFactor:1];
}

-(NSSize)intrinsicContentSize
{
    NSSize s = NSMakeSize(self.expressionLayout.boundingAMRect.width,
                          self.expressionLayout.boundingAMRect.height);
    return s;
}

- (id)initWithFrame:(NSRect)frame
            groupID:(NSString *)groupID
        expression:(KSMExpression *)expression
     scriptingLevel:(NSUInteger)scriptingLevel
           delegate:(id<AMExpressionNodeViewDelegate>)delegate
     displayOptions:(AMExpressionDisplayOptions *)displayOptions
        scaleFactor:(CGFloat)scaleFactor
{
    self = [super initWithFrame:frame];
    if (self) {
        [self resetWithgroupID:groupID
                    expression:expression
                scriptingLevel:scriptingLevel
                      delegate:delegate
                displayOptions:displayOptions
                   scaleFactor:scaleFactor];
    }
    return self;
}

-(void)resetWithgroupID:(NSString *)groupID
             expression:(KSMExpression *)expression
         scriptingLevel:(NSUInteger)scriptingLevel
               delegate:(id<AMExpressionNodeViewDelegate>)delegate
         displayOptions:(AMExpressionDisplayOptions *)displayOptions
            scaleFactor:(CGFloat)scaleFactor
{
    _groupID = groupID;
    _scaleFactor = scaleFactor;
    _displayOptions = displayOptions;
    _delegate = delegate;
    _scriptingLevel = scriptingLevel;
    if (expression)
    {
        self.expression = expression;
    }
}

-(KSMExpression*)expression
{
    return _expression;
}

-(void)prepareForExpressionSet
{
    [self removeAllSubviews];
    self.backColor = [NSColor whiteColor];
    self.attributedString = nil;
}

-(void)removeAllSubviews
{
    while (self.subviews.count > 0) {
        NSView * subView = self.subviews[0];
        [subView removeFromSuperview];
    }
}

-(void)assignAttributesForFontType:(AMFontType)type
{
    CGFloat scale = self.scaleFactor;
    NSAssert(scale >0, @"Bad scale factor");
    _attributes = @{NSFontAttributeName:[self.displayOptions fontOfAMType:type]};
    NSFont * font = _attributes[NSFontAttributeName];
    font = [NSFont fontWithName:font.fontName size:font.pointSize * self.scaleFactor];
    _attributes = @{NSFontAttributeName: font};
}

-(void)setExpression:(KSMExpression *)expression
{
    if (expression == _expression) return;
    [self prepareForExpressionSet];
    _expression = expression;
    if (expression)
    {
        [self constructAttributedString];
        if (!self.expression.isUnary) {
            [self addBinaryChildNodeViews];
        }
        [self setNeedsUpdateConstraints:YES];
        [self invalidateIntrinsicContentSize];
    }
}

-(void)constructAttributedString
{
    KSMExpression * expression = self.expression;
    NSAttributedString * aString = nil;
    switch (expression.expressionType) {
        case KSMExpressionTypeUnrecognized:
        {
            aString = [self attributedStringFor:@"?"];
            break;
        }
        case KSMExpressionTypeLiteral:
        {
            aString = [self attributedStringFor:expression.bareString];
            break;
        }
        case KSMExpressionTypeVariable:
        {
            aString = [self attributedStringFor:expression.bareString];
            break;
        }
        case KSMExpressionTypeBinary:
        {
            aString = [self dummyTextForMetrics];
            break;
        }
        case KSMExpressionTypeCompound:
        {
            aString = [self attributedStringFor:@"?"];
            break;
        }
    }
    self.attributedString = [self.nameProvider attributedStringByModifying:aString toSuperscriptLevel:self.scriptingLevel];
}


-(void)addBinaryChildNodeViews
{
    AMExpressionNodeView * leftNodeView;
    AMExpressionNodeView * rightNodeView;
    AMOperatorView       * operatorView;
    KSMExpression        * leftExpression = [self leftSubExpression];
    KSMExpression        * rightExpression = [self rightSubExpression];
    
    leftNodeView = [[AMExpressionNodeView alloc] initWithFrame:NSZeroRect
                                                       groupID:_groupID
                                                    expression:leftExpression
                                                scriptingLevel:_scriptingLevel
                                                      delegate:_delegate
                                                displayOptions:_displayOptions
                                                   scaleFactor:_scaleFactor];
    
    NSUInteger rightNodeScriptingLevel = _scriptingLevel;
    if ( [self operatorType] == KSMOperatorTypePower ) {
        rightNodeScriptingLevel++;
    } else {
        operatorView = [[AMOperatorView alloc] init];
        [operatorView setOperator:_expression.operator withFont:[self symbolFont]];
    }
    rightNodeView = [[AMExpressionNodeView alloc] initWithFrame:NSZeroRect
                                                        groupID:_groupID
                                                     expression:rightExpression
                                                 scriptingLevel:rightNodeScriptingLevel
                                                       delegate:_delegate
                                                 displayOptions:_displayOptions
                                                    scaleFactor:_scaleFactor];
    [self addSubview:leftNodeView];
    [self addSubview:operatorView];
    [self addSubview:rightNodeView];
    [leftNodeView setNeedsUpdateConstraints:YES];
    [rightNodeView setNeedsUpdateConstraints:YES];
    [operatorView setNeedsUpdateConstraints:YES];
    _leftNodeView  = leftNodeView;
    _operatorView  = operatorView;
    _rightNodeView = rightNodeView;
}

-(NSAttributedString*)dummyTextForMetrics
{
    NSFont * font = [self.nameProvider fontForSymbolsAtScriptinglevel:self.scriptingLevel];
    return [[NSAttributedString alloc]initWithString:@"a" attributes:@{NSFontAttributeName: font, NSBaselineOffsetAttributeName: @0}];
}

-(id<AMNameProviding>)nameProvider
{
    return [self.delegate nameProvider];
}

-(NSAttributedString*)attributedStringFor:(NSString*)string
{
    NSAttributedString * aString = [self.nameProvider attributedStringForObjectWithName:string];
    if (!aString || aString.length == 0) {
        aString = [[NSAttributedString alloc] initWithString:@"?" attributes:nil];
    }
    aString = [self.nameProvider attributedStringByModifying:aString
                                  toSuperscriptLevel:self.scriptingLevel];
    return aString;
}

-(void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext * context = [NSGraphicsContext currentContext];
    [context saveGraphicsState];
    context.shouldAntialias = YES;
    if (self.expression.isUnary) {
        [[NSColor colorWithCalibratedRed:0 green:1 blue:0 alpha:1] set];
        NSRectFill(dirtyRect);
        [super drawRect:dirtyRect];
    } else {
        [[NSColor blueColor] set];
        NSRectFill(dirtyRect);
    }
    if (self.isBracketed) {
        NSAffineTransform * transform = [NSAffineTransform transform];
        AMBracketPlacementInfo info = [self bracketPlacementInfo];
        AMGraphics * graphics = [AMGraphics sharedGraphics];
        NSBezierPath * leftBracket = [graphics leftBracketWithHeight:info.height];
        NSBezierPath * rightBracket = [graphics rightBracketWithHeight:info.height];
        [rightBracket moveToPoint:NSMakePoint(self.tightBoundingBox.origin.x + self.tightBoundingBox.size.width, 0)];
        [[NSColor blackColor] set];
        [leftBracket fill];
        [transform translateXBy:self.tightBoundingBox.size.width - info.width yBy:0];
        [transform concat];
        [rightBracket fill];
    }
    [context restoreGraphicsState];
}

-(NSRect)tightBoundingBox
{
    NSRect boundingBox = [self textBoundingBox];
    if (self.isBracketed) {
        AMBracketPlacementInfo info = [self bracketPlacementInfo];
        boundingBox.size.width += 2 * info.width; // takes into account left & right
        boundingBox.origin.x -= info.width;
        boundingBox.size.height = info.minimumEnclosingHeight;
        boundingBox.origin.y = -info.ascender;
    }
    return boundingBox;
}
-(NSRect)textBoundingBox
{
    NSRect box = NSZeroRect;
    [self calculateLayout];
    if (self.expression.isUnary) {
        box = [super tightBoundingBox];
    } else {
        box = [self.expressionLayout innerBounds];
    }
    return box;
}
-(NSPoint)exponentOffsetFromBottomLeftForCharacterWithIndex:(NSUInteger)charIndex
{
    NSPoint p = [super exponentOffsetFromBottomLeftForCharacterWithIndex:charIndex];
    if (self.isBracketed) {
        p.x = self.tightBoundingBox.size.width;
    }
    return p;
}
-(NSPoint)exponentPositionForView:(AMExpressionNodeView*)view
{
    NSPoint exponentPos = NSZeroPoint;
    if (view.isBracketed || !view.expression.terminal) {
        exponentPos = NSMakePoint(view.tightBoundingBox.size.width, view.tightBoundingBox.size.height - view.xHeight/2.0);
    } else {
        // Not bracketed and terminal view...
        // right node is offset to the right and up from the origin...
        NSUInteger charToOwnExponent = [self.nameProvider indexOfCharacterPrecedingExponentPositionForString:view.attributedString];
        exponentPos = [self.leftNodeView exponentOffsetFromBottomLeftForCharacterWithIndex:charToOwnExponent];
    }
    return exponentPos;
}
-(void)calculateLayout
{
    if (self.expression.isUnary) {
        _expressionLayout = [self calculateUnaryLayout];
    } else {
        _expressionLayout = [self calculatedBinaryLayout];
    }
}
-(AMExpressionLayout*)calculateUnaryLayout
{
    return [AMExpressionLayout expressionLayoutWithLeftRect:[super tightBoundingBox]
                                             exponentOffset:NSZeroPoint
                                               operatorRect:NSZeroRect
                                               operatorType:self.operatorType
                                                  rightRect:NSZeroRect
                                                isBracketed:self.expression.isBracketed
                                                      space:self.standardSpace
                                                  ruleWidth:self.ruleWidth
                                                    xHeight:self.xHeight
                                                  capHeight:self.capHeight
                                            minusSignHeight:self.minusSignHeightAboveBaseline];
}
-(AMExpressionLayout*)calculatedBinaryLayout
{
    return [AMExpressionLayout expressionLayoutWithLeftRect:self.leftNodeView.tightBoundingBox
                                             exponentOffset:[self exponentPositionForView:_leftNodeView]
                                               operatorRect:self.operatorView.tightBoundingBox
                                               operatorType:self.operatorType
                                                  rightRect:self.rightNodeView.tightBoundingBox
                                                isBracketed:self.expression.isBracketed
                                                      space:self.standardSpace
                                                  ruleWidth:self.ruleWidth
                                                    xHeight:self.xHeight
                                                  capHeight:self.capHeight
                                            minusSignHeight:self.minusSignHeightAboveBaseline];
}
-(CGFloat)baselineOffsetFromBottom
{
    return [self.expressionLayout baselineOffsetFromBottom];
}
-(NSPoint)pixelIntegralPoint:(NSPoint)point
{
    point = [self convertPointToBase:point];
    point.x = floor(point.x);
    point.y = floor(point.y);
    return [self convertPointFromBase:point];
}

-(void)updateConstraints
{
    [super updateConstraints];
    
    if (self.expression.expressionType != KSMExpressionTypeBinary) return;
    
    [self calculateLayout];
    [self removeConstraints:self.constraints];
    switch (self.operatorType) {
        case KSMOperatorTypeAdd:
        {
            [self addConstraintsForHorizontalLayout];
            break;
        }
        case KSMOperatorTypeSubtract:
        {
            [self addConstraintsForHorizontalLayout];
            break;
        }
        case KSMOperatorTypeMultiply:
        {
            [self addConstraintsForHorizontalLayout];
            break;
        }
        case KSMOperatorTypePower:
        {
            [self addConstraintsForExponentialLayout];
            break;
        }
        case KSMOperatorTypeDivide:
        {
            [self addConstraintsForVerticalLayout];
            break;
        }
        case KSMOperatorTypeScalarMultiply:
        case KSMOperatorTypeVectorMultiply:
        case KSMOperatorTypeUnrecognized:
        {
            break;
        }
    }
    [super updateConstraints];
}

-(void)addHeightConstraint
{
    if (self.expression.isUnary) {
        [super addHeightConstraint];
    }
}

-(void)addWidthConstraint
{
    if (self.expression.isUnary) {
        [super addWidthConstraint];
    }
}

-(KSMExpression*)expressionForSubSymbol:(NSString*)symbol
{
    KSMExpression * expr;
    expr = [_dataSource view:self requiresExpressionForSymbol:symbol];
    
    NSAssert(expr, @"No expression known for symbol %@.",symbol);
    
    return expr;
}

-(KSMExpression*)leftSubExpression
{
    KSMExpression * expr;
    if (self.expression.expressionType == KSMExpressionTypeBinary) {
        NSString * symbol = self.expression.leftOperand;
        expr = [self expressionForSubSymbol:symbol];
        NSAssert(expr, @"Missing left operand expression for symbol %@.",symbol);
    }
    return expr;
}

-(KSMExpression*)rightSubExpression
{
    KSMExpression * expr;
    if (self.expression.expressionType == KSMExpressionTypeBinary) {
        NSString * symbol = self.expression.rightOperand;
        expr = [self expressionForSubSymbol:symbol];
        NSAssert(expr, @"Missing right operand expression for symbol %@.",symbol);
    }
    return expr;
}

-(NSFont*)baseFont
{
    return [self.nameProvider fontForSymbolsAtScriptinglevel:_scriptingLevel];
}
-(NSFont*)symbolFont
{
    return [self.nameProvider fontForSymbolsAtScriptinglevel:_scriptingLevel];
}

-(AMBracketPlacementInfo)bracketPlacementInfo
{
    return self.expressionLayout.bracketInfo;
}

-(KSMOperatorType)operatorType
{
    NSString * operatorString = self.expression.operator;
    
    if (!operatorString) {
        // Just a placeholder
        return KSMOperatorTypeAdd;
    }
    
    if ([operatorString isEqualToString:@"+"]) {
        return KSMOperatorTypeAdd;
    }
    
    if ([operatorString isEqualToString:@"-"]) {
        return KSMOperatorTypeSubtract;
    }
    
    if ([operatorString isEqualToString:@"*"]) {
        return KSMOperatorTypeMultiply;
    }
    
    if ([operatorString isEqualToString:@"/"]) {
        return KSMOperatorTypeDivide;
    }
    
    if ([operatorString isEqualToString:@"^"]) {
        return KSMOperatorTypePower;
    }
    
    NSAssert(NO, @"Unexpected operator type.");
    return KSMOperatorTypeAdd;
}
-(void)addConstraintsForHorizontalLayout
{
    AMExpressionLayout * map = self.expressionLayout;
    
    // Container width
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:map.boundingAMRect.width]];
    
    // Container height
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:map.boundingAMRect.height]];
    
    // Align left node's left edge...
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftNodeView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:map.hGapToLeftNode]];
    
    // Align left node's top
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftNodeView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:map.vGapToLeftNode]];
    
    // Operator view left (mapped from expressionLayout)...
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.operatorView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:map.hGapToOperator]];
    
    // Operator view top (mapped from expressionLayout)...
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.operatorView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:map.vGapToOperator]];
    
    // Right node view left (mapped from expressionLayout)...
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightNodeView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:map.hGapToRightNode]];
    
    // Right node view top (mapped from expressionLayout)...
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightNodeView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:map.vGapToRightNode]];
}
-(void)addConstraintsForVerticalLayout
{
    AMExpressionLayout * map = self.expressionLayout;
    
    // Container width
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:map.boundingAMRect.width]];
    
    // Container height
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:map.boundingAMRect.height]];
    
    // Numerator, denominator and div sign are all centered horizontally in the container
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftNodeView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.operatorView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightNodeView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0]];
    
    // Numerator's vertical position relative to the container is obtained from the map
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftNodeView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:0
                                                      constant:map.vGapToLeftNode]];
    
    // Denominator's vertical position relative to the container is obtained from the map
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightNodeView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:0
                                                      constant:map.vGapToRightNode]];
    
    // Operator's vertical position relative to the container is obtained from the map
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.operatorView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:0
                                                      constant:map.vGapToOperator]];
    
    // Operator's width is obtained directly from the map
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.operatorView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0
                                                      constant:map.operatorAMRect.width]];
}
-(void)addConstraintsForExponentialLayout
{
    AMExpressionLayout * map = self.expressionLayout;
    
    // Container width
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:map.boundingAMRect.width]];
    
    // Container height
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:map.boundingAMRect.height]];
    
    // Left node left
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftNodeView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:0
                                                      constant:map.hGapToLeftNode]];
    
    // Left node top
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftNodeView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:map.vGapToLeftNode]];
    // Right node left
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightNodeView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:0
                                                      constant:map.hGapToRightNode]];
    
    // Right node top
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightNodeView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:map.vGapToRightNode]];
}

@end
