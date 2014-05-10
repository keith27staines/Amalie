//
//  AMKeyboards.h
//  Amalie
//
//  Created by Keith Staines on 16/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMKeyboard;

#import <Foundation/Foundation.h>

@interface AMKeyboards : NSObject

@property (readonly, copy) NSArray * keyboards;

+(AMKeyboards*)sharedKeyboards;

-(AMKeyboard*)keyboardWithName:(NSString*)name;
-(AMKeyboard*)keyboardWithIndex:(NSUInteger)index;
-(AMKeyboard*)keyboardContainingCharacter:(NSString*)ch;

+(NSSet*)allLetterKeys;
+(NSSet*)allOperatorKeys;

@end
