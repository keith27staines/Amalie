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

NSString * const kAMKeyboardSmallGreek   = @"Greek (small)";
NSString * const kAMKeyboardCapitalGreek = @"Greek (capital)";

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

+(NSArray*)standardKeys
{
    static NSArray * _standardKeys;
    if (!_standardKeys) {
        _standardKeys =
        @[
          // Small Greek
          [AMKeyboardKeyModel keyWithName:@"α" englishName:@"alpha"   keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"β" englishName:@"beta"    keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"γ" englishName:@"gamma"   keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"δ" englishName:@"delta"   keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"ε" englishName:@"epsilon" keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"ζ" englishName:@"zeta"    keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"η" englishName:@"eta"     keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"θ" englishName:@"theta"   keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"ι" englishName:@"iota"    keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"κ" englishName:@"kappa"   keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"λ" englishName:@"lambda"  keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"μ" englishName:@"mu"      keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"ν" englishName:@"nu"      keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"ξ" englishName:@"xi"      keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"ο" englishName:@"omicron" keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"π" englishName:@"pi"      keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"ρ" englishName:@"rho"     keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"σ" englishName:@"sigma"   keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"τ" englishName:@"tau"     keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"υ" englishName:@"upsilon" keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"φ" englishName:@"phi"     keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"χ" englishName:@"chi"     keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"ψ" englishName:@"psi"     keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          [AMKeyboardKeyModel keyWithName:@"ω" englishName:@"omega"   keyboardName:kAMKeyboardSmallGreek upperCase:NO],
          
          // Capital Greek
          [AMKeyboardKeyModel keyWithName:@"Α" englishName:@"ALPHA"   keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Β" englishName:@"BETA"    keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Γ" englishName:@"GAMMA"   keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Δ" englishName:@"DELTA"   keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Ε" englishName:@"EPSILON" keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Ζ" englishName:@"ZETA"    keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Η" englishName:@"ETA"     keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Θ" englishName:@"THETA"   keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Ι" englishName:@"IOTA"    keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Κ" englishName:@"KAPPA"   keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Λ" englishName:@"LAMBDA"  keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Μ" englishName:@"MU"      keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Ν" englishName:@"NU"      keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Ξ" englishName:@"XI"      keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Ο" englishName:@"OMICRON" keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Π" englishName:@"PI"      keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Ρ" englishName:@"RHO"     keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Σ" englishName:@"SIGMA"   keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Τ" englishName:@"TAU"     keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Υ" englishName:@"UPSILON" keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Φ" englishName:@"PHI"     keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Χ" englishName:@"CHI"     keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Ψ" englishName:@"PSI"     keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          [AMKeyboardKeyModel keyWithName:@"Ω" englishName:@"OMEGA"   keyboardName:kAMKeyboardCapitalGreek upperCase:YES],
          ];
    }
    return _standardKeys;
}


@end
