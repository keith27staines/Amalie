//
//  AMAppController.h
//  Amalie
//
//  Created by Keith Staines on 07/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

extern NSString* const kAMPreferencesWindowController;

@class AMPreferencesWindowController;

#import <Foundation/Foundation.h>

@interface AMAppController : NSObject

-(IBAction) showPreferencesPanel:(id)sender;

@property (strong,readonly) AMPreferencesWindowController * preferencesController;


@end
