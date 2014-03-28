//
//  AMLibraryItem.h
//  Amalie
//
//  Created by Keith Staines on 11/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMColorSettings;

#import <Foundation/Foundation.h>
#import "AMConstants.h"

@interface AMLibraryItem : NSObject

+(AMLibraryItem*)libraryItemForLibraryItemKey:(NSString*)key withColorInfo:(AMColorSettings*)colorInfo;
+(AMLibraryItem*)libraryItemForInsertableType:(AMInsertableType)insertableType withColorInfo:(AMColorSettings*)colorInfo;

@property (readonly, copy) NSString * key;
@property (readonly) NSImage * icon;
@property (readonly, copy) NSString * name;
@property (readonly, copy) NSString * pluralisedName;
@property (readonly,copy) NSString * title;
@property (readonly,copy) NSString * information;
@property (readonly,copy) NSAttributedString * attributedDescription;
@property (readwrite) NSData * backgroundColorData;
@property (readwrite) NSData * fontColorData;
@property (readonly) NSDictionary * properties;
@property (readonly,copy) NSString * insertableClassName;
@property (readonly) enum AMInsertableType insertableType;

@property (weak, readwrite) NSColor * backgroundColor;
@property (weak, readwrite) NSColor * fontColor;

+(NSString*)keyForType:(AMInsertableType)type;
+(AMInsertableType)typeForKey:(NSString*)key;
@end
