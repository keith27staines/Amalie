//
//  AMKeyboard.h
//  Amalie
//
//  Created by Keith Staines on 16/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//


@class AMKeyboardKeyModel;

#import <Foundation/Foundation.h>

@interface AMKeyboard : NSObject

@property (copy, readonly) NSString * name;

-(id)initWithName:(NSString*)name keys:(NSArray*)keys;

-(AMKeyboardKeyModel*)keyWithEnglishName:(NSString*)name;
-(AMKeyboardKeyModel*)keyWithIndex:(NSUInteger)index;

-(void)addKey:(AMKeyboardKeyModel*)key;

-(NSArray*)allKeys;

@end
