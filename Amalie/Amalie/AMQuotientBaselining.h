//
//  AMQuotientBaselining.h
//  Amalie
//
//  Created by Keith Staines on 17/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMOperatorView;

#import <Foundation/Foundation.h>

@protocol AMQuotientBaselining <NSObject>

@property (readonly)  CGFloat verticalMidPoint;
@property (readwrite) BOOL    useQuotientBaselining;
@property (readonly)  BOOL    requiresQuotientBaselining;

-(AMOperatorView*)baselineDefiningDivideView;
-(CGFloat)extentAboveOwnBaseline;


@end
