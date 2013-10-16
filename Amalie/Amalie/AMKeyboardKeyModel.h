//
//  AMKeyboardKeyModel.h
//  Amalie
//
//  Created by Keith Staines on 14/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMKeyboardKeyModel : NSObject

@property (copy) NSString * name;
@property (copy) NSString * keyboardName;
@property        BOOL       upperCase;
@property (copy) NSString * englishName;

+(AMKeyboardKeyModel *)keyWithName:(NSString*)name
                     englishName:(NSString *)englishName
                          keyboardName:(NSString*)family
                       upperCase:(BOOL)upperCase;

@end
