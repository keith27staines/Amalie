//
//  AMTrayItem.h
//  Amalie
//
//  Created by Keith Staines on 11/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

// forward declare enums used in interface
enum AMInsertableType : NSUInteger;

@interface AMTrayItem : NSObject

- (id)initWithKey:(NSString*)key
          iconKey:(NSString*)iconKey
            title:(NSString*)title
      info:(NSString*)description
  backgroundColor:(NSColor*)backgroundColor
        fontColor:(NSColor*)fontColor
  insertableClass:(NSString*)className
   insertableType:(enum AMInsertableType)insertableType;

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
@property (readonly) enum AMInsertableType insertableType;

@property (weak, readwrite) NSColor * backgroundColor;
@property (weak, readwrite) NSColor * fontColor;

@end
