//
//  AMNameManager.h
//  StylishName
//
//  Created by Keith Staines on 09/12/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSMMathValue.h"

extern NSString * const kAMScriptingLevel;

@interface AMNameManager : NSObject
+(AMNameManager*)sharedNameManager;

//Integrated
@property CGFloat    superscriptFraction;
@property NSUInteger baseFontSize;
@property NSUInteger minimumFontSize;
@property NSString * fontFamilyNameForLatin;
@property NSString * fontFamilyNameForGreek;
@property NSString * fontFamilyNameForSymbols;

//Integrated
-(CGFloat)fontSizeForSuperscriptLevel:(NSInteger)level;

//Integrated
-(NSFont *)fontForSymbolsAtScriptinglevel:(NSUInteger)scriptingLevel;

// Integrated
-(NSFont*)defaultFontForCharacter:(NSString*)ch
                           ofType:(KSMValueType)mathType
                 superscriptLevel:(NSInteger)superscriptLevel;

-(NSMutableAttributedString*)generateAttributedStringFromName:(NSString*)name
                                                     withType:(KSMValueType)mathType;

-(NSMutableAttributedString*)stringByModifyingString:(NSAttributedString*)theString toSuperscriptLevel:(NSUInteger)superscriptLevel;

/*! Determines the character in the specified attributedstring that will be used to determine the baseline position of any exponentiating characters. The current implementation returns the last character that has its baseline offset specified as zero. So, for example:
    If attributesString = "Ax", where neither character is offset from the baseline, then 1 is returned since x is at index 1 and x is the last character in the string which is not offset from the baseline.
    If the attributed string is "Ax" where x is a subscript of A (i.e, x has a non-zero baseline offset), then 0 is returned since A is at index 0 and A is the last character in the string which is not offset from the baseline.
    Thus, if the attributedString is followed by another string (representing an exponent, or power) the position of the exponentiating string should be calculated from the bounding box of the character at the index returned by this function. The bounding box itself must be found by passing in the index to a suitable function provided by the view that displays the original attributedString.
    The offsett of the exponent from that boundin box should be determined
 @Parameter attribtuedString The string (usually representing a variable) for which we need the baseline for an exponent that is to follow it.
 @Return The index of the character that should be used to calculate the exponentiation position.
 */
-(NSUInteger)indexOfCharacterPrecedingExponentPositionForString:(NSAttributedString*)attributedString;

@end
