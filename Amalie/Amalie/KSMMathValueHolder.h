//
//  KSMMathValueHolder.h
//  Amalie
//
//  Created by Keith Staines on 16/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KSMMathValue.h"

@interface KSMMathValueHolder : NSObject

@property (readwrite,copy) KSMMathValue   * mathValue;
@property (readonly, copy) NSString       * name;
@property (readonly, copy) NSString       * symbol;
@property (readonly)       KSMValueType     type;

-(id)initWithName:(NSString*)name symbol:(NSString*)symbol;

-(id)initWithName:(NSString*)name symbol:(NSString*)symbol mathValue:(KSMMathValue*)mathValue;

@end
