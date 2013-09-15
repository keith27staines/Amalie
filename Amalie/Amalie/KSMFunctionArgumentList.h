//
//  KSMFunctionArgumentList.h
//  Amalie
//
//  Created by Keith Staines on 26/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class KSMExpression;
@class KSMWorksheet;
@class KSMMathValue;
@class KSMFunctionArgument;

#import <Foundation/Foundation.h>

@interface KSMFunctionArgumentList : NSObject

@property (weak) KSMWorksheet           * worksheet;
@property (copy, readonly) NSDictionary * argumentsDictionary;
@property (copy, readonly) NSArray      * argumentsArray;
@property (copy, readonly) NSArray      * namesArray;
@property (readonly) NSUInteger           argumentsCount;

-(void)addArgumentWithName:(NSString*)name value:(KSMMathValue*)value;

-(KSMFunctionArgument*)argumentAtIndex:(NSUInteger)index;
-(KSMFunctionArgument*)argumentWithName:(NSString*)name;
-(KSMMathValue*)valueAtIndex:(NSUInteger)index;
-(KSMMathValue*)valueWithName:(NSString*)name;
-(BOOL)validateMathValuesArray:(NSArray*)mathValues;
-(void)setValuesFromArray:(NSArray*)mathValues;
@end
