//
//  AMInsertableRecord.h
//  Amalie
//
//  Created by Keith Staines on 23/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMNameRules;

#import <Foundation/Foundation.h>
#import "AMConstants.h"

@interface AMInsertableRecord : NSObject

@property (copy) NSAttributedString * attributedName;
@property (weak, readonly) NSString * uuid;
@property (readonly) AMInsertableType type;
@property (readonly) NSUInteger expressionCount;

/*!
 Designated initializer.
 @Param attributedName The name of the object (if the object is a mathematical object, the name should obey standard mathemtical conventions but this is not enfored here.
 @Param nameRules A rules engine to validate proposed name changes.
 @Param uuid The uuid of the record.
 @Param type The type of the record.
 @Param mathSheet The KSMWorksheet that manages mathematical objects.
 @Return An initialized object.
 */
- (id)initWithName:(NSAttributedString*)attributedName
         nameRules:(AMNameRules*)nameRules
              uuid:(NSString*)uuid
              type:(AMInsertableType)type;

/*! Delete the entire record from the store */
-(void)deleteFromStore;

/*!
 Changes the attributed name if the name rules and uniqueness requirement is
 satisfied, otherwise does nothing.
 @Param proposedName attributed string containing the proposed name.
 @Param error A pointer to an NSError object. The pointer will only be valid if the proposed name fails the naming rules.
 @Return YES if the proposed name is valid and the requested name change is performed.
 */
-(BOOL)changeAttributedNameIfValid:(NSAttributedString*)proposedName
                             error:(NSError**)error;
@end
