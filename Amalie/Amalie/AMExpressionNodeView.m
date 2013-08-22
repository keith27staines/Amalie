//
//  AMExpressionNodeView.m
//  Amalie
//
//  Created by Keith Staines on 06/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMExpressionNodeView.h"

#import "KSMExpression.h"
#import <CoreText/CoreText.h>
#import "AMExpressionDisplayOptions.h"
#import "AMQuotientBaselining.h"
#import "AMOperatorView.h"
#import "AMConstants.h"

CGFloat const kAM_MINWIDTH  = 20.0f;
CGFloat const kAM_MINHEIGHT = 20.0f;

static NSMutableDictionary * bracketBeziers;

typedef enum AMOrientation : NSUInteger {
    AMOrientationHorizontal = 0,
    AMOrientationVertical   = 1,
} AMOrientation;

@interface AMExpressionNodeView()
{
    __weak AMExpressionNodeView * _parentNode;
    __weak AMExpressionNodeView * _rootNode;
    __weak KSMExpression        * _expression;
    NSMutableArray              * _childNodes;
    AMExpressionDisplayOptions  * _displayOptions;
    NSSize                        _intrinsicContentSize;
    __weak AMOperatorView       * _operatorView;
    NSString                    * _stringToDisplay;
    NSDictionary                * _attributes;
    NSColor                     * _backColor;
    CGFloat                       _baselineOffsetFromBottom;
    CGFloat                       _baselineOffsetFromBottomUsingQuotientRules;
    __weak AMExpressionNodeView * _leftOperandNode;
    __weak AMExpressionNodeView * _rightOperandNode;
    BOOL                          _useQuotientBaselining;
}

@property (readonly) NSMutableArray * childNodes;

@end

@implementation AMExpressionNodeView

-(BOOL)translatesAutoresizingMaskIntoConstraints
{
    return YES;
}

-(BOOL)autoresizesSubviews
{
    return NO;
}

-(id)initWithFrame:(NSRect)frame groupID:(NSString *)groupID
{
    return [self initWithFrame:frame
                       groupID:groupID
                      rootNode:nil
                    parentNode:nil
                    expression:nil
                    datasource:nil
                displayOptions:nil];
}

- (id)initWithFrame:(NSRect)frame
            groupID:(NSString *)groupID
           rootNode:(AMExpressionNodeView *)rootNode
         parentNode:(AMExpressionNodeView *)parentNode
        expression:(KSMExpression *)expression
         datasource:(id<AMContentViewDataSource>)datasource
     displayOptions:(AMExpressionDisplayOptions *)displayOptions
{
    if (rootNode && !parentNode)
        [NSException raise:@"Inconsistent root and parent node." format:nil];
    
    self = [super initWithFrame:frame groupID:groupID];
    if (self) {
        self.datasource = datasource;
        if (expression)
        {
            self.expression = expression;
        }
        _parentNode = parentNode;
        if (rootNode) {
            _rootNode = rootNode;
        } else {
            if (parentNode) {
                _rootNode = parentNode.rootNode;
            } else
            {
                _rootNode   = self;
                _parentNode = nil;
            }
        }
        _childNodes = [NSMutableArray array];
        _displayOptions = displayOptions;
    }
    return self;
}

-(KSMExpression*)expression
{
    return _expression;
}

