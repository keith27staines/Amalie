//
//  AMTextMetric.m
//  NodeLayout
//
//  Created by Keith Staines on 06/01/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMTextMetric.h"

@interface AMTextMetric()
{
    NSTextStorage          * _textStorage;
    __weak NSLayoutManager * _layoutManager;
    __weak NSTextContainer * _textContainer;
    NSPoint                  _baselineOrigin;
    NSMutableArray         * _glyphBoundingBoxes;
    NSMutableArray         * _glyphSelectionBoxes;
    NSRect                   _tightBoundingBox;
    NSRect                   _fullSelectionBox;
    NSPoint                  _textContainerOffsetFromBaselineOrigin;
    NSPoint                  _exponentOffsetFromBottomLeft;

    NSFont                 * _baseFont;
    NSFont                 * _untraitedBaseFont;
    CGFloat                  _ruleWidth;
    CGFloat                  _standardSpace;
    CGFloat                  _narrowSpace;
    CGFloat                  _wideSpace;
    CGFloat                  _maximumAscender;
    CGFloat                  _maximumDescender;
    CGFloat                  _minusSignHeightAboveBaseline;
    CGFloat                  _xHeight;
}
@property (readonly)       NSTextStorage   * textStorage;
@property (weak, readonly) NSLayoutManager * layoutManager;
@property (weak, readonly) NSTextContainer * textContainer;
@end

@implementation AMTextMetric


+(AMTextMetric *)sharedTextMetric
{
    static AMTextMetric * _textMetric;
    if (!_textMetric) {
        _textMetric = [[self alloc] init];
    }
    return _textMetric;
}

-(NSAttributedString *)attributedString
{
    return [self.textStorage attributedSubstringFromRange:NSMakeRange(0, [self.textStorage length])];
}

-(void)setAttributedString:(NSAttributedString *)attributedstring
{
    [self.textStorage setAttributedString:[attributedstring copy]];
    if (attributedstring) {
        [self analyseText];
    }
}

-(NSLayoutManager *)layoutManager
{
    [self setupLayoutManagerStack];
    return _layoutManager;
}

-(void)setupLayoutManagerStack
{
    if (!_layoutManager) {
        NSLayoutManager * layoutManager = [[NSLayoutManager alloc] init];
        NSTextStorage   * textStorage   = [[NSTextStorage   alloc] init];
        NSTextContainer * textContainer = [[NSTextContainer alloc] init];
        _textStorage   = textStorage;
        _textContainer = textContainer;
        _layoutManager = layoutManager;
        [_textStorage   addLayoutManager:_layoutManager];
        [_layoutManager addTextContainer:_textContainer];
        [_layoutManager setUsesScreenFonts:NO];
    }
}

-(NSTextContainer *)textContainer
{
    [self setupLayoutManagerStack];
    return _textContainer;
}

-(NSTextStorage *)textStorage
{
    [self setupLayoutManagerStack];
    return _textStorage;
}

-(NSRange)glyphRange
{
    return [self.layoutManager glyphRangeForTextContainer:self.textContainer];
}

-(void)analyseText
{
    _baselineOrigin      = NSZeroPoint;
    _glyphBoundingBoxes  = [NSMutableArray array];
    _glyphSelectionBoxes = [NSMutableArray array];
    _tightBoundingBox    = NSZeroRect;
    _fullSelectionBox    = NSZeroRect;
    NSRange glyphRange   = [self glyphRange];
    for (NSUInteger glyphIndex = glyphRange.location; glyphIndex < NSMaxRange(glyphRange); glyphIndex++) {
        
        // We need the glyph in order to find its metrics...
        AMGlyphMetrics glyphMetrics = [self metricsForGlyphAtIndex:glyphIndex];
        [_glyphBoundingBoxes addObject:[NSValue valueWithRect:glyphMetrics.boundingBox]];
        [_glyphSelectionBoxes addObject:[NSValue valueWithRect:glyphMetrics.selectionBox]];
        _tightBoundingBox = NSUnionRect(_tightBoundingBox, glyphMetrics.boundingBox);
        _fullSelectionBox = NSUnionRect(_fullSelectionBox, glyphMetrics.selectionBox);
    }
}

