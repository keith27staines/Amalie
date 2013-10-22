//
//  AMKeyboards.m
//  Amalie
//
//  Created by Keith Staines on 16/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMKeyboards.h"
#import "AMKeyboard.h"
#import "AMKeyboardKeyModel.h"

NSString * const kAMKeyboardSmallGreek     = @"Greek (small)";
NSString * const kAMKeyboardCapitalGreek   = @"Greek (capital)";
NSString * const kAMKeyboardSmallEnglish   = @"English (small)";
NSString * const kAMKeyboardCapitalEnglish = @"English (capital)";
NSString * const kAMKeyboardNumeric        = @"Numeric";
NSString * const kAMKeyboardMathOperators  = @"Mathematical operators";
NSString * const kAMKeyboardMathSymbols    = @"Mathematical symbols";

static AMKeyboards * _sharedKeyboards;

@interface AMKeyboards()
{
    NSMutableDictionary * _keyboardsDictionary;
    NSMutableArray      * _keyboardsArray;
}

@property NSMutableDictionary * keyboardsDictionary;
@property NSMutableArray      * keyboardsArray;

@end


@implementation AMKeyboards

- (id)init
{
    self = [super init];
    if (self) {
        _keyboardsArray      = [NSMutableArray array];
        _keyboardsDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

+(AMKeyboards*)sharedKeyboards
{
    if (!_sharedKeyboards) {
        _sharedKeyboards = [[AMKeyboards alloc] init];
        [_sharedKeyboards keyboardWithName:kAMKeyboardSmallGreek];
        [_sharedKeyboards keyboardWithName:kAMKeyboardCapitalGreek];
        [_sharedKeyboards keyboardWithName:kAMKeyboardSmallEnglish];
        [_sharedKeyboards keyboardWithName:kAMKeyboardCapitalEnglish];
        [_sharedKeyboards keyboardWithName:kAMKeyboardNumeric];
        [_sharedKeyboards keyboardWithName:kAMKeyboardMathOperators];
        [_sharedKeyboards keyboardWithName:kAMKeyboardMathSymbols];
    }
    return _sharedKeyboards;
}

-(AMKeyboard*)keyboardWithName:(NSString *)name
{
    AMKeyboard * kb = self.keyboardsDictionary[name];
    if (!kb) {
        NSArray * standardKeys = [AMKeyboards standardKeysForKeyboard:name];
        kb = [[AMKeyboard alloc] initWithName:name keys:standardKeys];
        self.keyboardsDictionary[name] = kb;
        [self.keyboardsArray addObject:kb];
    }
    return kb;
}

-(AMKeyboard*)keyboardWithIndex:(NSUInteger)index
{
    return self.keyboardsArray[index];
}

-(NSArray *)keyboards
{
    return [self.keyboardsArray copy];
}

+(NSArray*)standardKeysForKeyboard:(NSString*)keyboardName
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"keyboardName == %@",keyboardName];
    return [[self standardKeys] filteredArrayUsingPredicate:predicate];
}

+(NSSet *)allLetterKeys
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isLetter == YES"];
    NSArray* lettersArray = [[self standardKeys] filteredArrayUsingPredicate:predicate];
    return [NSSet setWithArray:lettersArray];
}

+(NSSet *)allOperatorKeys
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isOperator == YES"];
    NSArray* lettersArray = [[self standardKeys] filteredArrayUsingPredicate:predicate];
    return [NSSet setWithArray:lettersArray];
}

