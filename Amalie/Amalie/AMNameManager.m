//
//  AMNameManager.m
//  StylishName
//
//  Created by Keith Staines on 09/12/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMNameManager.h"

NSString * const kAMScriptingLevel = @"kAMScriptingLevel";

typedef enum AMCharacterType : NSUInteger {
    amCharacterTypeLatin,
    amCharacterTypeGreek,
    amCharacterTypeSymbol,
} AMCharacterType;

@interface AMNameManager()
{
    CGFloat    _superscriptFraction;
    NSUInteger _minimumFontSize;
    NSUInteger _baseFontSize;
}

@end

@implementation AMNameManager

- (id)init
{
    self = [super init];
    if (self) {
        _superscriptFraction = 0.7;
        _baseFontSize = 24;
        _minimumFontSize = 4;
        _fontFamilyNameForLatin = @"Times";
        _fontFamilyNameForGreek = @"Calibri";
        _fontFamilyNameForSymbols = _fontFamilyNameForLatin;
    }
    return self;
}

+(AMNameManager *)sharedNameManager
{
    static AMNameManager * _sharedNameManager;
    if (!_sharedNameManager) {
        _sharedNameManager = [[AMNameManager alloc] init];
    }
    return _sharedNameManager;
}

-(NSUInteger)baseFontSize
{
    return _baseFontSize;
}

-(void)setBaseFontSize:(NSUInteger)baseFontSize
{
    _baseFontSize = fmaxf(baseFontSize, _minimumFontSize);
}

-(NSUInteger)minimumFontSize
{
    return _minimumFontSize;
}

-(CGFloat)superscriptFraction
{
    return _superscriptFraction;
}

-(void)setSuperscriptFraction:(CGFloat)superscriptFraction
{
    NSAssert(superscriptFraction > 0 && superscriptFraction < 1, @"Superscript fraction must be between 0 and 1");
    _superscriptFraction = superscriptFraction;
}

-(void)setMinimumFontSize:(NSUInteger)minimumFontSize
{
    _minimumFontSize = minimumFontSize;
    if (_minimumFontSize < 4) _minimumFontSize = 4;
    _baseFontSize = fmaxf(_baseFontSize, _minimumFontSize);
}

-(CGFloat)fontSizeForSuperscriptLevel:(NSInteger)level
{
    CGFloat size = [AMNameManager fontSizeForSuperscriptLevel:level
                                            givenBaseFontSize:self.baseFontSize
                                          superscriptFraction:self.superscriptFraction];
    if (size < self.minimumFontSize) size = self.minimumFontSize;
    return size;
}

+(CGFloat)fontSizeForSuperscriptLevel:(NSInteger)level
                    givenBaseFontSize:(NSUInteger)baseFontSize
                  superscriptFraction:(CGFloat)fraction
{
    CGFloat size = powf(fraction,fabs(level)) * baseFontSize;
    return round(size);
}

-(NSFont *)defaultFontForCharacter:(NSString *)ch
                     ofType:(KSMValueType)mathType
           superscriptLevel:(NSInteger)superscriptLevel
{
    NSAssert(ch.length == 1, @"The string %@ should contain only one character",ch);
    /*
     NSItalicFontMask = 0x00000001,
     NSBoldFontMask = 0x00000002,
     NSUnboldFontMask = 0x00000004,
     NSNonStandardCharacterSetFontMask = 0x00000008,
     NSNarrowFontMask = 0x00000010,
     NSExpandedFontMask = 0x00000020,
     NSCondensedFontMask = 0x00000040,
     NSSmallCapsFontMask = 0x00000080,
     NSPosterFontMask = 0x00000100,
     NSCompressedFontMask = 0x00000200,
     NSFixedPitchFontMask = 0x00000400,
     NSUnitalicFontMask = 0x01000000
     */
    
    NSUInteger traits = 0;
    NSCharacterSet * numericSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    NSRange r = [ch rangeOfCharacterFromSet:numericSet];
    if (r.location == NSNotFound)
    {
        // Character is not 0,1,2,3,4,5,6,7,8, or 9...
        switch (mathType) {
            case KSMValueInteger: case KSMValueDouble:
            {
                traits = traits | NSItalicFontMask;
                break;
            }
            case KSMValueVector:
            {
                if (superscriptLevel == 0) {
                    traits = traits | NSBoldFontMask;
                } else {
                    traits = traits | NSItalicFontMask;
                }
                break;
            }
            case KSMValueMatrix:
                traits = traits | NSBoldFontMask ;
                
                break;
        }
    }
    
    NSFontManager * fontManager = [NSFontManager sharedFontManager];
    return [fontManager fontWithFamily:[self fontFamilyNameForCharacter:ch]
                                traits:traits
                                weight:0
                                  size:[self fontSizeForSuperscriptLevel:superscriptLevel]];
    
}

