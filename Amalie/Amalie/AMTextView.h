//
//  AMTextView.h
//  StylishName
//
//  Created by Keith Staines on 06/12/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AMTextView : NSView
@property (copy) NSAttributedString * attributedString;

/*! Returns the text draw origin in the receiver's coordinate system. If useQuotientBaselining is off, this origin lies on the baseline of the text. If useQuotientBaselining is on, the origin lies some distance above the baseline of the text. */
@property (readonly) NSPoint baselineOrigin;

/*! Returns the tightest rectangle that is guarenteed to enclose all ink, in the coordinate system of the receiver */
@property (readonly) NSRect tightBoundingBox;

/*! Returns the rectangle that should be used to select all text, in the coordinate system of the receiver. (The rectangle will probably contain or possibly be coincident with the tightBoundingBox */
@property (readonly) NSRect fullSelectionBox;

/*! Tells the receiver to offset the baseline above the text's inherent baseline in order to accomodate alighment with expressions involving quotients */
@property (readwrite) BOOL useQuotientBaselining;

@property (readonly)       CGFloat narrowSpace;
@property (readonly)       CGFloat standardSpace;
@property (readonly)       CGFloat wideSpace;
@property (readonly)       CGFloat ruleWidth;
@property (readonly)       CGFloat xHeight;
@property (readonly)       CGFloat maximumAscender;
@property (readonly)       CGFloat maximumDescender;
@property (readonly)       CGFloat minusSignHeightAboveBaseline;
@property (readonly)       CGFloat capHeight;
@property (readonly)       BOOL isVariableWidth;

/*! */
@property (readonly)  BOOL requiresQuotientBaselining;

/*! Returns NO, because although the text may or may not be part of the numerator or denominator of a quotient, the text itself is atomic and is not itself a quotient. */
@property BOOL showTextBaseline;

/*! */
@property BOOL showTextBaselineOrigin;
/*! */
@property BOOL showBackground;
/*! */
@property BOOL showBoundingBoxes;
/*! */
@property BOOL showSelectionBoxes;
/*! */
@property BOOL showTightBoundingBox;
/*! */
@property NSColor * textBackgroundColor;

/*! */
-(NSRect)tightBoundingBoxForCharactersInRange:(NSRange)charRange;

/*! Returns the appropriate text origin for any exponent that is to be associated with the character at the specified index (i.e, the position of the x in e^x in the receiver's coordinate system). */
-(NSPoint)exponentOffsetFromBottomLeftForCharacterWithIndex:(NSUInteger)index;

-(void)addWidthConstraint;
-(void)addHeightConstraint;

@end
