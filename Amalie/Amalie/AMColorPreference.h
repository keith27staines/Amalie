//
//  AMColorPreference.h
//  Amalie
//
//  Created by Keith Staines on 25/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMColorPreference : NSObject

@property BOOL isGroupCell;
@property (copy) NSString * title;
@property (copy) NSString * detail;
@property NSImage * icon;
@property NSColor * backColor;
@property NSColor * fontColor;
@property (copy) NSString * key;

@end
