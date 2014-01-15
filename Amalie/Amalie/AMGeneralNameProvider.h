//
//  AMGeneralNameProvider.h
//  Amalie
//
//  Created by Keith Staines on 10/12/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMDArgumentList, AMDArgument;

#import "AMInsertedObjectNameProvider.h"

/*!
 This class extends the AMInsertedObjectNameProvider by also parsing through dummy variable names in addition to the inserted object names parsed by super.
 */
@interface AMGeneralNameProvider : AMInsertedObjectNameProvider

@property (weak) AMDArgumentList * dummyVariables;

-(BOOL)isNameOfDummyVariable:(NSString*)name;
-(AMDArgument*)argumentWithName:(NSString*)name;

@end
