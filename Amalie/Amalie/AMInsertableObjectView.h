//
//  AMInsertableObjectView.h
//  Amalie
//
//  Created by Keith Staines on 04/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@import QuartzCore;
#import <Cocoa/Cocoa.h>
#import "AMTrayDatasource.h"
#import "AMTrayItem.h"
#import "AMConstants.h"
#import "AMInsertableObjectViewDelegate.h"

typedef enum AMInsertableObjectState : NSInteger {
    AMObjectNormal             = 0000,
    AMObjectCollapsed          = 1000,
    AMObjectForInpsecting      = 3000,
    AMObjectForEditing         = 4000,
    AMObjectForEditingAdvanced = 5000
} AMInsertableObjectState;

@interface AMInsertableObjectView : NSView <NSPasteboardWriting,
                                            NSPasteboardReading,
                                            NSCoding>
{

    AMInsertableObjectState _objectState;

}

@property AMInsertableObjectState objectState;
@property NSColor * backColor;
@property NSEvent * mouseDownEvent;
@property (readonly) BOOL isDragging;
@property (readonly) NSImage * dragImage;
@property float frameTop;
@property float frameLeft;
@property float frameBottom;
@property float frameRight;
@property float frameMidY;
@property NSPoint frameTopLeft;
@property (readonly) float frameWidth;
@property (readonly) float frameHeight;
@property NSString * uuid;

// Must override this in subclasses, since there will be one subclass for each tray item
-(NSString*)trayItemKey;

@property id <AMTrayDatasource> trayDataSource;
@property id <AMInsertableObjectViewDelegate> insertableObjectDelegate;




@end

