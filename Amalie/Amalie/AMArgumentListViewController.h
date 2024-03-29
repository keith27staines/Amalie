//
//  AMArgumentListViewController.h
//  Amalie
//
//  Created by Keith Staines on 08/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMAmalieDocument,AMDArgumentList;

#import <Cocoa/Cocoa.h>
#import "AMArgumentListView.h"
#import "AMNameProviding.h"

@interface AMArgumentListViewController : NSViewController <AMArgumentListViewDelegate>

@property (weak) AMDArgumentList * argumentList;


@property (weak) IBOutlet id<AMNameProviding> nameProvider;

-(void)reloadData;

@end
