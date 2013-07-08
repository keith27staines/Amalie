//
//  AMWorksheetController.h
//  Amalie
//
//  Created by Keith Staines on 02/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AMWorksheetController : NSPersistentDocument
@property (weak) IBOutlet NSTableView *insertableObjectsTable;
@property (weak) IBOutlet NSOutlineView *documentOutlineView;

@end
