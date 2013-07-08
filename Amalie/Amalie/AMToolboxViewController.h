//
//  AMToolboxViewController.h
//  Amalie
//
//  Created by Keith Staines on 03/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AMToolboxViewController : NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property (copy) NSMutableArray* insertableDefinitions;
@property (weak) IBOutlet NSTableView *tableView;

@end
