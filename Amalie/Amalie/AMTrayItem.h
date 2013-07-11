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
      description:(NSString*)description
  backgroundColor:(NSColor*)backgroundColor
        fontColor:(NSColor*)fontColor;

-(id)initWithPropertiesDictionary:(NSDictionary*)dictionary;

@property (readonly) NSString * key;
@property (readonly) NSString * iconKey;
@property (readonly) NSImage * icon;
@property (readonly) NSString * title;
@property (readonly) NSString * description;
@property (readonly) NSAttributedString * attributedDescription;
@property (readwrite) NSData * backgroundColorData;
@property (readwrite) NSData * fontColorData;
@property (readonly) NSDictionary * properties;

@property (weak, readwrite) NSColor * backgroundColor;
@property (weak, readwrite) NSColor * fontColor;

@end
