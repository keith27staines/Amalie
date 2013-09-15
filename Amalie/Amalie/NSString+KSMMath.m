//
//  NSString+KSMMath.m
//  ExpressionBuilder
//
//  Created by Keith Staines on 18/06/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "NSString+KSMMath.h"

@implementation NSString (KSMMath)

+(NSString *)KSMjustNumbers
{
    return @"0123456789";
}

+(NSString *)KSMjustLowerCase
{
    return @"abcdefghijklmnopqrstuvwxyz";
}

+(NSString *)KSMjustUpperCase
{
    return [[NSString KSMjustLowerCase] uppercaseString];
}

-(BOOL)KSMcontainsCharactersInSet:(NSCharacterSet*)set
{
    NSRange r = [self rangeOfCharacterFromSet:set];
    return (r.location == NSNotFound) ? NO: YES;
}

-(BOOL)KSMcontainsCharactersInString:(NSString *)chars
{
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:chars];
    return [self KSMcontainsCharactersInSet:set];
}

-(BOOL)KSMcontainsOnlyCharactersInString:(NSString *)str
{
    if (!str) return NO;
    
    if ([str isEqualToString:@"" ] && [self isEqualToString:@""]) return YES;
        
    for (int i = 0; i < [self length]; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString * letter = [self substringWithRange:range];
        if (![str KSMcontainsCharactersInString:letter]) {
            return NO;
        }
    }
    return YES;
}

-(NSString *)KSMfirstCharacter
{
    if ([self length]==0) return nil;
    return [self substringToIndex:1];
}

-(NSString *)KSMlastCharacter
{
    if ([self length]==0) return nil;
    return [self substringFromIndex:[self length]-1];
}

-(BOOL)KSMvalidName
{
    NSString * dollar = @"$";
    NSString * validFirstCharacters = [[NSString KSMjustLowerCase] stringByAppendingString:[NSString KSMjustUpperCase]];

    NSString * allValidCharacters = [validFirstCharacters stringByAppendingString:[NSString KSMjustNumbers]];
    
    allValidCharacters = [allValidCharacters stringByAppendingString:@"_"];
    
    // all valid names must be at least one character
    if ([self length] == 0)return NO;

    // first char must be a letter or $
    NSString * firstChar = [self KSMfirstCharacter];
    if ([firstChar isEqualToString:dollar]) {
        
        // If first character is $, there must be at least two characters
        if ([self length] < 2) return NO;

        // all characters other than possbile first $ must be from the valid set
        NSString * stringAfterDollar = [self substringFromIndex:1];
        if (![stringAfterDollar KSMcontainsOnlyCharactersInString:allValidCharacters]) return NO;
    
    } else {

        // firstChar wasn't $, so must be a valid first character
        if (![firstChar KSMcontainsCharactersInString:validFirstCharacters]) return NO;

        // all characters must be from the valid set
        if (![self KSMcontainsOnlyCharactersInString:allValidCharacters]) return NO;

    }
    
    // All okay
    return YES;
}

-(BOOL)KSMpureNumber
{
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    NSNumber * n = [f numberFromString:self];
    
    return (!(n ==nil));
}

-(NSUInteger)KSMnumberOfOccurencesOfString:(NSString*)str
{
    if (!str) return 0;
    
    NSString * copy = [self copy];
    NSUInteger count = 0;
    NSRange r = [copy rangeOfString:str];
    while (r.location !=NSNotFound) {
        count++;
        copy = [copy stringByReplacingCharactersInRange:r withString:@""];
        r = [copy rangeOfString:str];
    }

    return count;
}



@end
