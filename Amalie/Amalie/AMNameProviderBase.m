//
//  AMNameProviderBase.m
//  Amalie
//
//  Created by Keith Staines on 10/12/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMNameProviderBase.h"
#import "AMUserPreferences.h"
#import "AMDInsertedObject+Methods.h"
#import "AMDataStore.h"
#import "AMConstants.h"
#import "AMDFunctionDef+Methods.h"
#import "AMKeyboards.h"
#import "AMKeyboard.h"
#import "AMKeyboardKeyModel.h"
#import "AMDName+Methods.h"
#import "AMError.h"
#import "AMFontAttributes.h"
#import "AMMathStyleSettings.h"

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
@property (readonly) id<AMNameProviderDelegate>delegate;
@end


@implementation AMNameProviderBase

-(id)init
{
    [NSException raise:@"Invalid initializer" format:@"Call the designated initializer"];
    return nil;
}

-(id)initWithDelegate:(id<AMNameProviderDelegate>)delegate
{
    self = [super init];
    if (self) {
        NSAssert(delegate, @"Delegate must exist");
        _delegate = delegate;
    }
    return self;
}

+(id)nameProviderWithDelegate:(id<AMNameProviderDelegate>)delegate
{
    return [[self alloc] initWithDelegate:delegate];
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
    AMFontAttributes * attrs = [self.delegate fontAttributesForType:AMFontTypeSymbol];
    NSFont * font = attrs.font;
    font = [[NSFontManager sharedFontManager] convertFont:font toSize:fontSize];
    return font;
}

-(NSUInteger)baseFontSize
{
    return [self.delegate baseFontSize];
}

-(NSUInteger)minimumFontSize
{
    return fminf([self.delegate smallestFontSize], [self baseFontSize]);
}

-(CGFloat)superscriptingFraction
{
    return [self.delegate superscriptingFraction];
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

-(AMFontAttributes*)defaultFontAttributesForMainCharacter:(NSString *)ch
                                               ofMathType:(KSMValueType)mathType
                                     superscriptLevel:(NSInteger)superscriptLevel
{
    NSAssert(ch.length == 1, @"The string %@ should contain only one character",ch);
    
    AMFontAttributes * fontAttrs;
    NSCharacterSet * numericSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSRange r = [ch rangeOfCharacterFromSet:numericSet];
    if (r.location == NSNotFound) {
        AMFontType fontType = [self fontTypeForMathType:mathType];
        fontAttrs = [self.delegate fontAttributesForType:fontType];
    } else {
        // Character is a digit, 0,1,2,3,4,5,6,7,8, or 9
        fontAttrs = [self.delegate fontAttributesForType:AMFontTypeLiteral];
    }
    fontAttrs.size = [self fontSizeForSuperscriptLevel:superscriptLevel];
    return fontAttrs;
}

-(NSMutableAttributedString*)generateAttributedStringFromName:(NSString*)name withType:(KSMValueType)mathType
{
    if (!name) {
        return nil;
    }
    
    NSMutableAttributedString * returnString = [[NSMutableAttributedString alloc]
                                                initWithString:name attributes:nil];
    NSFont * font = nil;
    AMFontAttributes * fontAttrs = nil;
    NSInteger superscriptLevel = 0;
    BOOL isNumber = [self isFirstCharacterNumeric:name];
    for (int i = 0; i < returnString.length; i++) {
        NSRange r = NSMakeRange(i, 1);
        NSString * c = [returnString.string substringWithRange:r];
        if (i==0) {
            superscriptLevel = 0;
            fontAttrs = [self defaultFontAttributesForMainCharacter:c ofMathType:mathType superscriptLevel:superscriptLevel];
        } else if (i > 0 && !isNumber) {
            superscriptLevel = -1;
            fontAttrs = [self defaultFontAttributesForMainCharacter:c ofMathType:KSMValueDouble superscriptLevel:superscriptLevel];
        }
        font = [fontAttrs font];
        [returnString addAttribute:kAMScriptingLevelKey value:@(fabsf(superscriptLevel)) range:r];
        [returnString addAttribute:NSFontAttributeName value:font range:r];
        CGFloat xHeight = [font xHeight];
        [returnString addAttribute:NSBaselineOffsetAttributeName
                             value:@(superscriptLevel*xHeight*[self.delegate subscriptOffset]) range:r];
    }
    return returnString;
}


-(AMFontType)fontTypeForMathType:(KSMValueType)mathType
{
    switch (mathType) {
        case KSMValueInteger:
            return AMFontTypeAlgebra;
        case KSMValueDouble:
            return AMFontTypeAlgebra;
        case KSMValueVector:
            return AMFontTypeVector;
        case KSMValueMatrix:
            return AMFontTypeMatrix;
    }
}

-(BOOL)isFirstCharacterNumeric:(NSString*)string
{
    NSString * firstChar = [string substringToIndex:1];
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"01234456789"];
    NSRange r = [firstChar rangeOfCharacterFromSet:set options:0];
    BOOL found = !(r.location == NSNotFound);
    return found;
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
