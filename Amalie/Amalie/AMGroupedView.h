//
//  AMGroupedView.h
//  Amalie
//
//  Created by Keith Staines on 05/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AMViewHelper.h"


@interface AMGroupedView : NSView <NSCoding>

/*!
 The id that identifies which group the receiver belongs to.
 */
@property (readwrite) NSString * groupID;

/*!
 The designated initializer. If initializing from a store, or the receiver is to belong to an already established group, the required group id should be passed in. If initializing a new top-level object, you can safely pass in nil and the receiver will generate its own group identifer using the class method generateGroupIdentifier and thus become the first, or top-level member of a new group.
 @Param frame The initial frame of the view.
 @Param groupID Identifies the group to which the receiver is to belong.
 @Return The initialized object.
 */
- (id)initWithFrame:(NSRect)frame groupID:(NSString*)groupID;

/*!
 Generates a new identifier. In this implementation, NSUUID is used.
 @Return a new group identifier.
 */
+(NSString*)generateGroupIdentifier;


@end
