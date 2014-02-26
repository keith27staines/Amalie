//
//  AMMeasuredLengthFormatter.m
//  Amalie
//
//  Created by Keith Staines on 26/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMMeasuredLengthFormatter.h"

@implementation AMMeasuredLengthFormatter

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setMinimum:@(0)];
        [self setLenient:YES];
        [self setAllowsFloats:YES];
    }
    return self;
}

-(BOOL)isPartialStringValid:(NSString *)partialString newEditingString:(NSString *__autoreleasing *)newString errorDescription:(NSString *__autoreleasing *)error
{
    if (partialString.length == 0) {
        return YES;
    }
    return YES;
}
@end
