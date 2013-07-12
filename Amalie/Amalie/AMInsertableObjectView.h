//
//  AMInsertableObjectView.h
//  Amalie
//
//  Created by Keith Staines on 04/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AMTrayDatasourceProtocol.h"
#import "AMTrayItem.h"

typedef enum AMInsertableObjectState : NSInteger {
    AMObjectCollapsed = 1000,
    AMObjectNormal = 2000,
    AMObjectForInpsecting = 3000,
    AMObjectForEditing = 4000,
    AMObjectForEditingAdvanced = 5000
} AMInsertableObjectState;

@interface AMInsertableObjectView : NSView <NSPasteboardWriting,NSPasteboardReading>
{

    AMInsertableObjectState _objectState;

}

@property AMInsertableObjectState objectState;
@property NSColor * backColor;

// Must override this in subclasses, since there will be one subclass for each tray item
-(NSInteger)trayIndex;

@property id<AMTrayDatasourceProtocol>trayDataSource;



@end

