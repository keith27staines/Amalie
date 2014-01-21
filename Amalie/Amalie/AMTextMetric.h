//
//  AMTextMetric.h
//  NodeLayout
//
//  Created by Keith Staines on 06/01/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct AMGlyphMetrics {
    NSRect boundingBox;   // box that just encloses the glyph's ink in line fragment coords
    NSRect selectionBox;  // box to highlight if glyph is selected in line fragment coords
    CGFloat ascender;     // height above baseline
    CGFloat descender;    // depth below baseline
    CGFloat advancement;  // width of ink
    CGFloat leftBearing;  // distance from origin to left edge of boundingBox
    CGFloat rightBearing; // distance from right edge of bounding box to advancement + left bearing
    NSRect  lineFragmentRect; // in textContainer coords
    NSPoint locationInLineFragment;   // relative to the line fragment that holds the glyph
    NSPoint location;  // relative to text container that holds the line fragment
} AMGlyphMetrics;

@interface AMTextMetric : NSObject

@property (copy) NSAttributedString * attributedString;

+(AMTextMetric*)sharedTextMetric;

-(NSRange)glyphRange;

-(NSPoint)exponentOffsetFromBottomLeftForCharacterWithIndex:(NSUInteger)charIndex;

-(NSRect)tightBoundingBoxForCharactersInRange:(NSRange)charRange;

/*! Returns a structure containing the metrics for the glyph at the specified index */
-(AMGlyphMetrics)metricsForGlyphAtIndex:(NSUInteger)glyphIndex;

-(NSAttributedString*)attributedStringForGlyphAtIndex:(NSUInteger)glyphIndex;

-(NSFont*)fontForGlyphAtIndex:(NSUInteger)glyphIndex;
-(void)drawGlyphsForGlyphRange:(NSRange)range atPoint:(NSPoint)point;

-(CGFloat)ruleWidth;
-(CGFloat)standardSpace;
-(CGFloat)narrowSpace;
-(CGFloat)wideSpace;
-(CGFloat)xHeight;
-(CGFloat)capHeight;
-(NSFont*)baseFont;
-(NSFont*)untraitedBaseFont;
-(CGFloat)maximumAscender;
-(CGFloat)maximumDescender;
-(CGFloat)minusSignHeightAboveBaseline;
@end