-(void)prepareForExpressionSet
{
    _backColor = [NSColor colorWithCalibratedRed:0.99 green:0.8 blue:0.8 alpha:1.0];
    _intrinsicContentSize = NSMakeSize(kAM_MINWIDTH, kAM_MINHEIGHT);

    NSArray * viewsToRemove = [[self subviews] copy];
    for (NSView * v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    [self.childNodes removeAllObjects];
    _leftOperandNode = nil;
    _rightOperandNode = nil;
    self.stringToDisplay = nil;
}

-(void)setExpression:(KSMExpression *)expression
{
    if (expression == _expression) return;
    
    [self prepareForExpressionSet];
    
    if (expression)
    {
        _expression = expression;
        switch (expression.expressionType) {
            case KSMExpressionTypeUnrecognized:
            {
                _attributes = @{NSFontAttributeName:[self.displayOptions fontOfAMType:AMFontTypeLiteral]};
                self.stringToDisplay = @"Could not interpret expression.";
                break;
            }
            case KSMExpressionTypeLiteral:
            {
                _attributes = @{NSFontAttributeName:[self.displayOptions fontOfAMType:AMFontTypeLiteral]};
                _backColor = [self.datasource backgroundColorForType:AMInsertableTypeConstant];

                self.stringToDisplay = expression.bareString;
                break;
            }
            case KSMExpressionTypeVariable:
            {
                _attributes = @{NSFontAttributeName:[self.displayOptions fontOfAMType:AMFontTypeAlgebra]};
                _backColor = [self.datasource backgroundColorForType:AMInsertableTypeVariable];
                self.stringToDisplay = expression.bareString;
                
                break;
            }
            case KSMExpressionTypeBinary:
            {
                _attributes = @{NSFontAttributeName:[self.displayOptions fontOfAMType:AMFontTypeLiteral]};
                [self addBinaryChildNodeViews];
                _backColor = [self.datasource backgroundColorForType:AMInsertableTypeExpression];
                break;
            }
            case KSMExpressionTypeCompound:
            {
                _backColor = [self.datasource backgroundColorForType:AMInsertableTypeExpression];
                break;
            }
        }
        [self am_layout];
        [self setNeedsDisplay:YES];
    }
}

-(void)setStringToDisplay:(NSString*)string
{
    _stringToDisplay = string;
    if (_stringToDisplay) {
        _intrinsicContentSize = [_stringToDisplay sizeWithAttributes:_attributes];
    } else {
        _intrinsicContentSize = NSMakeSize(0, 0);
    }
    _baselineOffsetFromBottom = 0.0f;
    _baselineOffsetFromBottomUsingQuotientRules = _intrinsicContentSize.height / 2.0f;
    [self setFrameSize:_intrinsicContentSize];
}

-(void)am_layout
{
    CGFloat padding = 3.0f;
    NSSize size;
    
    if (self.expression.expressionType == KSMExpressionTypeBinary) {
        
        [self alignViews:self.subviews withPadding:padding orientation:[self subViewStackingOrientation]];
        size = self.intrinsicContentSize;
        if (self.isBracketed) {
            // add room for bracket graphics
            NSBezierPath * leftBracket = [AMExpressionNodeView leftBracketWithHeight:size.height];
            NSSize bracketSize = [leftBracket bounds].size;
            _intrinsicContentSize = NSMakeSize(size.width + bracketSize.width * 2.0f + 2.0f, size.height);
            for (NSView * subView in self.subviews) {
                // shift all subviews over by width of one bracket
                [subView setFrameOrigin:NSMakePoint(subView.frame.origin.x +bracketSize.width + 1, subView.frame.origin.y)];
            }
        }
    }

    size = self.intrinsicContentSize;
    NSPoint origin = self.frame.origin;
    [self setFrame:NSMakeRect(origin.x, origin.y, size.width, size.height)];
}

-(BOOL)isBracketed
{
    return self.expression.isBracketed;
}

+(NSBezierPath*)leftBracketWithHeight:(NSUInteger)heightInPoints
{
    return [[self bracketBeziersWithHeight:heightInPoints][0] copy];
}

+(NSBezierPath*)rightBracketWithHeight:(NSUInteger)heightInPoints
{
    return [[self bracketBeziersWithHeight:heightInPoints][1] copy];
}


+(NSArray*)bracketBeziersWithHeight:(NSUInteger)heightInPoints
{
    NSString * key = [NSString stringWithFormat:@"%lu",(unsigned long)heightInPoints];
    NSMutableDictionary * bracketBeziersDictionary;
    bracketBeziersDictionary = [self bracketBeziersDictionary];
    NSArray * leftAndRightPair = bracketBeziersDictionary[key];
    if (!leftAndRightPair) {
        leftAndRightPair = [self generateBeziersForBracketsWithHeight:heightInPoints];
        bracketBeziersDictionary[key] = leftAndRightPair;
    }
    return leftAndRightPair;
}

+(NSArray*)generateBeziersForBracketsWithHeight:(NSUInteger)heightInPoints
{
    [[NSColor blackColor] set];
    heightInPoints = 0.9 * heightInPoints;

    NSBezierPath * left = [[NSBezierPath alloc] init];
    NSBezierPath * right = [[NSBezierPath alloc] init];

    [left setFlatness:0.1];
    [left setLineWidth:1];
    [right setFlatness:0.1];
    [right setLineWidth:1];
    
    NSPoint p = NSMakePoint(0, 0);
    NSPoint q = NSMakePoint(0, heightInPoints);
    NSPoint c1, c2;
    
    c1 = NSMakePoint(p.x + 0.3 * (q.y - p.y),
                     p.y + 0.3 *(q.y - p.y));
    
    c2 = NSMakePoint(p.x + 0.3 * (q.y - p.y),
                     p.y + 0.7 *(q.y - p.y));
    
    
    [right moveToPoint:p];
    [right curveToPoint:q controlPoint1:c1 controlPoint2:c2];
    
    p.x = p.x + (q.y-p.y)/200.0f * 10.0f;
    q.x = q.x + (q.y-p.y)/200.0f * 10.0f;
    
    [right lineToPoint:q];
    
    
    CGFloat delta = (q.y-p.y)/200.0f * 0.02f;
    
    c2 = NSMakePoint(p.x + (0.3 + delta) * (q.y - p.y),
                     p.y + 0.3 * (q.y - p.y));
    
    c1 = NSMakePoint(p.x + (0.3 + delta) * (q.y - p.y),
                     p.y + 0.7 * (q.y - p.y));
    [right curveToPoint:p controlPoint1:c1 controlPoint2:c2];
    [right closePath];

    CGFloat dx = [right bounds].size.width;
    
    p = NSMakePoint(dx, 0);
    q = NSMakePoint(dx, heightInPoints);
    
    c1 = NSMakePoint(p.x - 0.3 * (q.y - p.y),
                     p.y + 0.3 *(q.y - p.y));
    
    c2 = NSMakePoint(p.x - 0.3 * (q.y - p.y),
                     p.y + 0.7 *(q.y - p.y));
    
    
    [left moveToPoint:p];
    [left curveToPoint:q controlPoint1:c1 controlPoint2:c2];
    
    p.x = p.x - (q.y-p.y)/200.0f * 10.0f;
    q.x = q.x - (q.y-p.y)/200.0f * 10.0f;
    
    [left lineToPoint:q];
    
    
    delta = (q.y-p.y)/200.0f * 0.02f;
    
    c2 = NSMakePoint(p.x - (0.3 + delta) * (q.y - p.y),
                     p.y + 0.3 * (q.y - p.y));
    
    c1 = NSMakePoint(p.x - (0.3 + delta) * (q.y - p.y),
                     p.y + 0.7 * (q.y - p.y));
    [left curveToPoint:p controlPoint1:c1 controlPoint2:c2];
    [left closePath];
    
    return @[left,right];
}

+(NSMutableDictionary*)bracketBeziersDictionary
{
    if (!bracketBeziers) {
        bracketBeziers = [NSMutableDictionary dictionary];
    }
    return bracketBeziers;
}


-(AMOrientation)subViewStackingOrientation
{
    if ( [self.expression.operator isEqualToString:@"/"] ) {
        
        // The divide operator is the only one that requires vertical stacking
        return AMOrientationVertical;
        
    }

    // The operators +,-,*,^ all require horizontal stacking of subviews
    return AMOrientationHorizontal;
}

-(NSMutableArray*)childNodes
{
    if ( !_childNodes) {
        _childNodes = [NSMutableArray array];
    }
    return _childNodes;
}

-(void)setDisplayOptions:(AMExpressionDisplayOptions *)displayOptions
{
    _displayOptions = displayOptions;
}

-(AMExpressionDisplayOptions*)displayOptions
{
    if (!_displayOptions) {
        _displayOptions = self.parentNode.displayOptions;
        if (!_displayOptions) {
            _displayOptions = [[AMExpressionDisplayOptions alloc] initWithFonts:nil];
        }
    }
    return _displayOptions;
}

-(void)addBinaryChildNodeViews
{
    if (self.expression.expressionType != KSMExpressionTypeBinary) return;
    
    AMExpressionNodeView * left;
    AMExpressionNodeView * right;
    NSRect initialRect = NSMakeRect(0, 0, 10, 10);
    left = [[AMExpressionNodeView alloc] initWithFrame:initialRect
                                               groupID:self.groupID
                                              rootNode:self.rootNode
                                            parentNode:self
                                            expression:[self leftSubExpression]
                                            datasource:self.datasource
                                        displayOptions:nil];
    
    right = [[AMExpressionNodeView alloc] initWithFrame:initialRect
                                                groupID:self.groupID
                                               rootNode:self.rootNode
                                             parentNode:self
                                             expression:[self rightSubExpression]
                                             datasource:self.datasource
                                         displayOptions:nil];
    
    [self.childNodes addObject:left];
    [self.childNodes addObject:right];
    [self addSubview:left];
    [self addOperatorViewWithAttributes:_attributes];
    [self addSubview:right];
    _leftOperandNode = left;
    _rightOperandNode = right;
}

-(void)drawRect:(NSRect)dirtyRect
{
    [[[self window] graphicsContext] saveGraphicsState];
    [[[self window] graphicsContext] setShouldAntialias:YES];
    
    // As we are opaque, we are obliged to fill dirtyRect with an opaque color
    [_backColor set];
    [NSBezierPath fillRect:dirtyRect];
    
    if (_stringToDisplay) {
        [_stringToDisplay drawAtPoint:NSMakePoint(0, 0) withAttributes:_attributes];
    } else {
        if (self.isBracketed) {
            [[NSColor blackColor] set];
            NSBezierPath * left = [AMExpressionNodeView leftBracketWithHeight:self.intrinsicContentSize.height];
            [left fill];
            NSBezierPath * right = [AMExpressionNodeView rightBracketWithHeight:self.intrinsicContentSize.height];
            NSAffineTransform * transform = [[NSAffineTransform alloc] init];
            CGFloat dx = self.intrinsicContentSize.width - [right bounds].size.width;
            [transform translateXBy: dx yBy: 0.0];
            [right transformUsingAffineTransform: transform];
            [right fill];
        }
    }

    [[[self window] graphicsContext] restoreGraphicsState];

}

-(NSSize)fittingSize
{
    return [super fittingSize];
}

-(void)alignViews:(NSArray*)views withPadding:(CGFloat)padding orientation:(AMOrientation)orientation
{
    for (NSView * view in views) {
        [view setFrameSize:[view intrinsicContentSize]];
    }
    switch (orientation) {
        case AMOrientationHorizontal:
        {
            [self alignViews:views horizontallyWithPadding:padding];
            break;
        }
        case AMOrientationVertical:
        {
            [self alignViews:views verticallyWithPadding:0];
            break;
        }
    }
}

-(void)alignViews:(NSArray*)views horizontallyWithPadding:(CGFloat)padding
{

    if ( [self requiresQuotientBaselining] ) {
        self.leftOperandNode.useQuotientBaselining   = YES;
        self.rightOperandNode.useQuotientBaselining  = YES;
        self.operatorView.useQuotientBaselining      = YES;
    }
    CGFloat width                    = 0.0f;
    CGFloat height                   = 0.0f;
    CGFloat maxExtentAboveBaseline   = [self greatestExtentAboveBaseLine:views];
    CGFloat baseline                 = [self greatestExtentBeneathBaseline:views];
    
    height = maxExtentAboveBaseline + baseline;

    for (NSView * aView in views) {
        CGFloat yOffset = baseline - aView.baselineOffsetFromBottom;
        [aView setFrameOrigin:NSMakePoint(width, yOffset)];
        width += aView.frame.size.width + padding;
    }
    width -= padding;
    _intrinsicContentSize = NSMakeSize(width, height);
    _baselineOffsetFromBottom = baseline;
    _baselineOffsetFromBottomUsingQuotientRules = baseline;
    
}

-(void)alignViews:(NSArray*)views verticallyWithPadding:(CGFloat)padding
{
    CGFloat width               = 0.0f;
    CGFloat height              = 0.0f;
    width = [self widestViewInViews:views].frame.size.width;
    CGFloat totalHeight = 0.0f;
    for (NSView * view in views) {

        totalHeight += view.frame.size.height + padding;
    }
    totalHeight -= padding;
    height = totalHeight;
    
    for (NSView * view in views) {
        CGFloat xOffset = (width - view.frame.size.width) / 2.0f;
        height = height - view.frame.size.height;
        if (view == _operatorView) {
            [view setFrameOrigin:NSMakePoint(0, height)];
            [view setFrameSize:NSMakeSize(width, view.intrinsicContentSize.height)];
            [view setNeedsDisplay:YES];
        } else {
            [view setFrameOrigin:NSMakePoint(xOffset, height)];
        }
        
        height -= padding;
    }
    _intrinsicContentSize = NSMakeSize(width, totalHeight);
    AMOperatorView * baselineView = [self baselineDefiningDivideView];
    NSAssert(baselineView, @"baseline view was determined to be nil but is not nil.");
    
    _baselineOffsetFromBottom = [baselineView midPointInCoordinatesOfView:self].y;
    _baselineOffsetFromBottomUsingQuotientRules = _baselineOffsetFromBottom;
}

-(CGFloat)baselineOffsetFromBottom
{
    if (!self.requiresQuotientBaselining) {
        return 0.0f;
    }
    
    AMOperatorView * baselineView = [self baselineDefiningDivideView];
    if (!baselineView) {
        return self.fittingSize.height / 2.0;
    }
    
    return [baselineView midPointInCoordinatesOfView:self].y;
}

-(CGFloat)greatestExtentBeneathBaseline:(NSArray*)views
{
    CGFloat max     = 0.0f;
    CGFloat current = 0.0f;
    for (NSView * view in views) {
        current = [view baselineOffsetFromBottom];
        if (current > max) {
            max = current;
        }
    }
    return max;
}

-(CGFloat)greatestExtentAboveBaseLine:(NSArray*)views
{
    CGFloat max     = 0.0f;
    CGFloat current = 0.0f;
    for (NSView * view in views) {
        if (view == self.operatorView) {
            current = [(AMOperatorView*)view extentAboveOwnBaseline];
        } else {
            current = [(AMExpressionNodeView*)view extentAboveOwnBaseline];
        }
        if (current > max) {
            max = current;
        }
    }
    return max;
}

-(NSView*)tallestViewInViews:(NSArray*)views
{
    CGFloat greatestHeight = 0;
    NSView * tall;
    for (NSView * v in views) {
        if (v.frame.size.height > greatestHeight) {
            greatestHeight = v.frame.size.height;
            tall = v;
        }
    }
    return tall;
}

-(NSView*)widestViewInViews:(NSArray*)views
{
    CGFloat greatestWidth = 0;
    NSView * wide;
    for (NSView * v in views) {
        if (v.frame.size.width > greatestWidth) {
            greatestWidth = v.frame.size.width;
            wide = v;
        }
    }
    return wide;
}


-(AMOperatorView*)addOperatorViewWithAttributes:(NSDictionary*)fontAttributes
{
    NSString * opStr = [self.expression operator];
    
    AMOperatorView * view;
    
    if ( [opStr isEqualToString:@"^"] ) return nil;

    view = [[AMOperatorView alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
    
    if (view) {
        view.operatorString = self.expression.operator;
        view.attributes = fontAttributes;
        [self addSubview:view];
        _operatorView = view;
        view.parentExpressionNode = self;
    }
    return _operatorView;
}

-(void)measureString:(NSString*)string
      withAttributes:(NSDictionary*)attributes
                draw:(BOOL)doDrawing
{
    _intrinsicContentSize = [string sizeWithAttributes:attributes];
    if (doDrawing)
        [string drawAtPoint:NSMakePoint(0, 0) withAttributes:attributes];

}

-(KSMExpression*)expressionForSubSymbol:(NSString*)symbol
{
    KSMExpression * expr;
    expr = [[self datasource] view:self requiresExpressionForSymbol:symbol];
    
    NSAssert(expr, @"No expression known for symbol %@.",symbol);
    
    return expr;
}


-(NSSize)intrinsicContentSize
{
    return _intrinsicContentSize;
}

-(AMExpressionNodeView*)leftOperandNode
{
    return _leftOperandNode;
}

-(AMExpressionNodeView*)rightOperandNode
{
    return _rightOperandNode;
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

#pragma mark - AMQuotientBaselining -

-(BOOL)requiresQuotientBaselining
{
    if (self.useQuotientBaselining == YES) return YES;
    
    switch (self.expression.expressionType) {
        case KSMExpressionTypeLiteral:
            return NO;
        case KSMExpressionTypeVariable:
            return NO;
        case KSMExpressionTypeBinary:
        {
            BOOL yn = NO;
            // Quick out if we are a division expression ourselves
            if ( [self.expression.operator isEqualToString:@"/"] )
                yn = YES;
            else {
                // otherwise need to check our operands
                AMExpressionNodeView * left  = [self leftOperandNode];
                AMExpressionNodeView * right = [self rightOperandNode];
                yn = ( [left requiresQuotientBaselining] || [right requiresQuotientBaselining] );
            }
            
            if (yn) {
                self.useQuotientBaselining = YES;
            }
            
            return yn;
        }
        case KSMExpressionTypeCompound:
        {
            return NO;
        }
        case KSMExpressionTypeUnrecognized:
        {
            return NO;
        }
    }
}

-(AMOperatorView*)baselineDefiningDivideView
{
    if (self.expression.expressionType != KSMExpressionTypeBinary) {
        return nil;
    }
    
    NSMutableArray * operatorViews = [NSMutableArray array];
    if ( [self.expression.operator isEqualToString:@"/"] ) {
        [operatorViews addObject:self.operatorView];
    }
    
    AMOperatorView * operatorView;
    operatorView = [self.leftOperandNode baselineDefiningDivideView];
    if (operatorView) {
        [operatorViews addObject:operatorView];
    }
    operatorView = [self.rightOperandNode baselineDefiningDivideView];
    if (operatorView) {
        [operatorViews addObject:operatorView];
    }
    
    if ([operatorViews count] == 0) {
        return nil;
    }
    
    // Find the widest divider, or an array of wide dividers, each of the same width
    CGFloat width = 0;
    NSMutableArray * wideViews = [NSMutableArray array];
    
    for (AMOperatorView * operatorView in operatorViews) {
        if (operatorView.frame.size.width > width) {
            width = operatorView.frame.size.width;
            [wideViews removeAllObjects];
            [wideViews addObject:operatorView];
        } else if (operatorView.intrinsicContentSize.width == width) {
            [wideViews addObject:operatorView];
        }
    }
    
    // If there is a single widest divider, we will use that for the baseline
    if ([wideViews count] == 1) {
        return wideViews[0];
    }
    
    // Of the widest views, we choose the one closest to the vertical middle of the this view
    CGFloat minDistanceFromMidPoint = MAXFLOAT;
    CGFloat midPointOfMe = self.intrinsicContentSize.height / 2.0;
    NSMutableArray * closeToMiddleViews = [NSMutableArray array];
    
    for (AMOperatorView * wideView in wideViews) {
        // Find the mid point of this wide view (in the vertical direction)
        NSPoint midPointOfWideView = [wideView midPointInCoordinatesOfView:self];
        
        CGFloat distanceFromMidPoint = fabs(midPointOfMe - midPointOfWideView.y);
        if (distanceFromMidPoint < minDistanceFromMidPoint) {
            [closeToMiddleViews removeAllObjects];
            [closeToMiddleViews addObject:wideView];
            minDistanceFromMidPoint = distanceFromMidPoint;
        } else if (distanceFromMidPoint == minDistanceFromMidPoint) {
            [closeToMiddleViews addObject:wideView];
        }
    }
    // The arrary might hold more than one "best" view. If so, we arbitrarily choose the first, since this covers the case where there is only one best view.
    return closeToMiddleViews[0];
}

-(BOOL)useQuotientBaselining
{
    return _useQuotientBaselining;
}

-(void)setUseQuotientBaselining:(BOOL)useQuotientBaselining
{
    _useQuotientBaselining = useQuotientBaselining;
}

-(CGFloat)verticalMidPoint
{
    return self.frame.origin.y + self.frame.size.height / 2.0f;
}

-(CGFloat)extentAboveOwnBaseline
{
    return self.intrinsicContentSize.height - self.baselineOffsetFromBottom;
}

@end
