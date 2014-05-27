//
//  AMError.h
//  Amalie
//
//  Created by Keith Staines on 23/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const AMDomain;

typedef enum AMErrorCode : NSUInteger {
    // Name errors
    AMErrorCodeUnexpected = 0,
    AMErrorCodeNameIsNull = 1000,
    AMErrorCodeNameIsEmpty,
    AMErrorCodeNameisNumeric,
    AMErrorCodeNameIsNotUnique,
    AMErrorCodeNameIsCompoundExpression,
    AMErrorCodeNameBeginsWithIllegalCharacter,
    AMErrorCodeNameContainsIllegalCharacter,
    AMErrorCodeNameIsInvalid,
} AMErrorCode;

@interface AMError : NSError
+(id)errorUnexpected:(NSDictionary*)userInfo;
+(id)errorNameIsNil;
+(id)errorNameIsEmptyString;
+(id)errorNameIsNumeric:(NSString*)name;
+(id)errorNameIsCompoundExpression:(NSString*)name;
+(id)errorNameBeginsWithIllegalCharacter:(NSString*)name;
+(id)errorNameContainsIllegalCharacter:(NSString*)name;
+(id)errorNameAlreadyExists:(NSString*)string;
+(id)errorNameIsInvalid:(NSString*)name;
+(id)errorWithCode:(AMErrorCode)code
          userInfo:(NSDictionary *)dict;

@end
