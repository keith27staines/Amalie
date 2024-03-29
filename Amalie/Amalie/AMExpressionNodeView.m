//
//  AMExpressionNodeView.m
//  Amalie
//
//  Created by Keith Staines on 06/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMExpressionNodeView.h"
#import "KSMExpression.h"
#import "AMExpressionFormatContextNode.h"
#import "AMOperatorView.h"
#import "AMGraphics.h"
#import "AMExpressionLayout.h"
#import "AMNameProviding.h"

#import "AMUserPreferences.h"
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
    __weak id<AMExpressionNodeViewDataSource>  _dataSource;

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
                    dataSource:nil
                displayOptions:nil
                   scaleFactor:1
                   contextNode:nil];
}

-(NSSize)intrinsicContentSize
{
    NSSize s = NSMakeSize(self.expressionLayout.boundingAMRect.width,
                          self.expressionLayout.boundingAMRect.height);
    if (self.expression.isUnary) {
        s = [self roundSizeUp:s];
        return s;
    } else {
        s = [self roundSizeUp:s];
        return s;
    }
}

-(NSSize)roundSizeUp:(NSSize)size
{
    return NSMakeSize(ceil(size.width), ceil(size.height));
}

- (id)initWithFrame:(NSRect)frame
            groupID:(NSString *)groupID
        expression:(KSMExpression *)expression
     scriptingLevel:(NSUInteger)scriptingLevel
           delegate:(id<AMExpressionNodeViewDelegate>)delegate
         dataSource:(id<AMExpressionNodeViewDataSource>)dataSource
     displayOptions:(AMExpressionDisplayOptions *)displayOptions
        scaleFactor:(CGFloat)scaleFactor
            contextNode:(AMExpressionFormatContextNode*)contextNode
{
    self = [super initWithFrame:frame];
    if (self) {
        [self resetWithgroupID:groupID
                    expression:expression
                scriptingLevel:scriptingLevel
                      delegate:delegate
                 dataSource:dataSource
                displayOptions:displayOptions
                   scaleFactor:scaleFactor
                contextNode:contextNode];
    }
    return self;
}

