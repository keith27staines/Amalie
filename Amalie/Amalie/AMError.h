//
//  AMError.h
//  Amalie
//
//  Created by Keith Staines on 23/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum AMErrorCode : NSUInteger {
    // Name errors
    AMErrorCodeNameIsNull = 1000,
    AMErrorCodeNameIsEmpty,
    AMErrorCodeNameIsNotUnique,
} AMErrorCode;

@interface AMError : NSError

+(id)errorWithCode:(AMErrorCode)code
          userInfo:(NSDictionary *)dict;

+(id)errorForNonUniqueName:(NSString*)string;

@end
