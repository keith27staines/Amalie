//
//  KSMConstants.h
//  Amalie
//
//  Created by Keith Staines on 15/01/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum KSMOperatorType : NSInteger {
    KSMOperatorTypeUnrecognized = -1,
    KSMOperatorTypePower = 0,
    KSMOperatorTypeMultiply = 1,
    KSMOperatorTypeDivide = 2,
    KSMOperatorTypeAdd = 3,
    KSMOperatorTypeSubtract = 4,
    KSMOperatorTypeVectorMultiply = 5,
    KSMOperatorTypeScalarMultiply = 6,
} KSMOperatorType;
