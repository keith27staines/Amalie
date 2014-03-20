//
//  AMUserPreferencesBaseViewController.h
//  Amalie
//
//  Created by Keith Staines on 05/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol AMUserPreferencesViewControlling <NSObject>

-(void)reloadData;

@end

@interface AMUserPreferencesBaseViewController : NSViewController <AMUserPreferencesViewControlling>

@end
