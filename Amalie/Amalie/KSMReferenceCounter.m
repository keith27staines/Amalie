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
    NSString * _symbol;
    __weak id<KSMReferenceCountedObject> _referencedCountedObject;
    NSString * _objectDescription;
}

@end

@implementation KSMReferenceCounter


- (id)init
{
    [NSException raise:@"Use the designated initializer" format:nil];
    return nil;
}

+(id)referenceCounterForObject:(id<KSMReferenceCountedObject>)object
                      delegate:(id<KSMReferenceCounterDelegate>)delegate
{
    return [[KSMReferenceCounter alloc] initWithObject:object delegate:delegate];
}

-(id)initWithObject:(id<KSMReferenceCountedObject>)object
         delegate:(id<KSMReferenceCounterDelegate>)delegate
{
    self = [super init];
    if (self) {
        NSAssert(object, @"Reference counter is being initialised with a nil object.");
        _invalid = YES;
        if (object) {
            _referencedCountedObject = object;
            object.referenceCounter = self;
            _symbol = object.symbol;
            _invalid = NO;
            _referenceCount = 1;
            _objectDescription = [object description];
        }
        _delegate = delegate;
        if (LOGGING) NSLog(@"%@ is being reference counted. Reference count = %ld",_referencedCountedObject,(long)_referenceCount);
    }
    return self;
}

-(BOOL)isValid
{
    return !_invalid;
}

-(void)increment
{
    [self checkIntegrity];
    ++_referenceCount;
    if (LOGGING) NSLog(@"Reference count for %@ was incremented to %ld.",self.referencedCountedObject, (long)_referenceCount);
}

- (void)decrement
{
    [self checkIntegrity];
    --_referenceCount;
    if (LOGGING) NSLog(@"Reference count for %@ was decremented to %ld.",self.referencedCountedObject,(long)_referenceCount);
    
    if (_referenceCount == 0) {
        _invalid = YES;
    if (LOGGING) NSLog(@"%@ should be deallocated",_referencedCountedObject);
        [self.delegate referenceCountReachedZero:self];
        return;
    }
}

-(void)checkIntegrity
{
    NSAssert(_invalid == NO , @"Reference count for object %@ has previously reached zero.",self.referencedCountedObject);
    
    if (_invalid) {
        [NSException raise:@"Reference count error." format:@"Reference count for object %@ has previously reached zero.",self.referencedCountedObject];
    }
}

-(void)objectIsDeallocating:(id<KSMReferenceCountedObject>)object
{
    NSAssert([_objectDescription isEqualToString:[object description]], @"Deallocating message received from unexpected object %@.",object);
    if (_referenceCount == 0) {
        NSLog(@"Object %@ is deallocating normally.", object);
    } else {
        NSLog(@"Object %@ is deallocating unexpectedly.", object);
    }
}

@end
