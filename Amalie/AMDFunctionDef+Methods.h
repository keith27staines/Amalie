//
//  AMDFunctionDef+Methods.h
//  Amalie
//
//  Created by Keith Staines on 07/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMDFunctionDef.h"
#import "AMNameProviding.h"

@interface AMDFunctionDef (Methods)

+(AMDFunctionDef*)makeFunctionDefinitionWithNameProvider:(id<AMNameProviding>)nameProvider;

@end
