//
//  KSMFunction.h
//  Amalie
//
//  Created by Keith Staines on 26/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class KSMFunctionArgumentList;
@class KSMExpression;
@class KSMMathSheet;

#import <Cocoa/Cocoa.h>
#import "KSMReferenceCountedObject.h"
#import "KSMMathValue.h"

@interface KSMFunction : NSObject <KSMReferenceCountedObject>

@property (readonly, copy) NSString         * name;
@property KSMFunctionArgumentList           * argumentList;
@property KSMValueType                        returnType;

- (id)initWithArgumentList:(KSMFunctionArgumentList*)argumentList
                returnType:(KSMValueType)returnType;

- (id)initWithArgumentList:(KSMFunctionArgumentList*)argumentList
                returnType:(KSMValueType)returnType name:(NSString*)name;


-(KSMMathValue*)evaluate;
-(KSMMathValue*)evaluateWithValues:(NSArray*)mathValues;

@end
