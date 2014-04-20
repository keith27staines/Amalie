//
//  AMPageOrientationView.h
//  Amalie
//
//  Created by Keith Staines on 20/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "AMConstants.h"
#import "AMPageSetupDataSource.h"

@interface AMPageOrientationView : NSView

-(void)reloadData;

@property IBOutlet id<AMPageSetupDataSource> dataSource;



@end
