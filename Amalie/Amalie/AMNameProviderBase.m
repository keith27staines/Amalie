//
//  AMNameProviderBase.m
//  Amalie
//
//  Created by Keith Staines on 10/12/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMNameProviderBase.h"
#import "AMPreferences.h"
#import "AMDInsertedObject+Methods.h"
#import "AMDataStore.h"
#import "AMConstants.h"
#import "AMDFunctionDef+Methods.h"
#import "AMKeyboards.h"
#import "AMKeyboard.h"
#import "AMKeyboardKeyModel.h"
#import "AMDName+Methods.h"
#import "AMError.h"

typedef enum AMCharacterType : NSUInteger {
    amCharacterTypeLatin,
    amCharacterTypeGreek,
    amCharacterTypeSymbol,
} AMCharacterType;

@interface AMNameProviderBase()
{
    __weak AMDArgumentList * _dummyArguments;
}
@property (readonly) CGFloat    superscriptingFraction;
@property (readonly) NSUInteger baseFontSize;
@property (readonly) NSUInteger minimumFontSize;
@property (readonly) NSString * fontFamilyNameForLatin;
@property (readonly) NSString * fontFamilyNameForGreek;
@property (readonly) NSString * fontFamilyNameForSymbols;
@end


@implementation AMNameProviderBase

