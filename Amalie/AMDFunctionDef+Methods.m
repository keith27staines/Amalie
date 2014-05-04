//
//  AMDFunctionDef+Methods.m
//  Amalie
//
//  Created by Keith Staines on 07/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMDFunctionDef+Methods.h"
#import "AMDExpression+Methods.h"
#import "NSManagedObject+SharedDataStore.h"
#import "NSString+KSMMath.h"
#import "AMDataStore.h"
#import "AMDArgumentList+Methods.h"
#import "AMDArgument+Methods.h"
#import "AMDName+Methods.h"

static NSString * const kAMDENTITYNAME = @"AMDFunctionDefs";

@implementation AMDFunctionDef (Methods)

+(AMDFunctionDef*)makeFunctionDefinitionWithNameProvider:(id<AMNameProviding>)nameProvider
{
    AMDFunctionDef * f = nil;
    f = [NSEntityDescription insertNewObjectForEntityForName:kAMDENTITYNAME
                                      inManagedObjectContext:self.moc];
    f.argumentList = [AMDArgumentList makeArgumentList];
    AMDArgument * argument = [AMDArgument makeArgumentOfType:KSMValueDouble withNameProvider:nameProvider];
    [f.argumentList addArgumentsObject:argument];
    f.returnType = @(KSMValueDouble);
    // f.transformsArguments = [NSMutableSet set];
    
    return f;
}
-(void)setValueType:(KSMValueType)valueType
{
    self.returnType = @(valueType);
}
-(KSMValueType)valueType
{
    return self.returnType.integerValue;
}

@end
