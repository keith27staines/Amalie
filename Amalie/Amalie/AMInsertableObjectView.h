//
//  AMInsertableObjectView.h
//  Amalie
//
//  Created by Keith Staines on 04/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//


#import <Cocoa/Cocoa.h>

// Forward declare
enum AMInsertableType : NSUInteger;

// Importing delegate protocols
#import "AMTrayDatasource.h"
#import "AMInsertableObjectViewDelegate.h"

typedef NS_ENUM(NSInteger, AMInsertableObjectState) {
    AMObjectNormal             = 0000,
    AMObjectCollapsed          = 1000,
    AMObjectForInpsecting      = 3000,
    AMObjectForEditing         = 4000,
    AMObjectForEditingAdvanced = 5000
};

@interface AMInsertableObjectView : NSView <NSPasteboardWriting,
                                            NSPasteboardReading,
                                            NSCoding>


@property enum AMInsertableType insertableType;
@property AMInsertableObjectState objectState;
@property (readonly) NSColor * backColor;
@property NSEvent * mouseDownEvent;
@property NSPoint mouseDownWindowPoint;
@property (readonly) BOOL isDragging;
@property (readonly) NSImage * dragImage;
@property float frameTop;
@property float frameLeft;
@property float frameBottom;
@property float frameRight;
@property float frameMidY;
@property (readonly) float frameWidth;
@property (readonly) float frameHeight;
@property NSString * uuid;

/*!
 Convenience method, not part of the NSPasteboardWriting protocol, but useful. With this class method, no instance of an AMInsertableOjbect needs to be set up in order to setup the drag source.
 */
+(NSArray*)writableTypesForPasteboard:(NSPasteboard *)pasteboard;

/*!
 Designated initializer
 */
- (id)initWithFrame:(NSRect)frame insertableType:(enum AMInsertableType)insertableType;

-(id)initWithInsertableType:(enum AMInsertableType)insertableType;


// Must override this in subclasses, since there will be one subclass for each tray item
-(NSString*)trayItemKey;

@property id <AMTrayDatasource> trayDataSource;
@property id <AMInsertableObjectViewDelegate> insertableObjectDelegate;

-(void)setFrameTopLeft:(NSPoint)topLeft animate:(BOOL)animate;



@end

