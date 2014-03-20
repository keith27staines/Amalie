//
//  AMFontText.m
//  FontList
//
//  Created by Keith Staines on 14/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMFontText.h"

NSString * const EXAMPLE = @"Example";

@interface AMFontText()
{
    NSString * _exampleText;
}

@end

@implementation AMFontText

+(id)fontTextWithFamilyName:(NSString *)familyName
{
    return [[self alloc] initWithFamilyName:familyName];
}

-(CGFloat)fontSize
{
    return [NSFont systemFontSize];
}

- (instancetype)initWithFamilyName:(NSString*)familyName
{
    self = [super init];
    if (self) {
        _familyName = familyName;
    }
    return self;
}
-(NSFont *)regularFont
{
    NSFontManager * fm = [NSFontManager sharedFontManager];
    return [fm fontWithFamily:self.familyName traits:0 weight:5 size:[self fontSize]];
}
-(NSFont *)boldFont
{
    NSFontManager * fm = [NSFontManager sharedFontManager];
    return [fm convertFont:[self regularFont] toHaveTrait:NSFontBoldTrait];
}
-(NSFont *)italicFont
{
    NSFontManager * fm = [NSFontManager sharedFontManager];
    return [fm convertFont:[self regularFont] toHaveTrait:NSFontItalicTrait];
}
-(NSFont *)italicBoldFont
{
    NSFontManager * fm = [NSFontManager sharedFontManager];
    return [fm convertFont:[self italicFont] toHaveTrait:NSFontBoldTrait];
}

-(NSAttributedString *)regularText
{
    NSAttributedString * string = [[NSAttributedString alloc] initWithString:self.exampleText attributes:@{NSFontAttributeName:self.regularFont}];
    return string;
}
-(NSAttributedString *)italicText
{
    NSAttributedString * string = [[NSAttributedString alloc] initWithString:self.exampleText attributes:@{NSFontAttributeName:[self italicFont]}];
    return string;
}
-(NSAttributedString *)boldText
{
    NSAttributedString * string = [[NSAttributedString alloc] initWithString:self.exampleText attributes:@{NSFontAttributeName:[self boldFont]}];
    return string;
}
-(NSAttributedString *)italicBoldText
{
    NSAttributedString * string = [[NSAttributedString alloc] initWithString:self.exampleText attributes:@{NSFontAttributeName:[self italicBoldFont]}];
    return string;
}
-(NSString*)exampleText
{
    if (_exampleText) {
        return [_exampleText copy];
    } else {
        return [EXAMPLE copy];
    }
}
-(void)setExampleText:(NSString *)exampleText
{
    _exampleText = [exampleText copy];
}
-(NSAttributedString *)fontFamilyInSystemFont
{
    NSString * family = self.familyName;
    return [[NSAttributedString alloc] initWithString:family attributes:@{NSFontAttributeName:[NSFont systemFontOfSize:[self fontSize]]}];
}
@end
