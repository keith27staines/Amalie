//
//  AMTrayItem.h
//  Amalie
//
//  Created by Keith Staines on 11/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMTrayItem : NSObject

- (id)initWithKey:(NSString*)key
          iconKey:(NSString*)iconKey
            title:(NSString*)title
      info:(NSString*)description
  backgroundColor:(NSColor*)backgroundColor
        fontColor:(NSColor*)fontColor
   insertableType:(NSString*)className;

-(id)initWithPropertiesDictionary:(NSDictionary*)dictionary;

@property (readonly) NSString * key;
@property (readonly) NSString * iconKey;
@property (readonly) NSImage * icon;
@property (readonly) NSString * title;
@property (readonly) NSString * information;
@property (readonly) NSAttributedString * attributedDescription;
@property (readwrite) NSData * backgroundColorData;
@property (readwrite) NSData * fontColorData;
@property (readonly) NSDictionary * properties;
@property (readonly) NSString * insertableClassName;

@property (weak, readwrite) NSColor * backgroundColor;
@property (weak, readwrite) NSColor * fontColor;

@end
