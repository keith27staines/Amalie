//
//  AMFunctionPropertiesView.h
//  Amalie
//
//  Created by Keith Staines on 23/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMArgumentListViewController;

#import <Cocoa/Cocoa.h>

@interface AMFunctionPropertiesView : NSView


@property IBOutlet AMArgumentListViewController * argumentListViewController;

-(void)reloadData;

@end
