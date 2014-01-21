//
//  AMTextView.m
//  StylishName
//
//  Created by Keith Staines on 06/12/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AMTextView.h"
#import "AMTextMetric.h"

@interface AMTextView()
{
    NSColor                * _textBackgroundColor;
    BOOL                     _showBackground;
    BOOL                     _showTextBaseline;
    BOOL                     _showBoundingBoxes;
    BOOL                     _showSelectionBoxes;
    BOOL                     _showTightBoundingBox;
    NSPoint                  _baselineOrigin;
    NSMutableArray         * _glyphBoundingBoxes;
    NSMutableArray         * _glyphSelectionBoxes;
    NSRect                   _tightBoundingBox;
    NSRect                   _fullSelectionBox;
    NSPoint                  _textContainerOffsetFromBaselineOrigin;
    NSPoint                  _exponentOffsetFromBottomLeft;
    BOOL                     _autosizesVertically;
    BOOL                     _autosizesHorizontally;
    AMTextMetric           * _textMetric;
}

@property (weak, readonly) AMTextMetric * textMetric;
@property (readwrite) NSPoint exponentOffsetFromBottomLeft;

@end

@implementation AMTextView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _showBackground          = YES;
        _showBoundingBoxes       = NO;
        _showSelectionBoxes      = NO;
        _showTextBaseline        = YES;
        _showTextBaselineOrigin  = YES;
        _showTightBoundingBox    = NO;
    }
    return self;
}
-(BOOL)isFlipped
{
    return YES;
}
-(BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
    return YES;
}
-(void)mouseDown:(NSEvent *)theEvent
{
    NSLog(@"%@",self.attributedString.string);
}
-(AMTextMetric *)textMetric
{
    if (!_textMetric) {
        _textMetric = [[AMTextMetric alloc] init];
    }
    return _textMetric;
}
-(CGFloat)ruleWidth
{
    return self.textMetric.ruleWidth;
}
-(CGFloat)minusSignHeightAboveBaseline
{
    return self.textMetric.minusSignHeightAboveBaseline;
}
-(CGFloat)capHeight
{
    return self.textMetric.capHeight;
}
-(CGFloat)xHeight
{
    return self.textMetric.xHeight;
}
-(CGFloat)standardSpace
{
    return self.textMetric.standardSpace;
}
-(CGFloat)narrowSpace
{
    return self.textMetric.narrowSpace;
}
-(CGFloat)wideSpace
{
    return self.textMetric.wideSpace;
}
-(CGFloat)maximumAscender
{
    return self.textMetric.maximumAscender;
}
-(CGFloat)maximumDescender
{
    return self.textMetric.maximumDescender;
}
-(NSColor *)textBackgroundColor
{
    if (!_textBackgroundColor) {
        _textBackgroundColor = [NSColor colorWithCalibratedRed:0.5 green:8 blue:0.7 alpha:1];
    }
    return _textBackgroundColor;
}

-(void)setTextBackgroundColor:(NSColor *)color
{
    _textBackgroundColor = color;
}

-(NSAttributedString *)attributedString
{
    return self.textMetric.attributedString;
}

-(void)setAttributedString:(NSAttributedString *)attributedstring
{
    if (attributedstring) {
        self.textMetric.attributedString = attributedstring;
        [self analyseText];
    }
}