+(NSArray*)standardKeys
{
    static NSArray * _standardKeys;
    if (!_standardKeys) {
        _standardKeys =
        @[
          // Small Greek
          [AMKeyboardKeyModel letterKeyWithName:@"α" englishName:@"Greek small alpha"   keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"β" englishName:@"Greek small beta"    keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"γ" englishName:@"Greek small gamma"   keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"δ" englishName:@"Greek small delta"   keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"ε" englishName:@"Greek small epsilon" keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"ζ" englishName:@"Greek small zeta"    keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"η" englishName:@"Greek small eta"     keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"θ" englishName:@"Greek small theta"   keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"ι" englishName:@"Greek small iota"    keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"κ" englishName:@"Greek small kappa"   keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"λ" englishName:@"Greek small lambda"  keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"μ" englishName:@"Greek small mu"      keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"ν" englishName:@"Greek small nu"      keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"ξ" englishName:@"Greek small xi"      keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"ο" englishName:@"Greek small omicron" keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"π" englishName:@"Greek small pi"      keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"ρ" englishName:@"Greek small rho"     keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"σ" englishName:@"Greek small sigma"   keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"τ" englishName:@"Greek small tau"     keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"υ" englishName:@"Greek small upsilon" keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"φ" englishName:@"Greek small phi"     keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"χ" englishName:@"Greek small chi"     keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"ψ" englishName:@"Greek small psi"     keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"ω" englishName:@"Greek small omega"   keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          
          // Capital Greek
          [AMKeyboardKeyModel letterKeyWithName:@"Α" englishName:@"Greek capital ALPHA"   keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Β" englishName:@"Greek capital BETA"    keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Γ" englishName:@"Greek capital GAMMA"   keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Δ" englishName:@"Greek capital DELTA"   keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Ε" englishName:@"Greek capital EPSILON" keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Ζ" englishName:@"Greek capital ZETA"    keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Η" englishName:@"Greek capital ETA"     keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Θ" englishName:@"Greek capital THETA"   keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Ι" englishName:@"Greek capital IOTA"    keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Κ" englishName:@"Greek capital KAPPA"   keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Λ" englishName:@"Greek capital LAMBDA"  keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Μ" englishName:@"Greek capital MU"      keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Ν" englishName:@"Greek capital NU"      keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Ξ" englishName:@"Greek capital XI"      keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Ο" englishName:@"Greek capital OMICRON" keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Π" englishName:@"Greek capital PI"      keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Ρ" englishName:@"Greek capital RHO"     keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Σ" englishName:@"Greek capital SIGMA"   keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Τ" englishName:@"Greek capital TAU"     keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Υ" englishName:@"Greek capital UPSILON" keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Φ" englishName:@"Greek capital PHI"     keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Χ" englishName:@"Greek capital CHI"     keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Ψ" englishName:@"Greek capital PSI"     keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Ω" englishName:@"Greek capital OMEGA"   keyboardName:kAMKeyboardCapitalGreek upperCase:YES],

          // small latin
          [AMKeyboardKeyModel letterKeyWithName:@"a" englishName:@"English small a"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"b" englishName:@"English small b"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"c" englishName:@"English small c"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"d" englishName:@"English small d"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"e" englishName:@"English small e"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"f" englishName:@"English small f"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"g" englishName:@"English small g"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"h" englishName:@"English small h"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"i" englishName:@"English small i"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"j" englishName:@"English small j"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"k" englishName:@"English small k"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"l" englishName:@"English small l"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"m" englishName:@"English small m"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"n" englishName:@"English small n"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"o" englishName:@"English small o"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"p" englishName:@"English small p"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"q" englishName:@"English small q"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"r" englishName:@"English small r"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"s" englishName:@"English small s"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"t" englishName:@"English small t"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"u" englishName:@"English small u"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"v" englishName:@"English small v"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"w" englishName:@"English small w"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"x" englishName:@"English small x"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"y" englishName:@"English small y"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          [AMKeyboardKeyModel letterKeyWithName:@"z" englishName:@"English small z"   keyboardName:kAMKeyboardSmallEnglish upperCase:NO],
          
          // capital latin
          [AMKeyboardKeyModel letterKeyWithName:@"A" englishName:@"English capital A"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"B" englishName:@"English capital B"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"C" englishName:@"English capital C"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"D" englishName:@"English capital D"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"E" englishName:@"English capital E"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"F" englishName:@"English capital F"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"G" englishName:@"English capital G"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"H" englishName:@"English capital H"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"I" englishName:@"English capital I"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"J" englishName:@"English capital J"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"K" englishName:@"English capital K"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"L" englishName:@"English capital L"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"M" englishName:@"English capital M"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"N" englishName:@"English capital N"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"O" englishName:@"English capital O"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"P" englishName:@"English capital P"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Q" englishName:@"English capital Q"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"R" englishName:@"English capital R"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"S" englishName:@"English capital S"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"T" englishName:@"English capital T"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"U" englishName:@"English capital U"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"V" englishName:@"English capital V"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"W" englishName:@"English capital W"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"X" englishName:@"English capital X"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Y" englishName:@"English capital Y"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          [AMKeyboardKeyModel letterKeyWithName:@"Z" englishName:@"English capital Y"   keyboardName:kAMKeyboardCapitalEnglish upperCase:YES],
          
          // operators (binary)
          [AMKeyboardKeyModel operatorKeyWithName:@"+" englishName:@"Addition sign" keyboardName:kAMKeyboardMathOperators],
          [AMKeyboardKeyModel operatorKeyWithName:@"-" englishName:@"Subtraction sign (or minus sign)" keyboardName:kAMKeyboardMathOperators],
          [AMKeyboardKeyModel operatorKeyWithName:@"×" englishName:@"Multiplication sign" keyboardName:kAMKeyboardMathOperators],
          [AMKeyboardKeyModel operatorKeyWithName:@"/" englishName:@"Division sign" keyboardName:kAMKeyboardMathOperators],
          [AMKeyboardKeyModel operatorKeyWithName:@"^" englishName:@"Exponentiation sign" keyboardName:kAMKeyboardMathOperators],
          [AMKeyboardKeyModel operatorKeyWithName:@"∘" englishName:@"Scalar product (inner product) sign" keyboardName:kAMKeyboardMathOperators],
          [AMKeyboardKeyModel operatorKeyWithName:@"∧" englishName:@"Vector product sign" keyboardName:kAMKeyboardMathOperators],
          
          // Number
          [AMKeyboardKeyModel numberKeyWithName:@"0" englishName:@"Zero" keyboardName:kAMKeyboardNumeric],
          [AMKeyboardKeyModel numberKeyWithName:@"1" englishName:@"One" keyboardName:kAMKeyboardNumeric],
          [AMKeyboardKeyModel numberKeyWithName:@"2" englishName:@"Two" keyboardName:kAMKeyboardNumeric],
          [AMKeyboardKeyModel numberKeyWithName:@"3" englishName:@"Three" keyboardName:kAMKeyboardNumeric],
          [AMKeyboardKeyModel numberKeyWithName:@"4" englishName:@"Four" keyboardName:kAMKeyboardNumeric],
          [AMKeyboardKeyModel numberKeyWithName:@"5" englishName:@"Five" keyboardName:kAMKeyboardNumeric],
          [AMKeyboardKeyModel numberKeyWithName:@"6" englishName:@"Six" keyboardName:kAMKeyboardNumeric],
          [AMKeyboardKeyModel numberKeyWithName:@"7" englishName:@"Seven" keyboardName:kAMKeyboardNumeric],
          [AMKeyboardKeyModel numberKeyWithName:@"8" englishName:@"Eight" keyboardName:kAMKeyboardNumeric],
          [AMKeyboardKeyModel numberKeyWithName:@"9" englishName:@"Nine" keyboardName:kAMKeyboardNumeric],
          [AMKeyboardKeyModel numberKeyWithName:@"10" englishName:@"Ten" keyboardName:kAMKeyboardNumeric],
          [AMKeyboardKeyModel numberKeyWithName:@"10^2" englishName:@"Ten squared (100)" keyboardName:kAMKeyboardNumeric],
          [AMKeyboardKeyModel numberKeyWithName:@"10^3" englishName:@"Ten cubed (1000)" keyboardName:kAMKeyboardNumeric],
          [AMKeyboardKeyModel numberKeyWithName:@"10^x" englishName:@"Ten to the power x" keyboardName:kAMKeyboardNumeric],
          [AMKeyboardKeyModel numberKeyWithName:@"e" englishName:@"The symbol e representing the constant 2.7182818..." keyboardName:kAMKeyboardNumeric],
          [AMKeyboardKeyModel numberKeyWithName:@"π" englishName:@"The symbol π for pi representing the constant 3.14159265..." keyboardName:kAMKeyboardNumeric],
          
          [AMKeyboardKeyModel mathSymbolKeyWithName:@"." englishName:@"Decimal point" keyboardName:kAMKeyboardNumeric],
          
          // Math symbols

          ];
    }
    return _standardKeys;
}


@end
