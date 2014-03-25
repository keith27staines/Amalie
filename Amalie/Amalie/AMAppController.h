//
//  AMAppController.h
//  Amalie
//
//  Created by Keith Staines on 07/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMPreferencesWindowController;
@class AMPreferences;

/*!
 * Manages the main menu items not related to the current document. 
 * Also manages objects and data structures that are referenced by
 * more than one window, such as user preferences.
 */
@interface AMAppController : NSObject

- (IBAction)showPreferencesPanel:(id)sender;



@end
