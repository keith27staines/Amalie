//
//  AMContentView.h
//  Amalie
//
//  Created by Keith Staines on 23/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AMGroupedView.h"
#import "AMContentViewDataSource.h"
#import "AMNameProvider.h"

@interface AMContentView : AMGroupedView

@property (weak) IBOutlet id<AMContentViewDataSource>datasource;

@end

