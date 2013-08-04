//
//  AMInsertableView.h
//  Amalie
//
//  Created by Keith Staines on 04/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//


#import <Cocoa/Cocoa.h>

// Forward declare
enum AMInsertableType : NSInteger;

// Importing delegate protocols
#import "AMTrayDatasource.h"
#import "AMInsertableViewDelegate.h"

typedef NS_ENUM(NSInteger, AMInsertableViewState) {
    AMObjectNormal             = 0000,
    AMObjectCollapsed          = 1000,
    AMObjectForInpsecting      = 3000,
    AMObjectForEditing         = 4000,
    AMObjectForEditingAdvanced = 5000
};

@interface AMInsertableView : NSView <NSPasteboardWriting,
                                            NSPasteboardReading,
                                            NSCoding,NSDraggingSource>


@property enum AMInsertableType insertableType;
@property AMInsertableViewState objectState;
@property (readonly) NSColor * backColor;
@property (readonly) NSEvent * mouseDownEvent;
@property (readonly) NSPoint mouseDownWindowPoint;
@property (readonly) BOOL isDragging;
@property (readonly) NSImage * dragImage;
@property (readonly) NSString * uuid;

// Frame positioning
@property (readonly) float frameWidth;
@property (readonly) float frameHeight;
@property float frameTop;
@property float frameLeft;
@property float frameBottom;
@property float frameRight;
@property float frameMidY;

@property (weak) IBOutlet NSBox * box;


/*!
 Convenience method, not part of the NSPasteboardWriting protocol, but useful becauser with this class method, no instance of an AMInsertableOjbect needs to be set up in order to setup the drag source.
 */
+(NSArray*)writableTypesForPasteboard:(NSPasteboard *)pasteboard;

/*!
 Designated initializer
 */
- (id)initWithFrame:(NSRect)frame insertableType:(enum AMInsertableType)insertableType;

-(id)initWithInsertableType:(enum AMInsertableType)insertableType;


-(NSString*)trayItemKey;

@property (weak) id <AMTrayDatasource> trayDataSource;
@property (weak) id <AMInsertableViewDelegate> delegate;

/*!
 Sets the receiver's frame's top-left position with the option to animate
 @Param topLeft The required position for the top left hand corner of the frame.
 @Param animate The frame will animate into the required position if set to YES.
 */
-(void)setFrameTopLeft:(NSPoint)topLeft animate:(BOOL)animate;



@end

