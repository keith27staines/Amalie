//
//  AMMathSheetNameProvider.m
//  Amalie
//
//  Created by Keith Staines on 16/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMMathSheetNameProvider.h"
#import "KSMMathSheet.h"
#import "KSMMathValue.h"
#import "KSMExpression.h"

@interface AMMathSheetNameProvider()
{
    KSMMathSheet * _mathSheet;
}

@end

@implementation AMMathSheetNameProvider

+(id)nameProviderWithDelegate:(id<AMNameProviderDelegate>)delegate mathSheet:(KSMMathSheet*)mathSheet
{
    return [[self alloc] initWithDelegate:delegate mathSheet:mathSheet];
}

-(instancetype)initWithDelegate:(id<AMNameProviderDelegate>)delegate mathSheet:(KSMMathSheet*)mathSheet
{
    self = [super initWithDelegate:delegate];
    _mathSheet = mathSheet;
    return self;
}

-(KSMMathSheet *)mathSheet
{
    if (!_mathSheet) {
        _mathSheet = [[KSMMathSheet alloc] init];
    }
    return _mathSheet;
}
-(void)setMathSheet:(KSMMathSheet *)mathSheet
{
    _mathSheet = mathSheet;
}
-(BOOL)isKnownObjectName:(NSString *)name
{
    return [self.mathSheet isKnownObjectName:name];
}
-(NSAttributedString *)attributedStringForObjectWithName:(NSString *)name
{
    if (![self isKnownObjectName:name]) {
        return nil;
    }
    KSMExpression * exp = [self.mathSheet expressionForString:name];
    if (exp) {
        switch (exp.expressionType) {
            case KSMExpressionTypeUnrecognized:
                NSAssert(NO, @"Don't know how to handle");
                break;
            case KSMExpressionTypeVariable:
            {
                KSMMathValue * mathValue = [self.mathSheet variableForName:name];
                if (mathValue) {
                    return [self generateAttributedStringFromName:name withType:mathValue.type];
                }
                break;
            }
            case KSMExpressionTypeLiteral:
                return [self generateAttributedStringFromName:name withType:KSMValueDouble];
                break;
            case KSMExpressionTypeBinary:
                NSAssert(NO, @"Don't know how to handle");
                break;
            case KSMExpressionTypeCompound:
                NSAssert(NO, @"Don't know how to handle");
                break;
        }
    }
    NSAssert(NO, @"Could not find attributed name for name");
    return nil;
}

@end
