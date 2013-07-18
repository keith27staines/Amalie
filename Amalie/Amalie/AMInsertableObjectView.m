//
//  AMInsertableObjectView.m
//  Amalie
//
//  Created by Keith Staines on 04/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@import QuartzCore;

#import "AMTrayItem.h"
#import "AMInsertableObjectView.h"

float const kAMSMallDistance = 3.0f;

@implementation AMInsertableObjectView

#pragma mark - Initializers -

NSString * const kFrameKey = @"AMFrameKey";
NSString * const kAMDraggedInsertableObject = @"kAMDraggedInsertableObject";

-(id)initWithPasteboardPropertyList:(id)propertyList ofType:(NSString *)type
{
    return [self initWithFrame:defaultRect()];
}

-(id)init
{
    return [self initWithFrame:defaultRect()];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _uuid = @"";
    }
    
    return self;
}

#pragma mark - State -

-(NSString*)trayItemKey
{
    [NSException raise:@"Subclasses must override this method." format:nil];
    return nil;  // MUST override!
}

-(void)setObjectState:(AMInsertableObjectState)objectState
{
    _objectState = objectState;
}

-(AMInsertableObjectState)objectState
{
    return _objectState;
}

#pragma mark - Drawing -

-(BOOL)isOpaque
{
    return (self.backColor.alphaComponent == 0) ? NO : YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    AMTrayItem * item = [self.trayDataSource trayItemWithKey:[self trayItemKey]];
    [item.backgroundColor set];
    [NSBezierPath fillRect:dirtyRect];
    [self drawFocusRing];
}

-(void)drawFocusRing
{
    if ( ( [self.window firstResponder] == self ) && [NSGraphicsContext currentContextDrawingToScreen]) {
        [NSGraphicsContext saveGraphicsState];
        NSSetFocusRingStyle( NSFocusRingOnly );
        [NSBezierPath fillRect:self.bounds];
        [NSGraphicsContext restoreGraphicsState];
    }
}

#pragma mark - Archiving support -

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (self.frame.size.height == 0) {
            self.frame = defaultRect();
        }
        
        _uuid = [aDecoder decodeObjectForKey:@"uuid"];
        _isDragging = [aDecoder decodeBoolForKey:@"isDragging"];
        
        if ( [aDecoder containsValueForKey:@"dragImage"] ) {
            _dragImage = [aDecoder decodeObjectForKey:@"dragImage"];
        }
        
    }
    return self;
}

-(void)viewDidMoveToWindow
{
    static BOOL previouslyEntered = NO;
    
    if ( !previouslyEntered ) {
        previouslyEntered = YES;

        [self setWantsLayer:YES];
        
    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
    [aCoder encodeBool:self.isDragging forKey:@"isDragging"];
    
    if (_dragImage) {
        [aCoder encodeObject:self.dragImage forKey:@"dragImage"];
    }
}

#pragma mark - Pasteboard support -

-(NSArray*)writableTypesForPasteboard:(NSPasteboard *)pasteboard
{
    return [self.class readableTypesForPasteboard:pasteboard];
}

-(BOOL)writeToPasteboard:(NSPasteboard *)pb
{
    [pb clearContents];
    return [pb writeObjects:@[ [NSKeyedArchiver archivedDataWithRootObject:self] ]];
}

-(BOOL)readFromPastebard:(NSPasteboard*)pb
{
    NSArray * objects = [pb readObjectsForClasses:[self writableTypesForPasteboard:pb] options:nil];
    if ( [objects count] > 0) {
        return YES;
    }
    return NO;
}

+(NSArray*)readableTypesForPasteboard:(NSPasteboard *)pasteboard
{
    NSString * className = NSStringFromClass(self);
    
    CFStringRef cfName = (CFStringRef)CFBridgingRetain(className);
    CFStringRef uti;
    uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassNSPboardType,
                                                cfName,
                                                kUTTagClassNSPboardType);
    CFRelease(cfName);
    
    NSString * utiString = (NSString*)CFBridgingRelease(uti);
    return @[utiString];
}

-(NSArray*)readableTypesForPasteBoard:(NSPasteboard*)pb
{
    return [self.class readableTypesForPasteboard:pb];
}

+(NSPasteboardReadingOptions)readingOptionsForType:(NSString *)type pasteboard:(NSPasteboard *)pasteboard
{
    return NSPasteboardReadingAsKeyedArchive;
}

-(id)pasteboardPropertyListForType:(NSString *)type
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

-(NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)flag
{
    return NSDragOperationMove | NSDragOperationDelete;
}


#pragma mark - Event handling -

-(BOOL)acceptsFirstResponder
{
    return YES;
}

-(BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
    return YES;
}

-(void)draggedImage:(NSImage *)image endedAt:(NSPoint)screenPoint operation:(NSDragOperation)operation
{
    NSLog(@"%@ - draggedImage",[self class]);
 
    switch (operation) {
        case NSDragOperationDelete:
            // Remove object by calling controller
            break;

        case NSDragOperationMove:
            // We've already been moved by the handler in the parent worksheetView
            [self concludeDragging];
        
        case NSDragOperationNone:
            // something cancelled the drag
            [self concludeDragging];
            
            break;
        default:
            [self concludeDragging];
            break;
    }
}


