//
//  KSMReferenceCounter.m
//  Amalie
//
//  Created by Keith Staines on 03/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMReferenceCounter.h"

static BOOL LOGGING = YES;

@interface KSMReferenceCounter()
{
    BOOL       _invalid;
    NSInteger  _referenceCount;
    NSString * _uuid;
    id<KSMReferenceCountedObject> _object;
}

@end

@implementation KSMReferenceCounter


- (id)init
{
    [NSException raise:@"Use the designated initializer" format:nil];
    return nil;
}

-(id)initWithObject:(id<KSMReferenceCountedObject>)object
         delegate:(id<KSMReferenceCounterDelegate>)delegate
{
    self = [super init];
    if (self) {
        _object = object;
        _uuid = object.symbol;
        _delegate = delegate;
        _invalid = !object;
        if (LOGGING) NSLog(@"Object %@ is being reference counted. Reference count = %ld",_object,(long)_referenceCount);
    }
    return self;
}

-(void)increment
{
    [self checkIntegrity];
    ++_referenceCount;
    if (LOGGING) NSLog(@"Reference count for object %@ was incremented to %ld.",_object,(long)_referenceCount);
}

- (void)decrement
{
    [self checkIntegrity];
    --_referenceCount;
    if (LOGGING) NSLog(@"Reference count for object %@ was decremented to %ld.",_object,(long)_referenceCount);
    
    if (_referenceCount == 0) {
        _invalid = YES;
    if (LOGGING) NSLog(@"Object %@ should be deallocated",_object);
        _object = nil;
        [self.delegate referenceCountReachedZero:self];
        return;
    }
    if (_referenceCount < 0) {
        [NSException raise:@"Reference count previously reached zero." format:nil];
    }
}

-(void)checkIntegrity
{
    if (_invalid) {
        [NSException raise:@"Reference count error." format:@"Object had symbol %@",_uuid];
    }
}

@end
