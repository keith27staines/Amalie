//
//  AMInsertableObjectView.h
//  Amalie
//
//  Created by Keith Staines on 04/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum AMInsertableObjectState : NSInteger {
    AMObjectInTray = 0,
    AMObjectSelectedInTray = 500,
    AMObjectMovingInTray = 1000,
    AMObjectMovingOutsideOfTray = 2000,
    AMObjectInsertable = 3000,
    AMObjectInsertedCollapsed = 4000,
    AMObjectInsertedForReading = 5000,
    AMObjectInsertedForInpsecting = 6000,
    AMObjectInsertedForEditing = 7000,
    AMObjectInsertedForEditingAdvanced = 8000
} AMInsertableObjectState;

@interface AMInsertableObjectView : NSView <NSPasteboardWriting,NSPasteboardReading>
{
    NSColor* _baseColor;
    AMInsertableObjectState _insertionState;

}

@property AMInsertableObjectState insertionState;
@property (readonly) NSColor * backColor;
@property (readonly) NSColor * baseColor;


@end

