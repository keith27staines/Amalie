//
//  KSMReferenceCounter.h
//  Amalie
//
//  Created by Keith Staines on 03/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSMReferenceCountedObject.h"

@class KSMReferenceCounter;

@protocol KSMReferenceCounterDelegate <NSObject>

- (void)referenceCountReachedZero:(KSMReferenceCounter*)refCounter;

@end

@interface KSMReferenceCounter : NSObject

@property (weak) id <KSMReferenceCounterDelegate>delegate;
@property (readonly) NSString * uuid;
@property (weak, readonly) id<KSMReferenceCountedObject>referencedCountedObject;
@property (readonly) BOOL isValid;

/*!
 Designated initializer.
 @Param object The universally unique identifier of the object being reference counted.
 @Return The initialized object.
 */
-(id)initWithObject:(id<KSMReferenceCountedObject>)object
           delegate:(id<KSMReferenceCounterDelegate>)delegate;

/*!
 Convenience method that calls the designated initializer
 */
+(id)referenceCounterForObject:(id<KSMReferenceCountedObject>)object
                      delegate:(id<KSMReferenceCounterDelegate>)delegate;

- (void)increment;
- (void)decrement;

-(void)objectIsDeallocating:(id<KSMReferenceCountedObject>)object;

@end
