//
//  AMKeyboardEditorViewController.h
//  Amalie
//
//  Created by Keith Staines on 01/06/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AMNameProviding.h"

@interface AMKeyboardEditorViewController : NSViewController


@property (copy) void (^completionHandler)(void);
- (IBAction)close:(id)sender;

@property id<AMNameProviding>nameProvider;

- (void)reloadData;

@end
