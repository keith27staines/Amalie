//
//  AMExpressionDisplayOptions.m
//  Amalie
//
//  Created by Keith Staines on 11/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMExpressionDisplayOptions.h"

CGFloat     const kAMFontDefaultPointSize = 17;
NSUInteger  const kAMFontDefaultWeight = 0;
NSUInteger  const kAMFontDefaultTraits = 0;
NSString  * const kAMFontDefaultFamilyName = @"Times New Roman";



@interface AMExpressionDisplayOptions()
{
    NSMutableDictionary * _fonts;
}

@property (readonly) NSMutableDictionary * fonts;

@end

@implementation AMExpressionDisplayOptions

-(id)init
{
    return [self initWithFonts:nil];
}

- (id)initWithFonts:(NSMutableDictionary*)fonts
{
    self = [super init];
    if (self) {
        _fonts = [fonts mutableCopy];
    }
    return self;
}


-(NSMutableDictionary *)fonts
{
    if (!_fonts) {
        _fonts = [NSMutableDictionary dictionary];
    }
    return _fonts;
}

-(NSFont *)fontOfAMType:(AMFontType)type
{
    NSFont * f = self.fonts[@(type)];
    if (f) return f;
    if (_parentOptions) return [_parentOptions fontOfAMType:type];
    return [self defaultFontOfType:type];
}

-(void)overrideFontOfType:(AMFontType)type withFont:(NSFont*)font
{
    self.fonts[@(type)] = font;
}

-(NSFont *)defaultFontOfType:(AMFontType)type
{
        /* For ease of reference...
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
    NSString * fontFamilyName   = kAMFontDefaultFamilyName;
    NSFontTraitMask mask        = kAMFontDefaultTraits;
    NSUInteger weight           = kAMFontDefaultWeight;
    CGFloat pointSize           = 21.0f; // kAMFontDefaultPointSize;
    
    switch (type) {
        case AMFontTypeAlgebra:
        {
            mask = NSItalicFontMask;
            break;
        }
        case AMFontTypeLiteral:
        {
            break;
        }
        case AMFontTypeText:
        {
            break;
        }
        case AMFontTypeVector:
        {
            fontFamilyName = @"Helvetica Neue";
            mask = NSBoldFontMask;
            break;
        }
        case AMFontTypeMatrix:
        {
            fontFamilyName = @"Helvetica Neue";
            mask = NSBoldFontMask;
            break;
        }
        case AMFontTypeSymbol:
        {
            fontFamilyName = @"Helvetica Neue";
            mask = NSBoldFontMask;
            break;
        }
    }
    NSFont * f = [[NSFontManager sharedFontManager] fontWithFamily:fontFamilyName
                                                            traits:mask
                                                            weight:weight
                                                              size:pointSize];
    
    return f;
}


@end
