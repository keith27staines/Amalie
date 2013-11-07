//
//  AMDName+Methods.h
//  Amalie
//
//  Created by Keith Staines on 07/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMDName.h"
#import "AMConstants.h"

@interface AMDName (Methods)

+(AMDName*)makeAMDNameForType:(AMInsertableType)type;
+(NSArray*)fetchNames;

@end
