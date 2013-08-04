//
//  AMNameRules.h
//  Amalie
//
//  Created by Keith Staines on 23/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMConstants.h"

@interface AMNameRules : NSObject

-(BOOL)checkName:(NSString*)proposedName forType:(AMInsertableType)type error:(NSError**)error;
-(NSAttributedString*)suggestNameForType:(AMInsertableType)type;

@end