+(id)nameProvider
{
    return [[self alloc] init];
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

-(NSAttributedString*)attributedStringByModifying:(NSAttributedString*)string toSuperscriptLevel:(NSUInteger)superscriptLevel
{
    NSMutableAttributedString * aString = [string mutableCopy];
    NSFontManager * fontManager = [NSFontManager sharedFontManager];
    NSUInteger effectiveSuperscriptLevel = superscriptLevel;
    
    for (int i = 0; i < aString.length; i++) {
        // range of next character in aString
        NSRange range = NSMakeRange(i, 1);
        
        // identify the scripting level and font attributes
        NSMutableDictionary * attributes = [[aString attributesAtIndex:i effectiveRange:NULL] mutableCopy];
        NSFont * f = attributes[NSFontAttributeName];
        NSNumber * scriptingLevelNumber = attributes[kAMScriptingLevelKey];
        if (!scriptingLevelNumber) {
            scriptingLevelNumber = @0;
        }
        NSNumber * baselineOffsetNumber = attributes[NSBaselineOffsetAttributeName];
        if (!baselineOffsetNumber) {
            baselineOffsetNumber = @0;
        }
        // The fontsize of this character is controlled by the superscripting level of the entire string (aka superscriptLevel) + the superscript level of this particular character relative to the string
        effectiveSuperscriptLevel = superscriptLevel + scriptingLevelNumber.integerValue;
        
        // resize the character according to the superscript level
        CGFloat fontSize = [self fontSizeForSuperscriptLevel:effectiveSuperscriptLevel];
        f = [fontManager convertFont:f toSize:fontSize];
        [aString addAttributes:@{NSFontAttributeName: f, NSBaselineOffsetAttributeName: baselineOffsetNumber} range:range];
        
    }
    return aString;
}

-(NSFont *)fontForSymbolsAtScriptinglevel:(NSUInteger)scriptingLevel
{
    CGFloat fontSize = [self fontSizeForSuperscriptLevel:scriptingLevel];
    NSString * family = [self fontFamilyNameForSymbols];
    NSFontManager * fontManager = [NSFontManager sharedFontManager];
    return [fontManager fontWithFamily:family traits:0 weight:0 size:fontSize];
}

-(NSUInteger)baseFontSize
{
    return [AMPreferences worksheetFontSize];
}

-(NSUInteger)minimumFontSize
{
    return fminf([AMPreferences worksheetSmallestFontSize], [self baseFontSize]);
}

-(NSString *)fontFamilyNameForLatin
{
    return [AMPreferences worksheetFontName];
}

-(NSString *)fontFamilyNameForGreek
{
    return [AMPreferences worksheetFontName];
}

-(NSString *)fontFamilyNameForSymbols
{
    return [AMPreferences worksheetFontName];
}

-(CGFloat)superscriptingFraction
{
    return [AMPreferences superscriptingFraction];
}

-(CGFloat)fontSizeForSuperscriptLevel:(NSInteger)level
{
    CGFloat size = [self.class fontSizeForSuperscriptLevel:level
                                          withBaseFontSize:self.baseFontSize
                                           minimumFontSize:self.minimumFontSize
                                       superscriptFraction:self.superscriptingFraction];
    return size;
}

+(CGFloat)fontSizeForSuperscriptLevel:(NSInteger)level
                     withBaseFontSize:(NSUInteger)baseFontSize
                      minimumFontSize:(NSUInteger)minimumFontSize
                  superscriptFraction:(CGFloat)fraction
{
    CGFloat size = powf(fraction,fabs(level)) * baseFontSize;
    if (size < minimumFontSize) size = minimumFontSize;
    return size;
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
            case KSMValueInteger:
            case KSMValueDouble :
            {
                // Handle reals
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

-(NSMutableAttributedString*)generateAttributedStringFromName:(NSString*)name withType:(KSMValueType)mathType
{
    if (!name) {
        return nil;
    }
    
    NSMutableAttributedString * returnString = [[NSMutableAttributedString alloc]
                                                initWithString:name attributes:nil];
    
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
        [returnString addAttribute:kAMScriptingLevelKey value:@(fabsf(superscriptLevel)) range:r];
        [returnString addAttribute:NSFontAttributeName value:font range:r];
        CGFloat xHeight = [font xHeight];
        [returnString addAttribute:NSBaselineOffsetAttributeName value:@(superscriptLevel*xHeight/2.0) range:r];
    }
    return returnString;
}

-(void)attributedNameUpdatedWithUserPreferences:(NSMutableAttributedString*)aString
{
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
}

-(NSString*)fontFamilyNameForCharacter:(NSString*)ch
{
    AMCharacterType amCharType = [self characterTypeForCharacter:ch];
    NSString * familyName = nil;
    switch (amCharType) {
        case amCharacterTypeLatin:
            familyName = self.fontFamilyNameForLatin;
            break;
        case amCharacterTypeGreek:
            familyName = self.fontFamilyNameForGreek;
            break;
        case amCharacterTypeSymbol:
            familyName = self.fontFamilyNameForSymbols;
            break;
    }
    return familyName;
}

-(AMCharacterType)characterTypeForCharacter:(NSString*)ch
{
    // Identify the keyboard (and hence the character set) that contains the specified character
    AMKeyboard * keyboard = [[AMKeyboards sharedKeyboards] keyboardContainingCharacter:ch];
    NSString * keyboardName = keyboard.name;
    
    // Map the character to a font
    if ([keyboardName isEqualToString:kAMKeyboardSmallGreek] || [keyboardName isEqualToString:kAMKeyboardCapitalGreek]) {
        return amCharacterTypeGreek;
    }
    if ([keyboardName isEqualToString:kAMKeyboardSmallEnglish] || [keyboardName isEqualToString:kAMKeyboardCapitalEnglish]) {
        return amCharacterTypeLatin;
    }
    if ([keyboardName isEqualToString:kAMKeyboardNumeric] ) {
        return amCharacterTypeLatin;
    }
    if ([keyboardName isEqualToString:kAMKeyboardMathOperators] ) {
        return amCharacterTypeLatin;
    }
    if ([keyboardName isEqualToString:kAMKeyboardMathSymbols] ) {
        return amCharacterTypeLatin;
    }
    return amCharacterTypeLatin;
}

-(NSAttributedString *)attributedStringForObjectWithName:(NSString *)name
{
    AMDName * amdName = [AMDName fetchUniqueNameWithString:name];
    return amdName.attributedString;
}

-(KSMValueType)mathTypeForForObjectWithName:(NSString *)name
{
    AMDInsertedObject * insertedObject = [[AMDataStore sharedDataStore] insertedObjectWithName:name];
    
    if (!insertedObject) {
        // everything not specifically defined is assumed to be of type double
        return KSMValueDouble;
    }
    
    switch ((AMInsertableType)insertedObject.insertType) {
        case AMInsertableTypeConstant:
        case AMInsertableTypeVariable:
        case AMInsertableTypeFunction:
        {
            AMDFunctionDef * fnDef = (AMDFunctionDef*)insertedObject;
            return (KSMValueType)fnDef.returnType.integerValue;
            break;
        }
        case AMInsertableTypeVector:
            return KSMValueVector;
        case AMInsertableTypeMatrix:
            return KSMValueMatrix;
        default:
            return KSMValueDouble;
    }
}
-(BOOL)isKnownObjectName:(NSString *)name
{
    AMDName * amdName = [AMDName fetchUniqueNameWithString:name];
    return (amdName) ? YES : NO;
}

#pragma mark - Name validation -
-(BOOL)validateProposedName:(NSString*)proposedName
                    forType:(AMInsertableType)type
                      error:(NSError**)error
{
    if (![self nameSyntaxValid:proposedName error:error]) {
        return NO;
    }
    
    if ( ![self isKnownObjectName:proposedName] ) {
        if (error) {
            *error = [AMError errorForNonUniqueName:proposedName];
        }
        return NO;
    }
    return YES;
}

-(BOOL)nameSyntaxValid:(NSString*)name error:(NSError**)error
{
    if (!name) {
        if (error) * error = [AMError errorWithCode:AMErrorCodeNameIsNull userInfo:nil];
        return NO;
    }
    
    if ( [name isEqualToString:@""] ) {
        if (error!=NULL) * error = [AMError errorWithCode:AMErrorCodeNameIsEmpty userInfo:nil];
        return NO;
    }
    // TODO: other validation, invalidate names beginning with digits etc
    return YES;
}


@end