-(void)updateConstraints
{
    [super updateConstraints];
    if (self.attributedString.length > 0) {
        [self removeConstraints:self.constraints];
        [self addWidthConstraint];
        [self addHeightConstraint];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    NSGraphicsContext * context = [NSGraphicsContext currentContext];
    [context saveGraphicsState];
    //[self drawBackground];

    NSAffineTransform * t = [NSAffineTransform transform];
    [t translateXBy:-self.tightBoundingBox.origin.x yBy:-self.tightBoundingBox.origin.y];
    [t concat];

    [self drawTightBoundingBox];
    [self drawText];
    [self drawBaseline];
    [context restoreGraphicsState];
}

-(void)drawTightBoundingBox
{
    if (self.showTightBoundingBox) {
        [[NSColor blueColor] set];
        [NSBezierPath strokeRect:self.tightBoundingBox];
    }
}

-(void)drawBaseline
{
    if (!self.showTextBaseline) return;
    
    NSGraphicsContext * context = [NSGraphicsContext currentContext];
    [context saveGraphicsState];
    
    [[NSColor blueColor] set];
    NSBezierPath * bezier = [[NSBezierPath alloc] init];
    [bezier setLineWidth:1];
    CGFloat baselineHeight = self.bounds.origin.y + self.baselineOrigin.y;
    [bezier moveToPoint:NSMakePoint(self.tightBoundingBox.origin.x, baselineHeight)];
    [bezier lineToPoint:NSMakePoint(self.tightBoundingBox.origin.x+self.tightBoundingBox.size.width, baselineHeight)];
    [bezier stroke];
    
    [bezier moveToPoint:NSMakePoint(self.baselineOrigin.x,self.tightBoundingBox.origin.y)];
    [bezier lineToPoint:NSMakePoint(self.baselineOrigin.x,self.tightBoundingBox.origin.y + self.tightBoundingBox.size.height)];
    [bezier stroke];
    
    [context restoreGraphicsState];
}

-(void)drawBackground
{
    if (!self.showBackground) return;
    
    NSGraphicsContext * context = [NSGraphicsContext currentContext];
    [context saveGraphicsState];
	[self.textBackgroundColor set];
    [context restoreGraphicsState];
}

-(void)drawText
{
    NSRange glyphRange = self.textMetric.glyphRange;
    if (glyphRange.length == 0) {
        return;
    }
    
    NSGraphicsContext * context = [NSGraphicsContext currentContext];
    [context saveGraphicsState];
    
    if (self.showTextBaselineOrigin) {
        [[NSColor blueColor] set];
        NSRectFill(NSMakeRect(self.bounds.origin.x + self.baselineOrigin.x - 2, self.bounds.origin.y + self.baselineOrigin.y - 2, 4, 4));
    }

    // Actually draw the text
    [self.textMetric drawGlyphsForGlyphRange:glyphRange atPoint:_textContainerOffsetFromBaselineOrigin];
    
    // Draw bounding and selection boxes around each glyph
    for (NSUInteger glyphIndex = glyphRange.location; glyphIndex < NSMaxRange(glyphRange); glyphIndex++) {
        
        // Draw the bounding box of the glyph
        if (self.showBoundingBoxes) {
            [[NSColor redColor] set];
            NSValue * boundingBoxValue = _glyphBoundingBoxes[glyphIndex];
            [NSBezierPath strokeRect:[boundingBoxValue rectValue]];
        }

        // Draw the selection box of the glyph
        if (self.showSelectionBoxes) {
            NSValue * selectionBoxValue = _glyphSelectionBoxes[glyphIndex];
            [NSBezierPath strokeRect:[selectionBoxValue rectValue]];
        }
    }
    [context restoreGraphicsState];
}

-(void)analyseText
{
    _baselineOrigin      = NSZeroPoint;
    _glyphBoundingBoxes  = [NSMutableArray array];
    _glyphSelectionBoxes = [NSMutableArray array];
    _tightBoundingBox    = NSZeroRect;
    _fullSelectionBox    = NSZeroRect;
    NSRange glyphRange   = [self.textMetric glyphRange];
    
    for (NSUInteger glyphIndex = glyphRange.location; glyphIndex < NSMaxRange(glyphRange); glyphIndex++) {
        
        // We need the glyph's metrics...
        AMGlyphMetrics glyphMetrics = [self.textMetric metricsForGlyphAtIndex:glyphIndex];
        
        // Calculate the text container offset from the baseline origin (any glyph will do, but we will use the first...
        if (glyphIndex == 0) {
            _textContainerOffsetFromBaselineOrigin.x = self.baselineOrigin.x - glyphMetrics.location.x;
            _textContainerOffsetFromBaselineOrigin.y = self.baselineOrigin.y - glyphMetrics.location.y;
        }
        
        NSPoint locationInTextContainer = glyphMetrics.location;
        
        // and translate again by the amount the text container origin is offset from the baseline origin...
        NSPoint viewLocation = NSMakePoint(locationInTextContainer.x + _textContainerOffsetFromBaselineOrigin.x,
                                           locationInTextContainer.y + _textContainerOffsetFromBaselineOrigin.y);
        
        // Calculate the bounding box of the glyph
        glyphMetrics = [self translateBoundingBoxOriginInGlyphMetrics:glyphMetrics toViewPoint:viewLocation];
        
        // Calculate the selection box of the glyph
        glyphMetrics = [self translateSelectionBoxOriginInGlyphMetrics:glyphMetrics
                                                           toViewPoint:viewLocation
                                                    withBaselineOrigin:self.baselineOrigin];
        
        [_glyphBoundingBoxes addObject:[NSValue valueWithRect:glyphMetrics.boundingBox]];
        [_glyphSelectionBoxes addObject:[NSValue valueWithRect:glyphMetrics.selectionBox]];
        _tightBoundingBox = NSUnionRect(_tightBoundingBox, glyphMetrics.boundingBox);
        _fullSelectionBox = NSUnionRect(_fullSelectionBox, glyphMetrics.selectionBox);
    }
    [self transformRect:_tightBoundingBox fromContainerToViewpoint:self.baselineOrigin];
    [self transformRect:_fullSelectionBox fromContainerToViewpoint:self.baselineOrigin];
    [self invalidateIntrinsicContentSize];
    [self setNeedsUpdateConstraints:YES];
}

-(NSPoint)exponentOffsetFromBottomLeftForCharacterWithIndex:(NSUInteger)charIndex
{
    return [self.textMetric exponentOffsetFromBottomLeftForCharacterWithIndex:charIndex];
}

-(NSRect)tightBoundingBoxForCharactersInRange:(NSRange)charRange
{
    NSRect rangeBounds = [self.textMetric tightBoundingBoxForCharactersInRange:charRange];
    NSAssert(rangeBounds.size.width > 0, @"Invalid width");
    return [self transformRect:rangeBounds fromContainerToViewpoint:self.baselineOrigin];
}

-(void)addWidthConstraint
{
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:self
                         attribute:NSLayoutAttributeWidth
                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                         toItem:nil
                         attribute:NSLayoutAttributeWidth
                         multiplier:1
                         constant:self.tightBoundingBox.size.width]];
}
-(NSSize)intrinsicContentSize
{
    return self.tightBoundingBox.size;
}

