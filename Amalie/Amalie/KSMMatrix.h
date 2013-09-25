//
//  KSMMatrix.h
//  Amalie
//
//  Created by Keith Staines on 29/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSMMathValue;

@interface KSMMatrix : NSObject  <NSCopying, NSMutableCopying, NSCoding>

@property (readonly) NSUInteger rows;
@property (readonly) NSUInteger columns;
@property (readonly, copy) NSArray * data;

/*!
 Returns a zero matrix of the specified dimensions.
 */
-(id)initWithRows:(NSUInteger)rowCount columns:(NSUInteger)columnCount;

/*!
 Returns a matrix that is a copy of the specified matrix.
 */
-(id)initWithMatrix:(KSMMatrix*)matrix;

/*!
 The designated initializer.
 */
-(id)initWithRows:(NSUInteger)rowCount columns:(NSUInteger)columnCount data:(NSArray*)data;

-(NSArray*)rowAtIndex:(NSUInteger)row;
-(NSArray*)columnAtIndex:(NSUInteger)column;
-(KSMMathValue*)elementAtRow:(NSUInteger)row column:(NSUInteger)column;

+(KSMMatrix*)matrixByAddingMatrixA:(KSMMatrix*)A toMatrixB:(KSMMatrix*)B;
+(KSMMatrix*)matrixBySubtractingMatrixA:(KSMMatrix*)A fromMatrix:(KSMMatrix*)B;


-(KSMMatrix*)matrixByRaisingToIntegerPower:(KSMMathValue*)integerPower;
-(KSMMatrix*)matrixByAddingMatrix:(KSMMatrix*)otherMatrix;
-(KSMMatrix*)matrixBySubtractingMatrix:(KSMMatrix*)otherMatrix;
-(KSMMatrix*)matrixByLeftMultiplyingByMatrix:(KSMMatrix*)otherMatrix;
-(KSMMatrix*)matrixByRightMultiplyingByMatrix:(KSMMatrix*)otherMatrix;
-(KSMMatrix*)matrixByMultiplyingByScalar:(KSMMathValue*)scalar;
-(KSMMatrix*)matrixByTransposing;
-(KSMMatrix*)matrixByInverting;
-(KSMMathValue*)determinant;

@end

@interface KSMMutableMatrix : KSMMatrix
-(void)setElementAtRow:(NSUInteger)row column:(NSUInteger)column toValue:(KSMMathValue*)value;
-(void)setRow:(NSUInteger)row fromValueArray:(NSArray*)rowValues;
-(void)setColumn:(NSUInteger)column fromValueArray:(NSArray*)columnValues;

@end

