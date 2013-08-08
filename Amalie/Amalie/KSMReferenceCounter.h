//
//  KSMReferenceCounter.h
//  Amalie
//
//  Created by Keith Staines on 03/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSMReferenceCounter;

@protocol KSMReferenceCounterDelegate <NSObject>

- (void)referenceCountReachedZero:(KSMReferenceCounter*)refCounter;

@end

@interface KSMReferenceCounter : NSObject

@property (weak) id <KSMReferenceCounterDelegate>delegate;
@property (readonly) NSString * uuid;

/*!
 Designated initializer.
 @Param uuid The universally unique identifier of the object being reference counted.
 @Return The initialized object.
 */
-(id)initWithUUID:(NSString*)uuid;

- (void)increment;
- (void)decrement;

@end