-(void)addHeightConstraint
{
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:self
                         attribute:NSLayoutAttributeHeight
                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                         toItem:nil
                         attribute:NSLayoutAttributeNotAnAttribute
                         multiplier:1
                         constant:self.tightBoundingBox.size.height]];
}

-(BOOL)isOpaque
{
    return NO;
}

-(CGFloat)baselineOffsetFromBottom
{
    CGFloat offset = 0;
    if (self.useQuotientBaselining || self.requiresQuotientBaselining) {
        offset = 0;
    } else {
        offset = self.tightBoundingBox.size.height + self.tightBoundingBox.origin.y;
        offset = [self pixelIntegralPoint:NSMakePoint(0, offset)].y;
    }
    return offset;
}

-(NSPoint)pixelIntegralPoint:(NSPoint)point
{
    point = [self convertPointToBase:point];
    point.x = floor(point.x);
    point.y = floor(point.y);
    return [self convertPointFromBase:point];
}

-(NSRect)tightBoundingBox
{
    return _tightBoundingBox;
}

-(NSRect)transformRect:(NSRect)rect fromContainerToViewpoint:(NSPoint)viewPoint
{
    rect.origin.x = viewPoint.x + rect.origin.x;
    rect.origin.y = viewPoint.y - rect.origin.y - rect.size.height;
    return rect;
}

-(AMGlyphMetrics)translateBoundingBoxOriginInGlyphMetrics:(AMGlyphMetrics)metrics
                                          toViewPoint:(NSPoint)viewPoint
{
    metrics.boundingBox = [self transformRect:metrics.boundingBox fromContainerToViewpoint:viewPoint];
    return metrics;
}

-(AMGlyphMetrics)translateSelectionBoxOriginInGlyphMetrics:(AMGlyphMetrics)metrics
                                               toViewPoint:(NSPoint)viewPoint
                                        withBaselineOrigin:(NSPoint)baselineOrigin
{
    viewPoint.y = baselineOrigin.y;
    metrics.selectionBox = [self transformRect:metrics.selectionBox fromContainerToViewpoint:viewPoint];
    return metrics;
}

-(BOOL)requiresQuotientBaselining
{
    return NO;
}


@end