-(NSMutableAttributedString*)generateAttributedStringFromName:(NSString*)name withType:(KSMValueType)mathType;
{
    if (!name) {
        return nil;
    }
    
    NSMutableAttributedString * returnString = [[NSMutableAttributedString alloc] initWithString:name attributes:nil];
    
    for (int i = 0; i < returnString.length; i++) {
        NSRange r = NSMakeRange(i, 1);
        NSString * c = [returnString.string substringWithRange:r];
        NSInteger superscriptLevel = 0;
        if (i > 0) {
            superscriptLevel = -1;
        }
        
        // Now we modify the standard fontsize and baseline offset attributes, plus our custom scripting level attribute, all of which are derived from the default font for the character type and the superscriptLevel just calculated
        NSFont * font = [self defaultFontForCharacter:c
                                               ofType:mathType
                                     superscriptLevel:superscriptLevel];
        [returnString addAttribute:kAMScriptingLevel value:@(fabsf(superscriptLevel)) range:r];
        [returnString addAttribute:NSFontAttributeName value:font range:r];
        CGFloat xHeight = [font xHeight];
        [returnString addAttribute:NSBaselineOffsetAttributeName value:@(superscriptLevel*xHeight/2.0) range:r];
    }
    return returnString;
}

-(NSUInteger)indexOfCharacterPrecedingExponentPositionForString:(NSAttributedString*)attributedString
{
    NSUInteger requiredIndex = 0;
    for (NSUInteger index = 0; index < attributedString.length; index++) {
        NSNumber * baselineOffsetNumber = [attributedString attribute:NSBaselineOffsetAttributeName atIndex:index effectiveRange:NULL];
        CGFloat baselineOffset = baselineOffsetNumber.floatValue;
        if (baselineOffset == 0.0f) {
            requiredIndex = index;
        }
    }
    return requiredIndex;
}

-(NSMutableAttributedString*)stringByModifyingString:(NSAttributedString*)theString toSuperscriptLevel:(NSUInteger)superscriptLevel
{
    NSMutableAttributedString * aString = [theString mutableCopy];
    NSFontManager * fontManager = [NSFontManager sharedFontManager];
    NSUInteger effectiveSuperscriptLevel = superscriptLevel;

    for (int i = 0; i < aString.length; i++) {
        // range of next character in aString
        NSRange range = NSMakeRange(i, 1);
        
        // identify the scripting level and font attributes
        NSMutableDictionary * attributes = [[aString attributesAtIndex:i effectiveRange:NULL] mutableCopy];
        NSFont * f = attributes[NSFontAttributeName];
        NSNumber * scriptingLevelNumber = attributes[kAMScriptingLevel];
        NSNumber * baselineOffsetNumber = attributes[NSBaselineOffsetAttributeName];
        
        // The fontsize of this character is controlled by the superscripting level of the entire string (aka superscriptLevel) + the superscript level of this particular character relative to the string
        effectiveSuperscriptLevel = superscriptLevel + scriptingLevelNumber.integerValue;
        
        // resize the character according to the superscript level
        CGFloat fontSize = [self fontSizeForSuperscriptLevel:effectiveSuperscriptLevel];
        f = [fontManager convertFont:f toSize:fontSize];
        [aString setAttributes:@{NSFontAttributeName: f, NSBaselineOffsetAttributeName: baselineOffsetNumber} range:range];
    }
    return aString;
}

-(NSMutableAttributedString*)updatedStringFromString:(NSAttributedString*)theString;
{
    NSMutableAttributedString * aString = [theString mutableCopy];
    NSFontManager * fontManager = [NSFontManager sharedFontManager];
    for (int i = 0; i < aString.length; i++) {
        // range of next character in aString
        NSRange range = NSMakeRange(i, 1);
        
        // identify the character and its attributes
        NSString * ch = [aString.string substringWithRange:range];
        NSMutableDictionary * attributes = [[aString attributesAtIndex:i effectiveRange:NULL] mutableCopy];
        
        // We need the supercript level because that controls the point size of this character. We also need the font itself because that controls bold or italic, which we want to preserve
        NSNumber * superscriptNumber = attributes[NSSuperscriptAttributeName];
        NSUInteger superscriptLevel = superscriptNumber.integerValue;
        NSFont * currentFont = [aString attribute:NSFontAttributeName atIndex:i effectiveRange:NULL];

        // Now determine the properties of the font we require...
        NSString * requiredFontFamily = [self fontFamilyNameForCharacter:ch];
        CGFloat requiredSize = [self fontSizeForSuperscriptLevel:superscriptLevel];
        
        // convert the current font into the required font
        NSFont * convertedFont;
        convertedFont = [fontManager convertFont:currentFont toFamily:requiredFontFamily];
        convertedFont = [fontManager convertFont:convertedFont toSize:requiredSize];
        
        // update the font attribute in the dictionary and apply it to the attributed string
        attributes[NSFontAttributeName] = convertedFont;
        [aString setAttributes:attributes range:range];
    }
    return aString;
}

-(NSString*)fontFamilyNameForCharacter:(NSString*)ch
{
    AMCharacterType amCharType = [self characterTypeForCharacter:ch];
    switch (amCharType) {
        case amCharacterTypeLatin:
            return self.fontFamilyNameForLatin;
        case amCharacterTypeGreek:
            return self.fontFamilyNameForGreek;
        case amCharacterTypeSymbol:
            return self.fontFamilyNameForSymbols;
    }
}

-(AMCharacterType)characterTypeForCharacter:(NSString*)ch
{
    // TODO: different types for greek, symbol etc?
    return amCharacterTypeLatin;
}

-(NSFont *)fontForSymbolsAtScriptinglevel:(NSUInteger)scriptingLevel
{
    NSFontManager * fontManager = [NSFontManager sharedFontManager];
    return [fontManager fontWithFamily:[self fontFamilyNameForSymbols]
                                traits:0
                                weight:0
                                  size:[self fontSizeForSuperscriptLevel:scriptingLevel]];
}

@end
