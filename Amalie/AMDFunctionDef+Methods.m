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

static NSString * const kAMDENTITYNAME = @"AMDFunctionDefs";

@implementation AMDFunctionDef (Methods)

+(AMDFunctionDef*)makeFunctionDef
{
    AMDFunctionDef * f = nil;
    f = [NSEntityDescription insertNewObjectForEntityForName:kAMDENTITYNAME
                                      inManagedObjectContext:self.moc];
    f.argumentList = [AMDArgumentList makeArgumentListUsing:self.moc];
    f.returnType = @(KSMValueDouble);
    // f.transformsArguments = [NSMutableSet set];
    
    return f;
}

@end
