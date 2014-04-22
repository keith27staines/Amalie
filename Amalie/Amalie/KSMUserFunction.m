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

}
@end

@implementation KSMUserFunction

-(id)initWithName:(NSString*)name
     argumentList:(KSMFunctionArgumentList *)argumentList
       returnType:(KSMValueType)returnType
       expression:(KSMExpression*)expression
        mathSheet:(KSMMathSheet *)mathSheet
{
    self = [super initWithArgumentList:argumentList returnType:returnType name:name];
    if (self) {
        _expression = expression;
        _mathSheet = mathSheet;
    }
    return self;
}

-(KSMMathValue*)evaluate
{
    //TODO: implement this method
    return nil;
}

@end
