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

-(BOOL)checkName:(NSAttributedString*)proposedName forType:(AMInsertableType)type error:(NSError**)error;

/*!
 suggestNameForType: generates a reasonable name for the specified type that is unique to the parent worksheet.
 @Param type The type of object to name.
 @Return the suggested name for a new instance of the specified type.
 */
-(NSAttributedString*)suggestNameForType:(AMInsertableType)type;

@end
