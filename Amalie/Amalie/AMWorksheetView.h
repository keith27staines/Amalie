//
//  AMWorksheetView.h
//  Amalie
//
//  Created by Keith Staines on 04/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import"AMTrayDatasourceProtocol.h"

@interface AMWorksheetView : NSView <NSDraggingDestination>

@property IBOutlet id<AMTrayDatasourceProtocol>trayDataSource;

@end
