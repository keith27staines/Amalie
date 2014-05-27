//
//  AMError.m
//  Amalie
//
//  Created by Keith Staines on 23/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMError.h"

NSString * const AMDomain = @"com.AldebaranCode.Amalie";
static NSString * const AMErrorCodeNameIsNullKey      = @"AMErrorCodeNameIsNullKey";
static NSString * const AMErrorCodeNameIsEmptyKey     = @"AMErrorCodeNameIsEmptyKey";
static NSString * const AMErrorCodeNameIsNotUniqueKey = @"AMErrorCodeNameIsNotUnique";

@implementation AMError
+(id)errorUnexpected:(NSDictionary *)userInfo {
    return  [self errorWithCode:AMErrorCodeUnexpected
                       userInfo:userInfo];
}
+(id)errorNameIsNumeric:(NSString*)name {
    return  [self errorWithCode:AMErrorCodeNameisNumeric
                       userInfo:@{@"name": name}];
}

+(id)errorNameIsCompoundExpression:(NSString *)name {
    return  [self errorWithCode:AMErrorCodeNameIsCompoundExpression
                       userInfo:@{@"name": name}];
}

+(id)errorNameAlreadyExists:(NSString *)name {
    return [self errorWithCode:AMErrorCodeNameIsNotUnique
                      userInfo:@{@"name": name}];
}

+(id)errorNameBeginsWithIllegalCharacter:(NSString *)name {
    return [self errorWithCode:AMErrorCodeNameBeginsWithIllegalCharacter
                      userInfo:@{@"name": name}];
}

+(id)errorNameContainsIllegalCharacter:(NSString *)name {
    return [self errorWithCode:AMErrorCodeNameContainsIllegalCharacter
                      userInfo:@{@"name": name}];
}

+(id)errorNameIsNil {
    return [self errorWithCode:AMErrorCodeNameIsNull
                      userInfo:nil];
}
+(id)errorNameIsEmptyString {
    return [self errorWithCode:AMErrorCodeNameIsEmpty userInfo:nil];
}
+(id)errorNameIsInvalid:(NSString *)name
{
    return [self errorWithCode:AMErrorCodeNameIsInvalid
                      userInfo:@{@"name": name}];
}
+(id)errorWithCode:(AMErrorCode)code userInfo:(NSDictionary *)dict
{
    return [[AMError alloc] initWithDomain:AMDomain code:code userInfo:dict];
}

- (id)initWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict
{
    NSMutableDictionary * mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    switch (code) {
        case AMErrorCodeNameIsNull:
        {
            [NSException raise:@"Not a user error. The developer should treat this as a coding error" format:nil];
            break;
        }
        case AMErrorCodeNameIsEmpty:
        {
            mdict[NSLocalizedDescriptionKey] = NSLocalizedString(@"Invalid name.",nil);
            mdict[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"The name does not contain any characters.", nil);
            mdict[NSLocalizedRecoverySuggestionErrorKey] = NSLocalizedString(@"Add at least one character to the name", nil);
            break;
        }
        case AMErrorCodeNameisNumeric:
        {
            mdict[NSLocalizedDescriptionKey] = NSLocalizedString(@"Invalid name",nil);
            mdict[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"Names cannot be numbers.", nil);
            mdict[NSLocalizedRecoverySuggestionErrorKey] = NSLocalizedString(@"Enter a valid name", nil);
            break;
        }
        case AMErrorCodeNameIsNotUnique:
        {
            mdict[NSLocalizedDescriptionKey] = NSLocalizedString(@"Invalid name",nil);
            mdict[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"The name is a duplicate of one already in use.", nil);
            mdict[NSLocalizedRecoverySuggestionErrorKey] = NSLocalizedString(@"Change the name by to make it unique", nil);
            break;
        }
        case AMErrorCodeNameIsCompoundExpression:
        {
            mdict[NSLocalizedDescriptionKey] = NSLocalizedString(@"Invalid name",nil);
            mdict[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"You have entered an expression where a simple name is expected.", @"A mathematical expression appeared where a simple name was expected");
            mdict[NSLocalizedRecoverySuggestionErrorKey] = NSLocalizedString(@"Provide a valid name for the object", nil);
            break;
        }
        case AMErrorCodeNameBeginsWithIllegalCharacter:
        {
            mdict[NSLocalizedDescriptionKey] = NSLocalizedString(@"Invalid name",nil);
            mdict[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"Numbers may appear within a name but cannot be the first character. For example, 'f1' is a legal name, but '1f' is illegal.", nil);
            mdict[NSLocalizedRecoverySuggestionErrorKey] = NSLocalizedString(@"Add a non-numeric character to the front of the name.", nil);
            break;
        }
        case AMErrorCodeNameContainsIllegalCharacter:
        {
            mdict[NSLocalizedDescriptionKey] = NSLocalizedString(@"Invalid name",nil);
            mdict[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"Names may contain only alpha-numeric characters.", nil);
            mdict[NSLocalizedRecoverySuggestionErrorKey] = NSLocalizedString(@"Remove the invalid character(s) from the name.", nil);
            break;
        }
        case AMErrorCodeNameIsInvalid:
        {
            NSAssert(NO, @"Creating a generic invalid name error is not desirable. Try to find a more specific error");
            mdict[NSLocalizedDescriptionKey] = NSLocalizedString(@"Invalid name",nil);
            mdict[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"The name is invalid.", nil);
            mdict[NSLocalizedRecoverySuggestionErrorKey] = NSLocalizedString(@"Enter a valid name.", nil);
            break;
        }
    }
    return [super initWithDomain:domain code:code userInfo:mdict];
}


@end
