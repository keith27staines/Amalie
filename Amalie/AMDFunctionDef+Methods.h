//
//  AMDFunctionDef+Methods.h
//  Amalie
//
//  Created by Keith Staines on 07/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMDFunctionDef.h"
#import "AMNameProviding.h"
#import "AMNamedAndTypedObject.h"

@interface AMDFunctionDef (Methods) <AMNamedAndTypedObject>

+(AMDFunctionDef*)makeFunctionDefinitionWithNameProvider:(id<AMNameProviding>)nameProvider;


@property NSNumber * valueType;
@end
