//
//  AMDArgument+Methods.h
//  Amalie
//
//  Created by Keith Staines on 07/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMAmalieDocument;

#import "AMDArgument.h"
#import "KSMMathValue.h"
#import "AMNameProviding.h"

@interface AMDArgument (Methods)

+(AMDArgument*)makeArgumentOfType:(KSMValueType)mathType withNameProvider:(id<AMNameProviding>)nameProvider;


@end
