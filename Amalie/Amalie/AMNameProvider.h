//
//  AMNameProvider.h
//  Amalie
//
//  Created by Keith Staines on 10/12/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMDArgumentList, AMDArgument;

#import "AMNameProviderBase.h"

/*!
 This class extends the AMExclusiveNameProvider by also parsing through dummy variable names in addition to the inserted object names parsed by super.
 */
@interface AMNameProvider : AMNameProviderBase

+(id)nameProviderWithDummyVariables:(AMDArgumentList*)dummyVariables;

@property (readonly) AMDArgumentList * dummyVariables;

-(BOOL)isNameOfDummyVariable:(NSString*)name;
-(AMDArgument*)argumentWithName:(NSString*)name;

@end
