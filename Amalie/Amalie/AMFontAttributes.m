//
//  AMFontAttributes.m
//  Amalie
//
//  Created by Keith Staines on 05/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMFontAttributes.h"

@implementation AMFontAttributes

-(instancetype)init
{
    return [self initWithName:@"Times New Roman" size:12 bold:NO italic:NO allowSynthesis:YES];
}

- (instancetype)initWithName:(NSString*)name size:(CGFloat)size bold:(BOOL)isBold italic:(BOOL)isItalic allowSynthesis:(BOOL)allowSynthesis
{
    self = [super init];
    if (self) {
        self.name = name;
        self.size = size;
        self.isBold = isBold;
        self.isItalic = isItalic;
        self.allowSynthesis = allowSynthesis;
    }
    return self;
}

-(instancetype)initWithAMFontAttributes:(AMFontAttributes*)attributes
{
    return [self initWithName:attributes.name size:attributes.size bold:attributes.isBold italic:attributes.isItalic allowSynthesis:attributes.allowSynthesis];
}

+(instancetype)fontAttributesWithName:(NSString*)name size:(CGFloat)size bold:(BOOL)isBold italic:(BOOL)isItalic allowSynthesis:(BOOL)allowSynthesis
{
    id obj = [[[self class] alloc] initWithName:name size:size bold:isBold italic:isItalic allowSynthesis:allowSynthesis];
    return obj;
}

+(instancetype)fontAttributesWithAMFontAttributes:(AMFontAttributes*)attributes
{
    id obj = [[[self class] alloc] initWithAMFontAttributes:attributes];
    return obj;
}

-(NSFont *)font
{
    NSFontManager * fm = [NSFontManager sharedFontManager];
    NSFont * font = [NSFont fontWithName:self.name size:self.size];
    if (self.isBold) {
        font = [fm convertFont:font toHaveTrait:NSFontBoldTrait];
    }
    if (self.isItalic) {
        font = [fm convertFont:font toHaveTrait:NSFontItalicTrait];
    }
    return font;
}

#pragma mark - NSCopying -
-(id)copyWithZone:(NSZone *)zone
{
    return [AMFontAttributes fontAttributesWithAMFontAttributes:self];
}

#pragma mark - NSCoding -
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.name           = [aDecoder decodeObjectForKey:kAMFontNameKey];
    self.size           = [aDecoder decodeFloatForKey:kAMFontSizeKey];
    self.isBold         = [aDecoder decodeBoolForKey:kAMFontBoldKey];
    self.isItalic       = [aDecoder decodeBoolForKey:kAMFontItalicKey];
    self.allowSynthesis = [aDecoder decodeBoolForKey:kAMAllowFontSynthesisKey];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name         forKey:kAMFontNameKey];
    [aCoder encodeFloat:self.size          forKey:kAMFontSizeKey];
    [aCoder encodeBool:self.isBold         forKey:kAMFontBoldKey];
    [aCoder encodeBool:self.isItalic       forKey:kAMFontItalicKey];
    [aCoder encodeBool:self.allowSynthesis forKey:kAMAllowFontSynthesisKey];
}

#pragma mark - Support for underlying core data object -
-(void)copyFromCoreDataFontAttributes:(AMDFontAttributes *)attributes
{
    self.name = attributes.fontFamilyName;
    self.size = attributes.size.floatValue;
    self.isBold = attributes.isBold.boolValue;
    self.isItalic = attributes.isItalic.boolValue;
    self.allowSynthesis = attributes.allowSynthesis.boolValue;
}
-(void)copyToCoreDataFontAttributes:(AMDFontAttributes *)attributes
{
    attributes.fontFamilyName = self.name;
    attributes.size = @(self.size);
    attributes.isBold = @(self.isBold);
    attributes.isItalic = @(self.isItalic);
    attributes.allowSynthesis = @(self.allowSynthesis);
}

@end
