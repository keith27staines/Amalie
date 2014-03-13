//
//  AMNameProviderBase.h
//  Amalie
//
//  Created by Keith Staines on 10/12/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMFontAttributes;

#import <Foundation/Foundation.h>
#import "AMNameProviding.h"
#import "AMNameProviderDelegate.h"

@interface AMNameProviderBase : NSObject <AMNameProviding>

+(instancetype)nameProviderWithDelegate:(id<AMNameProviderDelegate>)delegate;

// Designated initializer
-(instancetype)initWithDelegate:(id<AMNameProviderDelegate>)delegate;

@end
