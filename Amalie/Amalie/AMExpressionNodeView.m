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
#import "AMOperatorView.h"

CGFloat const kAM_MINWIDTH  = 20.0f;
CGFloat const kAM_MINHEIGHT = 20.0f;


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
    NSSize _instrinsicSize;
    __weak AMOperatorView       * _operatorView;
    NSString                    * _stringToDisplay;
    NSDictionary                * _attributes;
    NSColor                     * _backColor;
}

@property (readonly) NSMutableArray * childNodes;

@end

@implementation AMExpressionNodeView

-(id)initWithFrame:(NSRect)frame groupID:(NSString *)groupID
{
    return [self initWithFrame:frame
                       groupID:groupID
                      rootNode:nil
                    parentNode:nil
                    expression:nil
                displayOptions:nil];
}

- (id)initWithFrame:(NSRect)frame
            groupID:(NSString *)groupID
           rootNode:(AMExpressionNodeView *)rootNode
         parentNode:(AMExpressionNodeView *)parentNode
        expression:(KSMExpression *)expression
    displayOptions:(AMExpressionDisplayOptions *)displayOptions
{
    if (rootNode && !parentNode)
        [NSException raise:@"Inconsistent root and parent node." format:nil];
    
    self = [super initWithFrame:frame groupID:groupID];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self setAutoresizesSubviews:NO];
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

-(void)setExpression:(KSMExpression *)expression
{
    _instrinsicSize = NSMakeSize(kAM_MINWIDTH, kAM_MINHEIGHT);
    if (expression == _expression) return;

    if (expression)
    {
        NSArray * viewsToRemove = [[self subviews] copy];
        for (NSView * v in viewsToRemove) {
            [v removeFromSuperview];
        }
        
        [self.childNodes removeAllObjects];
        _expression = expression;
        self.stringToDisplay = nil;
        _backColor = [NSColor colorWithCalibratedRed:0.99 green:0.8 blue:0.8 alpha:1.0];
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
                self.stringToDisplay = expression.bareString;
                break;
            }
            case KSMExpressionTypeVariable:
            {
                _attributes = @{NSFontAttributeName:[self.displayOptions fontOfAMType:AMFontTypeAlgebra]};
                self.stringToDisplay = expression.bareString;
                break;
            }
            case KSMExpressionTypeBinary:
            {
                [self addBinaryChildNodeViews];
                _backColor = [NSColor colorWithCalibratedRed:0.8 green:0.8 blue:0.99 alpha:1.0];
                [self am_layout];
                break;
            }
            case KSMExpressionTypeCompound:
            {
                break;
            }
        }
    }
}

-(void)setStringToDisplay:(NSString*)string
{
    _stringToDisplay = string;
    if (_stringToDisplay) {
        _instrinsicSize = [_stringToDisplay sizeWithAttributes:_attributes];
    } else {
        _instrinsicSize = NSMakeSize(0, 0);
    }
    [self setFrameSize:_instrinsicSize];
}

-(void)am_layout
{
    CGFloat padding = 3.0f;
    
    if (self.expression.expressionType == KSMExpressionTypeBinary) {
        
        [self alignViews:self.subviews withPadding:padding orientation:[self subViewStackingOrientation]];
    }
    NSPoint origin = self.frame.origin;
    NSSize size = self.intrinsicContentSize;
    [self setFrame:NSMakeRect(origin.x, origin.y, size.width, size.height)];
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
    
    KSMExpression           * expression = self.expression;
    AMExpressionNodeView    * leftChildNode;
    AMExpressionNodeView    * rightChildNode;
    KSMExpression           * leftChildExpression;
    KSMExpression           * rightChildExpression;
    
    leftChildExpression = [self expressionForSubSymbol:expression.leftOperand];
    rightChildExpression = [self expressionForSubSymbol:expression.rightOperand];
    
    leftChildNode = [[AMExpressionNodeView alloc] initWithFrame:NSZeroRect
                                                        groupID:self.groupID
                                                       rootNode:self.rootNode
                                                     parentNode:self
                                                     expression:leftChildExpression
                                                 displayOptions:nil];
    
    rightChildNode = [[AMExpressionNodeView alloc] initWithFrame:NSZeroRect
                                                         groupID:self.groupID
                                                        rootNode:self.rootNode
                                                      parentNode:self
                                                      expression:rightChildExpression
                                                  displayOptions:nil];
    [self.childNodes addObject:leftChildNode];
    [self.childNodes addObject:rightChildNode];
    [self addSubview:leftChildNode];
    [self addOperatorViewWithAttributes:_attributes];
    [self addSubview:rightChildNode];
    [self setNeedsDisplay:YES];
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
        return;
    } else {
        [self am_layout];
    }
    
    [[[self window] graphicsContext] restoreGraphicsState];

}


-(void)alignViews:(NSArray*)views withPadding:(CGFloat)padding orientation:(AMOrientation)orientation
{
    switch (orientation) {
        case AMOrientationHorizontal:
        {
            [self alignViews:views horizontallyWithPadding:padding];
            break;
        }
        case AMOrientationVertical:
        {
            [self alignViews:views verticallyWithPadding:padding];
            break;
        }
    }
}

-(NSSize)fittingSize
{
    return [super fittingSize];
}

-(void)alignViews:(NSArray*)views horizontallyWithPadding:(CGFloat)padding
{
    CGFloat width               = 0.0f;
    CGFloat height              = 0.0f;
    CGFloat maxExtentAboveBaseline   = [self greatestExtentAboveBaseLine:views];
    CGFloat baseline                 = [self greatestExtentBeneathBaseline:views];
    height = maxExtentAboveBaseline + baseline;

    for (NSView * view in views) {
        CGFloat yOffset = baseline - view.baselineOffsetFromBottom;
        [view setFrameOrigin:NSMakePoint(width, yOffset)];
        width += view.frame.size.width + padding;
    }
    width -= padding;
    _instrinsicSize = NSMakeSize(width, height);
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
    int i = 0;
    for (NSView * view in views) {
        i++;
        CGFloat xOffset = (width - view.frame.size.width) / 2.0f;
        height = height - view.frame.size.height;
        [view setFrameOrigin:NSMakePoint(xOffset, height)];
        if (i == 2) {
            [view setFrameSize:NSMakeSize(width, view.intrinsicContentSize.height)];
            [view setNeedsDisplay:YES];
        }
        height -= padding;
    }
    _instrinsicSize = NSMakeSize(width, totalHeight);
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
        current = [self extentAboveOwnBaselineOfView:view];
        if (current > max) {
            max = current;
        }
    }
    return max;
}

-(CGFloat)extentAboveOwnBaselineOfView:(NSView*)view
{
    return view.frame.size.height - view.baselineOffsetFromBottom;
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
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        view.operatorString = self.expression.operator;
        view.attributes = fontAttributes;
        [self addSubview:view];
        _operatorView = view;
    }
    return _operatorView;
}

-(void)measureString:(NSString*)string
      withAttributes:(NSDictionary*)attributes
                draw:(BOOL)doDrawing
{
    _instrinsicSize = [string sizeWithAttributes:attributes];
    if (doDrawing)
        [string drawAtPoint:NSMakePoint(0, 0) withAttributes:attributes];

}

-(KSMExpression*)expressionForSubSymbol:(NSString*)symbol
{
    NSDictionary * subExpressions = [self.expression subExpressions];
    return (KSMExpression*) subExpressions[symbol];
}


-(NSSize)intrinsicContentSize
{
    return _instrinsicSize;
}






@end
