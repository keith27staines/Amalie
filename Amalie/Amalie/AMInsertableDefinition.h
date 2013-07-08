//
//  AMInsertableDefinition.h
//  Amalie
//
//  Created by Keith Staines on 03/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMInsertableDefinition : NSObject

@property NSPoint topLeft;
@property (copy) NSString * name;
@property NSImage * icon;
@property (copy) NSString * text;

/*!
 * Designated initializer.
 */
- (id)initWithName:(NSString*)name text:(NSString*)description;

- (id)initWithName:(NSString*)name;

@end
