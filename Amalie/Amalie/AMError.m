//
//  AMError.m
//  Amalie
//
//  Created by Keith Staines on 23/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMError.h"

static NSString * const AMDomain = @"com.AldebaranCode.Amalie";
static NSString * const AMErrorCodeNameIsNullKey      = @"AMErrorCodeNameIsNullKey";
static NSString * const AMErrorCodeNameIsEmptyKey     = @"AMErrorCodeNameIsEmptyKey";
static NSString * const AMErrorCodeNameIsNotUniqueKey = @"AMErrorCodeNameIsNotUnique";

@implementation AMError

+(id)errorForNonUniqueName:(NSString*)string
{
    return [self errorWithCode:AMErrorCodeNameIsNotUnique
                      userInfo:@{@"n": string}];
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
            mdict[NSLocalizedDescriptionKey] = NSLocalizedString(AMErrorCodeNameIsNullKey, @"The name is null.");
            mdict[NSLocalizedFailureReasonErrorKey] = @"NSLocalizedFailureReasonErrorKey";
            mdict[NSLocalizedRecoverySuggestionErrorKey] = @"NSLocalizedRecoverySuggestionErrorKey";
            mdict[NSHelpAnchorErrorKey] = @"NSHelpAnchorErrorKey";
            break;
        }
        case AMErrorCodeNameIsEmpty:
        {
            mdict[NSLocalizedDescriptionKey] = NSLocalizedString(AMErrorCodeNameIsEmptyKey, @"The name must contain at least one character.");
            mdict[NSLocalizedFailureReasonErrorKey] = @"NSLocalizedFailureReasonErrorKey";
            mdict[NSLocalizedRecoverySuggestionErrorKey] = @"NSLocalizedRecoverySuggestionErrorKey";
            mdict[NSHelpAnchorErrorKey] = @"NSHelpAnchorErrorKey";
            break;
        }
        case AMErrorCodeNameIsNotUnique:
        {
            mdict[NSLocalizedDescriptionKey] = NSLocalizedString(AMErrorCodeNameIsNotUniqueKey, @"The name is '%@' is already in use.");
            mdict[NSLocalizedFailureReasonErrorKey] = @"NSLocalizedFailureReasonErrorKey";
            mdict[NSLocalizedRecoverySuggestionErrorKey] = @"NSLocalizedRecoverySuggestionErrorKey";
            mdict[NSHelpAnchorErrorKey] = @"NSHelpAnchorErrorKey";
            break;
        }
        default:
            break;
    }
    self = [super initWithDomain:domain code:code userInfo:mdict];
    if (self) {

    }
    return self;
}


@end
