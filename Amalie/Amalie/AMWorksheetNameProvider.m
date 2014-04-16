//
//  AMWorksheetNameProvider.m
//  Amalie
//
//  Created by Keith Staines on 16/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMWorksheetNameProvider.h"
#import "KSMWorksheet.h"
#import "KSMMathValue.h"
#import "KSMExpression.h"

@interface AMWorksheetNameProvider()
{
    KSMWorksheet * _worksheet;
}

@end

@implementation AMWorksheetNameProvider

+(id)nameProviderWithDelegate:(id<AMNameProviderDelegate>)delegate worksheet:(KSMWorksheet*)worksheet
{
    return [[self alloc] initWithDelegate:delegate worksheet:worksheet];
}

-(instancetype)initWithDelegate:(id<AMNameProviderDelegate>)delegate worksheet:(KSMWorksheet*)worksheet
{
    self = [super initWithDelegate:delegate];
    _worksheet = worksheet;
    return self;
}

-(KSMWorksheet *)worksheet
{
    if (!_worksheet) {
        _worksheet = [[KSMWorksheet alloc] init];
    }
    return _worksheet;
}
-(void)setWorksheet:(KSMWorksheet *)worksheet
{
    _worksheet = worksheet;
}
-(BOOL)isKnownObjectName:(NSString *)name
{
    return [self.worksheet isKnownObjectName:name];
}
-(NSAttributedString *)attributedStringForObjectWithName:(NSString *)name
{
    if (![self isKnownObjectName:name]) {
        return nil;
    }
    KSMExpression * exp = [self.worksheet expressionForString:name];
    if (exp) {
        switch (exp.expressionType) {
            case KSMExpressionTypeUnrecognized:
                NSAssert(NO, @"Don't know how to handle");
                break;
            case KSMExpressionTypeVariable:
            {
                KSMMathValue * mathValue = [self.worksheet variableForName:name];
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
