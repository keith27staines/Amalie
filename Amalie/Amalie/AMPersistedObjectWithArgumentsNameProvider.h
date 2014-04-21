//
//  AMPersistedObjectWithArgumentsNameProvider.h
//  Amalie
//
//  Created by Keith Staines on 10/12/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMDArgumentList, AMDArgument;

#import "AMPersistedObjectNameProvider.h"

/*!
 This class extends the AMExclusiveNameProvider by also parsing through dummy variable names in addition to the inserted object names parsed by super.
 */
@interface AMPersistedObjectWithArgumentsNameProvider : AMPersistedObjectNameProvider

+(id)nameProviderWithDummyVariables:(AMDArgumentList*)dummyVariables delegate:(id<AMNameProviderDelegate>)delegate;

// Designated initializer
- (id)initWithDummyVariables:(AMDArgumentList*)dummyVariables delegate:(id<AMNameProviderDelegate>)delegate;

@property (readonly) AMDArgumentList * dummyVariables;

-(BOOL)isNameOfDummyVariable:(NSString*)name;
-(AMDArgument*)argumentWithName:(NSString*)name;

@end
