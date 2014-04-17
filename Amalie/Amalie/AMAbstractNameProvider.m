//
//  AMNameProvider.m
//  
//
//  Created by Keith Staines on 16/04/2014.
//
//

#import "AMAbstractNameProvider.h"
#import "AMConstants.h"
#import "AMError.h"
#import "AMFontAttributes.h"
#import "AMMathStyleSettings.h"
#import "AMKeyboardKeyModel.h"
#import "AMKeyboards.h"
#import "AMKeyboard.h"
#import "AMUserPreferences.h"

typedef NS_ENUM(NSInteger, AMCharacterType) {
    amCharacterTypeLatin,
    amCharacterTypeGreek,
    amCharacterTypeSymbol,
};

@implementation AMAbstractNameProvider

#pragma mark - NSObject -
-(id)init
{
    [NSException raise:@"Invalid initializer" format:@"Call the designated initializer"];
    return nil;
}

#pragma mark - AMNameProvider -

+(id)nameProviderWithDelegate:(id<AMNameProviderDelegate>)delegate
{
    return [[self alloc] initWithDelegate:delegate];
}
-(id)initWithDelegate:(id<AMNameProviderDelegate>)delegate
{
    self = [super init];
    if (self) {
        NSAssert(delegate, @"A delegate is required");
        _delegate = delegate;
    }
    return self;
}

#pragma mark - AMNameProviding protocol -

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
/*!
 *  Abstract method defines the interface for determining whether a named object is known to whatever store the derived class utilises
 *
 *  @param name name of the object that may or may not be in the store
 *
 *  @return YES if the name exists in the store, otherwise NO
 */
-(BOOL)isKnownObjectName:(NSString *)name
{
    [NSException raise:@"Abstract method called" format:@"Derived classes must override this method"];
    return NO;
}
/*!
 *  Abstract method defining the interface to obtain the attributes string for a named object
 *
 *  @param name name of object for which an attributes string name is required
 *
 *  @return the object's name as a fully attributed string
 */
-(NSAttributedString *)attributedStringForObjectWithName:(NSString *)name
{
    [NSException raise:@"Abstract method called" format:@"Derived classes must override this method"];
    return nil;
}
-(NSUInteger)baseFontSize
{
    return [self.delegate baseFontSize];
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

-(NSUInteger)minimumFontSize
{
    return fminf([self.delegate smallestFontSizeFraction]*[self baseFontSize], [self baseFontSize]);
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

#pragma mark - helpers -
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

+(CGFloat)fontSizeForSuperscriptLevel:(NSInteger)level
                     withBaseFontSize:(NSUInteger)baseFontSize
                      minimumFontSize:(NSUInteger)minimumFontSize
                  superscriptFraction:(CGFloat)fraction
{
    CGFloat size = powf(fraction,fabs(level)) * baseFontSize;
    if (size < minimumFontSize) size = minimumFontSize;
    return size;
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

@end