-(NSPoint)exponentOffsetFromBottomLeftForCharacterWithIndex:(NSUInteger)charIndex
{
    if (self.textStorage.length == 0) return NSZeroPoint;
    NSFont * font = [self.textStorage attribute:NSFontAttributeName atIndex:charIndex effectiveRange:NULL];
    CGFloat xHeight = [font xHeight];
    NSRect rect = [self tightBoundingBoxForCharactersInRange:NSMakeRange(0,charIndex + 1)];
    CGFloat width = rect.size.width + xHeight / 4;
    NSPoint point = NSMakePoint(width, xHeight);
    return point;
}

-(NSRect)tightBoundingBoxForCharactersInRange:(NSRange)charRange
{
    NSRect rangeBounds = NSZeroRect;
    NSRange glyphRange = [self.layoutManager glyphRangeForCharacterRange:charRange actualCharacterRange:NULL];
    for (NSUInteger glyphIndex = glyphRange.location; glyphIndex < NSMaxRange(glyphRange); glyphIndex++) {
        NSRect bbox = [_glyphBoundingBoxes[glyphIndex] rectValue];
        rangeBounds = NSUnionRect(rangeBounds, bbox);
    }
    return rangeBounds;
}

-(AMGlyphMetrics)metricsForGlyphAtIndex:(NSUInteger)glyphIndex
{
    AMGlyphMetrics metrics;
    NSGlyph glyph = [self.layoutManager glyphAtIndex:glyphIndex];
    NSFont * font = [self fontForGlyphAtIndex:glyphIndex];
    NSRect bbox = [font boundingRectForGlyph:glyph];
    metrics.boundingBox  = bbox;
    metrics.advancement  = [font advancementForGlyph:glyph].width;
    metrics.descender    = - bbox.origin.y;
    metrics.ascender     = bbox.size.height - metrics.descender; // NB metrics descender is positive
    metrics.leftBearing  = bbox.origin.x;
    metrics.rightBearing = metrics.advancement - bbox.size.width - metrics.leftBearing;
    if (bbox.origin.x > 0) {
        metrics.selectionBox.origin.x = bbox.origin.x;
        metrics.selectionBox.size.width = bbox.size.width;
    } else {
        metrics.selectionBox.origin.x = 0;
        metrics.selectionBox.size.width = metrics.advancement + bbox.origin.x;
    }
    NSRect lineBoundingRect = [self.textStorage boundingRectWithSize:NSMakeSize(1000000,1000000)   options:0];
    metrics.selectionBox.origin.y = lineBoundingRect.origin.y;
    metrics.selectionBox.size.height = lineBoundingRect.size.height;
    
    metrics.lineFragmentRect = [self.layoutManager lineFragmentRectForGlyphAtIndex:glyphIndex
                                                                    effectiveRange:NULL];
    metrics.locationInLineFragment = [self.layoutManager locationForGlyphAtIndex:glyphIndex];
    metrics.location = NSMakePoint(metrics.locationInLineFragment.x + metrics.lineFragmentRect.origin.x, metrics.locationInLineFragment.y + metrics.lineFragmentRect.origin.y);
    return metrics;
}

-(NSAttributedString*)attributedStringForGlyphAtIndex:(NSUInteger)glyphIndex
{
    NSRange charRange = [self.layoutManager characterRangeForGlyphRange:NSMakeRange(glyphIndex, 1) actualGlyphRange:NULL];
    return [self.textStorage attributedSubstringFromRange:charRange];
}

