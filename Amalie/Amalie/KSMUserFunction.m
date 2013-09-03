//
//  KSMUserFunction.m
//  Amalie
//
//  Created by Keith Staines on 30/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "KSMUserFunction.h"
@interface KSMUserFunction()
{
    NSString * _name;
}
@end

@implementation KSMUserFunction

-(id)initWithName:(NSString*)name
     argumentList:(KSMFunctionArgumentList *)argumentList
       returnType:(KSMValueType)returnType
       expression:(KSMExpression*)expression
        worksheet:(KSMWorksheet *)worksheet
{
    self = [super initWithArgumentList:argumentList returnType:returnType];
    if (self) {
        _name = [name copy];
        _expression = expression;
        _worksheet = worksheet;
    }
    return self;
}

-(NSString*)name
{
    return _name;
}

-(KSMMathValue*)evaluate
{
    //TODO:
    return nil;
}

@end