-(void)resetWithgroupID:(NSString *)groupID
             expression:(KSMExpression *)expression
         scriptingLevel:(NSUInteger)scriptingLevel
               delegate:(id<AMExpressionNodeViewDelegate>)delegate
             dataSource:(id<AMExpressionNodeViewDataSource>)dataSource
         displayOptions:(AMExpressionDisplayOptions *)displayOptions
            scaleFactor:(CGFloat)scaleFactor
            contextNode:(AMExpressionFormatContextNode*)contextNode
{
    _groupID = groupID;
    _scaleFactor = scaleFactor;
    _displayOptions = displayOptions;
    _delegate = delegate;
    _dataSource = dataSource;
    _scriptingLevel = scriptingLevel;
    //NSAssert(contextNode, @"Context node is nill");
    _contextNode = contextNode;
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
    [self removeConstraints:self.constraints];
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

-(void)setExpression:(KSMExpression *)expression
{
    //if (expression == _expression) return;
    
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
        [self setNeedsDisplay:YES];
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
                                                    dataSource:_dataSource
                                                displayOptions:_displayOptions
                                                   scaleFactor:_scaleFactor
                                                contextNode:self.contextNode.leftChild];
    if (self.expression.hasAddedLogicalLeadingZero) {
        leftNodeView.isLogicalViewOnly = YES;
    }
    
    NSUInteger rightNodeScriptingLevel = _scriptingLevel;
    if ( [self operatorType] == KSMOperatorTypePower ) {
        rightNodeScriptingLevel++;
    } else {
        operatorView = [[AMOperatorView alloc] init];
        [operatorView setOperator:_expression.operator withFont:[self symbolFont]];
        if (!self.contextNode.requiresOperator) {
            operatorView.isLogicalViewOnly = YES;
        }
    }
    rightNodeView = [[AMExpressionNodeView alloc] initWithFrame:NSZeroRect
                                                        groupID:_groupID
                                                     expression:rightExpression
                                                 scriptingLevel:rightNodeScriptingLevel
                                                       delegate:_delegate
                                                     dataSource:_dataSource
                                                 displayOptions:_displayOptions
                                                    scaleFactor:_scaleFactor
                                                    contextNode:self.contextNode.rightChild];
    [leftNodeView  setTranslatesAutoresizingMaskIntoConstraints:NO];
    [rightNodeView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [operatorView  setTranslatesAutoresizingMaskIntoConstraints:NO];
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
    if (self.isLogicalViewOnly) {
        return;
    }
    NSGraphicsContext * context = [NSGraphicsContext currentContext];
    [context saveGraphicsState];
    context.shouldAntialias = YES;
    if (self.expression.isUnary) {
        [super drawRect:dirtyRect];
    }
    if (self.isBracketed) {
        [[NSColor blackColor] set];
        AMBracketPlacementInfo info = [self pixelIntegralBracketPlacementInfo];
        AMGraphics * graphics = [AMGraphics sharedGraphics];
        CGFloat bracketHeight = [self pixelIntegralYFloor:info.height-2];
        NSBezierPath * leftBracket = [graphics leftBracketWithHeight:bracketHeight];
        NSBezierPath * rightBracket = [graphics rightBracketWithHeight:bracketHeight];
        [[NSColor blackColor] set];
        [leftBracket fill];
        NSAffineTransform * transform = [NSAffineTransform transform];
        CGFloat rightBracketInset = rightBracket.bounds.size.width;
        rightBracketInset = [self pixelIntegralXCeil:rightBracketInset];
        [transform translateXBy:self.tightBoundingBox.size.width - rightBracketInset yBy:0];
        [transform concat];
        [rightBracket fill];
    }
    [context restoreGraphicsState];
}

-(NSRect)tightBoundingBox
{
    NSRect boundingBox = [self textBoundingBox];
    if (self.isBracketed) {
        boundingBox = [self backingAlignedRect:self.expressionLayout.bounds options:NSAlignAllEdgesOutward];
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
        box = [self backingAlignedRect:[self.expressionLayout innerBounds] options:NSAlignAllEdgesOutward];
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
    return [self pixelIntegralPointCeil:exponentPos];
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
                                                isBracketed:self.isBracketed
                                                      space:self.standardSpace
                                                  ruleWidth:self.ruleWidth
                                                    xHeight:self.xHeight
                                                  capHeight:self.capHeight
                                                  descender:self.maximumDescender
                                            minusSignHeight:self.minusSignHeightAboveBaseline];
}
-(AMExpressionLayout*)calculatedBinaryLayout
{
    NSRect leftNodeRect = self.leftNodeView.tightBoundingBox;
    if (self.expression.hasAddedLogicalLeadingZero) {
        leftNodeRect.size.width = 0;
    }
    NSRect operatorRect = self.operatorView.tightBoundingBox;
    if (!self.contextNode.requiresOperator) {
        operatorRect.size.width = 0;
    }
    return [AMExpressionLayout expressionLayoutWithLeftRect:leftNodeRect
                                             exponentOffset:[self exponentPositionForView:_leftNodeView]
                                               operatorRect:operatorRect
                                               operatorType:self.operatorType
                                                  rightRect:self.rightNodeView.tightBoundingBox
                                                isBracketed:self.isBracketed
                                                      space:self.standardSpace
                                                  ruleWidth:self.ruleWidth
                                                    xHeight:self.xHeight
                                                  capHeight:self.capHeight
                                                  descender:self.maximumDescender
                                            minusSignHeight:self.minusSignHeightAboveBaseline];
}
-(CGFloat)baselineOffsetFromBottom
{
    CGFloat baselineOffset = [self.expressionLayout baselineOffsetFromBottom];
    return [self pixelIntegralYFloor:baselineOffset];
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
    expr = [self.dataSource view:self requiresExpressionForSymbol:symbol];
    
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
-(BOOL)isBracketed
{
    if (self.contextNode) {
        return self.contextNode.requiresBrackets;
    }
    return self.expression.isBracketed;
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
                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
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
/*! Returns a slightly modified bracketInfo with all measurements pixel-integral */
-(AMBracketPlacementInfo)pixelIntegralBracketPlacementInfo
{
    AMBracketPlacementInfo info = self.bracketPlacementInfo;
    info.width = [self pixelIntegralXCeil:info.width];
    info.height = [self pixelIntegralYFloor:info.height];
    info.ascender = [self pixelIntegralYFloor:info.ascender];
    info.descender = [self pixelIntegralYFloor:info.descender];
    info.minimumEnclosingHeight = [self pixelIntegralYFloor:info.minimumEnclosingHeight];
    return info;
}

@end
