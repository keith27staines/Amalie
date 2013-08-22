//
//  AMNameView.h
//  Amalie
//
//  Created by Keith Staines on 20/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AMQuotientBaselining.h"
#import "AMContentViewDataSource.h"

@interface AMNameView : NSTextField <AMQuotientBaselining>

@property (copy) NSString * groupID;
@property (weak) id<AMContentViewDataSource> dataSource;

@end
