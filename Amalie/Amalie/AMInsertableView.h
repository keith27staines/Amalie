//
//  AMInsertableView.h
//  Amalie
//
//  Created by Keith Staines on 04/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

// Forward declare

enum AMInsertableType : NSInteger;

#import <Cocoa/Cocoa.h>

// Importing delegate protocols
#import "AMGroupedView.h"
#import "AMTrayDatasource.h"
#import "AMInsertableViewDelegate.h"

typedef NS_ENUM(NSInteger, AMInsertViewState) {
    AMInsertViewStateNormal                    = 0000,
    AMInsertViewStateSelected                  = 1000,
    AMInsertViewStateEditing                   = 4000,
    AMInsertViewStateNormalEditingAdvanced     = 5000,
};

@interface AMInsertableView : AMGroupedView
<
NSPasteboardWriting,
NSPasteboardReading,
NSCoding,
NSDraggingSource
>


@property enum AMInsertableType insertableType;
@property AMInsertViewState viewState;
@property (readonly) NSColor * backColor;
@property (readonly) NSEvent * mouseDownEvent;
@property (readonly) NSPoint mouseDownOffsetFromOrigin;
@property (readonly) BOOL isDragging;
@property (readonly) NSImage * dragImage;
@property (weak, readonly)AMContentView * contentView;

// Frame positioning
@property (readonly) float frameWidth;
@property (readonly) float frameHeight;
@property float frameTop;
@property float frameLeft;
@property float frameBottom;
@property float frameRight;
@property float frameMidY;

@property (weak) id <AMTrayDataSource> trayDataSource;
@property (weak) id <AMInsertableViewDelegate> delegate;

- (IBAction)closeButtonClicked:(NSButton *)sender;

@property (weak) IBOutlet NSButton *closeButton;

/*!
 Convenience method, not part of the NSPasteboardWriting protocol, but useful becauser with this class method, no instance of an AMInsertableOjbect needs to be set up in order to setup the drag source.
 */
+(NSArray*)writableTypesForPasteboard:(NSPasteboard *)pasteboard;

/*!
 Designated initializer
 */
- (id)initWithFrame:(NSRect)frame
            groupID:(NSString *)groupID
     insertableType:(enum AMInsertableType)insertableType;

-(id)initWithInsertableType:(enum AMInsertableType)insertableType;


-(NSString*)trayItemKey;

/*!
 Sets the receiver's frame's top-left position with the option to animate
 @Param topLeft The required position for the top left hand corner of the frame.
 @Param animate The frame will animate into the required position if set to YES.
 */
-(void)setFrameTopLeft:(NSPoint)topLeft animate:(BOOL)animate;



@end

