//
//  AMTrayItem.m
//  Amalie
//
//  Created by Keith Staines on 11/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMTrayItem.h"
#import "AMConstants.h"

@implementation AMTrayItem

-(id)init
{
    [NSException raise:@"Use the designated initializer" format:nil];
    return nil;
}

-(id)initWithPropertiesDictionary:(NSDictionary*)dictionary
{
    return [self initWithKey:dictionary[kAMKeySuffix]
                     iconKey:dictionary[kAMIconKey]
                       title:dictionary[kAMTitleKey]
                        info:dictionary[kAMInfoKey]
             backgroundColor:colorFromData( dictionary[kAMBackColorKey] )
                   fontColor:colorFromData( dictionary[kAMFontColorKey] )
             insertableClass:dictionary[kAMClassNameKey ]
              insertableType:[dictionary[kAMTypeKey] integerValue] ];
}

- (id)initWithKey:(NSString*)key
          iconKey:(NSString*)iconKey
            title:(NSString*)title
      info:(NSString*)description
  backgroundColor:(NSColor*)backgroundColor
        fontColor:(NSColor*)fontColor
  insertableClass:(NSString *)className
   insertableType:(AMInsertableType)insertableType
{
    self = [super init];
    if (self) {
        _key = key;
        _iconKey = iconKey;
        _title = title;
        _information = description;
        _backgroundColorData = dataFromColor(backgroundColor);
        _fontColorData = dataFromColor(fontColor);
        _insertableClassName = className;
        _insertableType = insertableType;
    }
    return self;
}

-(NSAttributedString*)attributedDescription
{
    NSString * hyphenAndInfo = [@" - " stringByAppendingString:self.information];
    NSString * fullDescription = [self.title stringByAppendingString:hyphenAndInfo];
    
    NSFont * fnt = [NSFont fontWithName:@"Calibri Bold" size:0];
    
    
    NSRange titleRange = NSMakeRange(0, [self.title length]);
    //NSRange infoRange = [fullDescription rangeOfString:hyphenAndInfo];
    NSRange fullRange = NSMakeRange(0, [fullDescription length]);
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:fullDescription];
    [attrString addAttribute:NSFontNameAttribute value:fnt range:fullRange];
    
    [attrString applyFontTraits:NSFontBoldTrait | NSFontExpandedTrait range:titleRange];

    
    return attrString;
}

-(NSImage*)icon
{
    return [[NSBundle mainBundle] imageForResource:self.title];
}

-(NSColor*)backgroundColor
{
    return colorFromData(self.backgroundColorData);
}

-(void)setBackgroundColor:(NSColor *)backgroundColor
{
    self.backgroundColorData = dataFromColor(backgroundColor);
}


-(NSColor*)fontColor
{
    return colorFromData(self.fontColorData);
}

-(void)setFontColor:(NSColor *)fontColor
{
    self.fontColorData = dataFromColor(fontColor);
}

-(NSDictionary*)properties
{
    return @{kAMKeySuffix    : self.key ,
             kAMIconKey      : self.iconKey ,
             kAMTitleKey     : self.title ,
             kAMInfoKey      : self.information ,
             kAMBackColorKey : self.backgroundColorData ,
             kAMFontColorKey : self.fontColorData ,
             kAMClassNameKey : self.className ,
             kAMTypeKey      : @(self.insertableType)}
    ;
}

@end
