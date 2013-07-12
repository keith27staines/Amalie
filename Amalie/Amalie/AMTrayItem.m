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
                   fontColor:colorFromData( dictionary[kAMFontColorKey] )];
}

- (id)initWithKey:(NSString*)key
          iconKey:(NSString*)iconKey
            title:(NSString*)title
      info:(NSString*)description
  backgroundColor:(NSColor*)backgroundColor
        fontColor:(NSColor*)fontColor
{
    self = [super init];
    if (self) {
        _key = key;
        _iconKey = iconKey;
        _title = title;
        _information = description;
        _backgroundColorData = dataFromColor(backgroundColor);
        _fontColorData = dataFromColor(fontColor);
    }
    return self;
}

-(NSAttributedString*)attributedDescription
{
    NSString * fullDescription = [self.title stringByAppendingString:@" - "];
    fullDescription = [fullDescription stringByAppendingString:self.information];
    NSRange titleRange = NSMakeRange(0, [self.title length]);
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:fullDescription];
    [attrString addAttribute:NSFontNameAttribute value:[NSFont boldSystemFontOfSize:0] range:titleRange];
    
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
    return @{kAMKeySuffix : self.key ,
             kAMIconKey : self.iconKey ,
             kAMTitleKey : self.title ,
             kAMInfoKey : self.information ,
             kAMBackColorKey : self.backgroundColorData ,
             kAMFontColorKey : self.fontColorData};
}

@end