-(NSFont*)fontForGlyphAtIndex:(NSUInteger)glyphIndex
{
    NSUInteger charIndex = [self.layoutManager characterIndexForGlyphAtIndex:glyphIndex];
    NSFont * font = [self.textStorage attribute:NSFontAttributeName atIndex:charIndex effectiveRange:NULL];
    return font;
}

-(void)drawGlyphsForGlyphRange:(NSRange)range atPoint:(NSPoint)point
{
    [self.layoutManager drawGlyphsForGlyphRange:range atPoint:point];
}

-(void)calculateBaseFont
{
    NSAttributedString * firstChar = [self attributedStringForGlyphAtIndex:0];
    NSFont * font = [firstChar attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    _baseFont = [[NSFontManager sharedFontManager] convertFont:font toNotHaveTrait:(NSBoldFontMask & NSItalicFontMask)];
}
-(void)calculateUntraitedBaseFont
{
    _untraitedBaseFont = [[NSFontManager sharedFontManager] convertFont:_baseFont toNotHaveTrait:(NSFontItalicTrait & NSFontBoldTrait)];
}

-(void)calculateStandardSpacings
{
    AMTextMetric * shared = [AMTextMetric sharedTextMetric];
    
    // Base font and untraited base font
    [self calculateBaseFont];
    [self calculateUntraitedBaseFont];
    
    NSAttributedString * minusSign = [[NSAttributedString alloc] initWithString:@"−" attributes:@{NSFontAttributeName : _untraitedBaseFont}];
    shared.attributedString = minusSign;
    
    _maximumDescender = [_untraitedBaseFont descender];
    _maximumAscender  = [_untraitedBaseFont ascender];

    _standardSpace = round([shared tightBoundingBoxForCharactersInRange:NSMakeRange(0, 1)].size.width/2.0f);
    _narrowSpace = round(_standardSpace / 2.0f);
    _wideSpace   = round(_standardSpace * 2.0f);
    _xHeight     = [_untraitedBaseFont xHeight];
    _ruleWidth = [shared tightBoundingBoxForCharactersInRange:NSMakeRange(0, 1)].size.height;
    
    NSRect boxBoundingMinus = [shared tightBoundingBoxForCharactersInRange:NSMakeRange(0, 1)];
    _minusSignHeightAboveBaseline = boxBoundingMinus.origin.y;
}

-(void)calculateStandardSpacingsIfRequired
{
    if (!_baseFont) {
        [self calculateStandardSpacings];
    }
}

-(NSFont*)baseFont
{
    [self calculateStandardSpacingsIfRequired];
    return _baseFont;
}
-(NSFont*)untraitedBaseFont
{
    [self calculateStandardSpacingsIfRequired];
    return _untraitedBaseFont;
}
-(CGFloat)capHeight
{
    [self calculateStandardSpacingsIfRequired];
    return [_untraitedBaseFont capHeight];
}
-(CGFloat)xHeight
{
    [self calculateStandardSpacingsIfRequired];
    return _xHeight;
}
-(CGFloat)ruleWidth
{
    [self calculateStandardSpacingsIfRequired];
    return _ruleWidth;
}
-(CGFloat)standardSpace
{
    [self calculateStandardSpacingsIfRequired];
    return _standardSpace;
}
-(CGFloat)minusSignHeightAboveBaseline
{
    [self calculateStandardSpacingsIfRequired];
    return _minusSignHeightAboveBaseline;
}
-(CGFloat)narrowSpace
{
    [self calculateStandardSpacingsIfRequired];
    return _narrowSpace;
}
-(CGFloat)wideSpace
{
    [self calculateStandardSpacingsIfRequired];
    return _wideSpace;
}
-(CGFloat)maximumAscender
{
    [self calculateStandardSpacingsIfRequired];
    return _maximumAscender;
}
-(CGFloat)maximumDescender
{
    [self calculateStandardSpacingsIfRequired];
    return _maximumDescender;
}

@end
