//
//  KSMReferenceCountedObject.h
//  Amalie
//
//  Created by Keith Staines on 02/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KSMReferenceCounter;

@protocol KSMReferenceCountedObject <NSObject>
@property (readonly) NSString * symbol;
@property (weak,readwrite) KSMReferenceCounter * referenceCounter;

@end
