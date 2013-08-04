//
//  KSMReferenceCounter.m
//  Amalie
//
//  Created by Keith Staines on 03/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMReferenceCounter.h"

@interface KSMReferenceCounter()
{
    NSInteger _referenceCount;
    NSString * _uuid;
}

@end

@implementation KSMReferenceCounter


- (id)init
{
    [NSException raise:@"Use the designated initializer" format:nil];
    return nil;
}

-(id)initWithUUID:(NSString*)uuid
{
    self = [super init];
    if (self) {
        _uuid = uuid;
    }
    return self;
}

-(void)increment
{
    ++_referenceCount;
}

- (void)decrement
{
    --_referenceCount;
    
    if (_referenceCount == 0) {
        [self.delegate referenceCountReachedZero:self];
        return;
    }
    if (_referenceCount < 0) {
        [NSException raise:@"Reference count previously reached zero." format:nil];
    }
}

@end
