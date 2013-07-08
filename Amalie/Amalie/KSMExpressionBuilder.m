//
//  KSMExpressionBuilder.m
//  KSMath
//
//  Created by Keith Staines on 26/06/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMExpressionBuilder.h"
#import "KSMExpression.h"
#import "KSMWorksheet.h"

KSMExpressionBuilder * defaultBuilder;

@interface KSMExpressionBuilder()
{
    __weak KSMWorksheet * _worksheet;
}

@end

@implementation KSMExpressionBuilder

- (id)init
{
    [NSException raise:@"Use the desginated constructor." format:nil];
    return nil;
}

- (id)initWithWorksheet:(KSMWorksheet *)worksheet
{
    if (!worksheet) [NSException raise:@"The worksheet must not be nil." format:nil];

    self = [super init];
    if (self) {
        _worksheet = worksheet;
    }
    return self;
}

-(KSMExpression*)buildExpressionFromString:(NSString*)string
{
    return [[KSMExpression alloc] initWithString:string];
}




@end