-(BOOL)becomeFirstResponder
{
    [self setNeedsDisplay:YES];
    return YES;
}

-(BOOL)resignFirstResponder
{
    [self setNeedsDisplay:YES];
    return YES;
}

-(void)mouseDown:(NSEvent *)theEvent
{
    self.mouseDownEvent = theEvent;
}

-(void)mouseUp:(NSEvent *)theEvent
{
    NSLog(@"%@ - mouseUp",[self class]);
}

-(void)concludeDragging
{
    // restore previous cursor
    [NSCursor pop];
    
    // the item has moved, we need to reset our cursor rectangle
    [self.insertableObjectDelegate draggingDidEnd];
    
    self.mouseDownEvent = nil;
    _dragImage = nil;
    _isDragging = NO;
    [self setHidden:NO];
}

-(void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint originalPoint = [self.mouseDownEvent locationInWindow];
    NSPoint currentPoint = [theEvent locationInWindow];

    if ( pointsAreClose(originalPoint, currentPoint) )
    {
        _isDragging = NO;
        return;
    }
    
    if (!self.isDragging) {
        _isDragging = YES;
        _dragImage = [self makeImageSnapshot];
        
    }
    
    [self.insertableObjectDelegate draggingDidStart];
    [self setHidden:YES];
    
    originalPoint = NSMakePoint(0, 0);
    
    // start the drag
    NSPasteboard * pb = [NSPasteboard pasteboardWithName:NSDragPboard];
    [pb clearContents];
    [pb declareTypes:[self readableTypesForPasteBoard:pb] owner:self];
    if ( [pb writeObjects:@[self] ] ) {
        [self dragImage:_dragImage at:originalPoint offset:NSZeroSize event:self.mouseDownEvent pasteboard:pb source:self slideBack:YES];
    } else NSAssert(NO, @"Failed to write to pasteboard");
}


/*!
 * draws a snapshot of the receiver into the image (useful for setting the image
 * in drag and drop operations).
 * Returns the image holding the view's snapshot.
 */
- (NSImage *)makeImageSnapshot {
    
    NSSize imgSize = self.bounds.size;
    
    NSBitmapImageRep * bir = [self bitmapImageRepForCachingDisplayInRect:[self bounds]];
    [bir setSize:imgSize];
    
    [self cacheDisplayInRect:[self bounds] toBitmapImageRep:bir];
    
    NSImage* image = [[NSImage alloc] initWithSize:imgSize];
    [image addRepresentation:bir];

    return image;
}

#pragma mark - positioning -
-(float)frameWidth
{
    return self.frame.size.width;
}
-(float)frameHeight
{
    return self.frame.size.height;
}

-(float)frameTop
{
    return self.frame.origin.y + self.frameHeight;
}
-(float)frameBottom
{
    return self.frame.origin.y;
}
-(float)frameLeft
{
    return self.frame.origin.x;
}
-(float)frameRight
{
    return self.frameLeft + self.frameWidth;
}
-(float)frameMidY
{
    return (self.frameBottom + self.frameTop) / 2.0f;
}
-(void)setFrameMidY:(float)frameMidY
{
    [self setFrameBottom:(self.frameHeight - self.frameHeight/2.0f )];
}

-(NSPoint)frameTopLeft
{
    return NSMakePoint(self.frameLeft, self.frameTop);
}

-(void)setFrameTopLeft:(NSPoint)topLeft animate:(BOOL)animate;
{
    NSPoint newOrigin = NSMakePoint(topLeft.x, topLeft.y - self.frameHeight);
    if (animate) {
        [[self animator] setFrameOrigin:newOrigin];
    } else {
        [self setFrameOrigin:newOrigin];
    }
}


-(void)setFrameTop:(float)top
{
    [self setFrameOrigin:NSMakePoint(self.frameLeft, top - self.frameHeight)];
}

-(void)setFrameBottom:(float)bottom
{
    [self setFrameOrigin:NSMakePoint(self.frameLeft, bottom)];
}

-(void)setFrameLeft:(float)left
{
    [self setFrameOrigin:NSMakePoint(left, self.frameBottom)];
}
-(void)setFrameRight:(float)right
{
    [self setFrameOrigin:NSMakePoint(self.frameBottom, right - self.frameWidth)];
}



#pragma mark - Helper C functions -

NSRect defaultRect() { return NSMakeRect(0, 0, 100, 50); }

float hypotenuse(float x1, float y1, float x2, float y2)
{
    return sqrtf( (x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2) );
}

bool pointsAreClose(NSPoint p, NSPoint q)
{
    float h = hypotenuse(p.x, p.y, q.x, q.y);
    return (h < kAMSMallDistance) ? true : false;
}

@end
