//
//  AMInsertableView.m
//  Amalie
//
//  Created by Keith Staines on 04/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "QuartzCore/QuartzCore.h"
#import "AMConstants.h"
#import "AMInsertableView.h"
#import "AMTrayItem.h"
#import "AMContentView.h"
#import "AMInsertableViewController.h"

static NSString * const kAMDraggedInsertableView = @"kAMDraggedInsertableView";
static BOOL LOG_DRAG_OPS = NO;

static CABasicAnimation * animateOrigin;

@interface AMInsertableView()
{
    AMInsertViewState       _viewState;
    AMInsertableType        _insertableType;
    BOOL                    _mouseOver;
}
@property (readwrite) NSEvent * mouseDownEvent;
@property (readwrite) NSPoint mouseDownOffsetFromOrigin;

@end

@implementation AMInsertableView

#pragma mark - Initializers -


- (id)initWithFrame:(NSRect)frame groupID:(NSString *)groupID
{
    return [self initWithFrame:frame
                       groupID:groupID
                insertableType:AMInsertableTypeConstant];
}

-(id)initWithInsertableType:(AMInsertableType)insertableType
{
    return [self initWithFrame:am_defaultRect()
                       groupID:nil
                insertableType:insertableType];
}

- (id)initWithFrame:(NSRect)frame
            groupID:(NSString*)groupID
     insertableType:(AMInsertableType)insertableType
{
    if (frame.size.height == 0) frame = am_defaultRect();

    self = [super initWithFrame:frame groupID:groupID];
    if (self) {
        _mouseDownOffsetFromOrigin = self.frame.origin;
        _insertableType = insertableType;
    }
    return self;
}

-(void)viewDidMoveToWindow
{
    _contentView = [self.delegate insertableView:self
                       requiresContentViewOfType:self.insertableType];

    // Add a tracking area so that inserted views know when the mouse is over them
    NSUInteger taOptions = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways;
    [self addSubview:_contentView];
    NSTrackingArea * ta = [[NSTrackingArea alloc] initWithRect:NSZeroRect
                                                       options:taOptions
                                                         owner:self userInfo:nil];
    [self addTrackingArea:ta];
}

#pragma mark - State -

-(NSString*)trayItemKey
{
    switch (self.insertableType) {
        case AMInsertableTypeConstant           : return kAMConstantKey;
        case AMInsertableTypeVariable           : return kAMVariableKey;
        case AMInsertableTypeExpression         : return kAMExpressionKey;
        case AMInsertableTypeFunction           : return kAMFunctionKey;
        case AMInsertableTypeEquation           : return kAMEquationKey;
        case AMInsertableTypeVector             : return kAMVectorKey;
        case AMInsertableTypeMatrix             : return kAMMatrixKey;
        case AMInsertableTypeMathematicalSet    : return kAMMathematicalSetKey;
        case AMInsertableTypeGraph2D            : return kAMGraph2DKey;
    }
    return nil;
}

-(BOOL)autoresizesSubviews
{
    return NO;
}

-(void)setViewState:(AMInsertViewState)state
{
    _viewState = state;
    [self setNeedsDisplay:YES];
}

-(AMInsertViewState)viewState
{
    return _viewState;
}

#pragma mark - Drawing -

-(BOOL)isOpaque
{
    if (self.viewState == AMInsertViewStateNormal) return YES;
    return NO;
}

- (void)drawRect:(NSRect)dirtyRect
{
    if ( ![NSGraphicsContext currentContextDrawingToScreen] ) {
        // The inserted view itself just contains artefacts related to the gui. If the user is printing, these are of no interest.
        return;
    }
    
    [NSGraphicsContext saveGraphicsState];

    [self drawClear];
    
    if (_mouseOver || self.viewState > AMInsertViewStateNormal) {
        [self drawFrame];
    }
    
    if (self.viewState > AMInsertViewStateNormal) {
        [self drawShadow];
    }

    
    [NSGraphicsContext restoreGraphicsState];
    [super drawRect:dirtyRect];
}

-(void)drawClear
{
    [self.closeButton setHidden:YES];
    [self setShadow:nil];
    if (self.viewState == AMInsertViewStateNormal) {
        [[NSColor whiteColor] set];
    } else {
        [[NSColor colorWithCalibratedRed:1 green:1 blue:1 alpha:0] set];
    }
    NSRectFill(self.bounds);
}

/*!
 Draws the "window-like" frame around the inserted view
 */
-(void)drawFrame
{
    [[self backColor] set];
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path appendBezierPathWithRoundedRect:NSInsetRect(self.bounds, 0.0, 0.0) xRadius:6 yRadius:6];
    [path fill];
    
    if (self.viewState > AMInsertViewStateNormal) {
        [self.closeButton setHidden:NO];
        [[NSColor blackColor] set];
        path = [NSBezierPath bezierPath];
        [path appendBezierPathWithRoundedRect:NSInsetRect(self.bounds, 0, 0) xRadius:6 yRadius:6];
        [path stroke];
    }
    
}

-(void)drawShadow
{
    static NSShadow * shadow = nil;
    if (!shadow) {
        shadow = [[NSShadow alloc] init];
        [shadow setShadowBlurRadius:5];
        [shadow setShadowColor:[NSColor blackColor]];
        [shadow setShadowOffset:NSMakeSize(5, -5)];
    }
    self.shadow = shadow;
}

-(NSColor*)backColor
{
    AMTrayItem * trayItem = [self.trayDataSource trayItemWithKey:[self trayItemKey]];
    return [trayItem backgroundColor];
}

#pragma mark - Archiving support -

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (self.frame.size.height == 0) {
            self.frame = am_defaultRect();
        }
        // Need to be careful here, we are using a view controller to get a new, fully hooked-up view from the nib, and we will eventually return that, but we have to make sure that properties already initialized in the call to super are copied across - especially groupID
        AMInsertableViewController * vc = [[AMInsertableViewController alloc] init];
        AMInsertableView * view = (AMInsertableView*)[vc view];
        view.frame   = self.frame;
        view.groupID = self.groupID;
        
        // can now abandon the current instance of self and swap to the view from the NIB
        self = view;
        _isDragging = [aDecoder decodeBoolForKey:@"isDragging"];
        _mouseDownOffsetFromOrigin = [aDecoder decodePointForKey:@"mouseDownOffsetFromOrigin"];
        _insertableType = [aDecoder decodeIntegerForKey:@"insertableType"];
        
        if ( [aDecoder containsValueForKey:@"dragImage"] ) {
            _dragImage = [aDecoder decodeObjectForKey:@"dragImage"];
        }
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeBool:self.isDragging forKey:@"isDragging"];
    [aCoder encodePoint:self.mouseDownOffsetFromOrigin forKey:@"mouseDownOffsetFromOrigin"];
    [aCoder encodeInteger:self.insertableType forKey:@"insertableType"];
    
    if (_dragImage) {
        [aCoder encodeObject:self.dragImage forKey:@"dragImage"];
    }
}

#pragma mark - Pasteboard support -

+(NSArray*)writableTypesForPasteboard:(NSPasteboard *)pasteboard
{
    return [self.class readableTypesForPasteboard:pasteboard];
}

-(NSArray*)writableTypesForPasteboard:(NSPasteboard *)pasteboard
{
    return [self.class writableTypesForPasteboard:pasteboard];
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

#pragma mark - NSDraggingSource -

-(NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)flag
{
    if (LOG_DRAG_OPS) NSLog(@"%@ - draggingSourceOperationMaskForLocal:",[self class]);
    return NSDragOperationMove | NSDragOperationDelete;
}

-(void)draggingSession:(NSDraggingSession*)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation
{
    if (LOG_DRAG_OPS) NSLog(@"%@ - draggingSession:endedAtPoint:operation:",[self class]);
    
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

- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context
{
    if (LOG_DRAG_OPS) NSLog(@"%@ - draggingSession:sourceOperationMaskForDraggingContext:",[self class]);
    switch(context) {
        case NSDraggingContextOutsideApplication:
            return NSDragOperationNone;
            break;
            
        case NSDraggingContextWithinApplication:
            return NSDragOperationMove;
            
        default:
            return NSDragOperationNone;
            break;
    }
}

- (void)draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint
{
    if (LOG_DRAG_OPS) NSLog(@"%@ - draggingSession:willBeginAtPoint:",[self class])
    ;
}

-(void)concludeDragging
{
    // restore previous cursor
    [NSCursor pop];
    [[self window] invalidateCursorRectsForView:self];
    
    // self.mouseDownEvent = nil;
    self.mouseDownEvent = nil;
    self.mouseDownOffsetFromOrigin = self.frame.origin;
    _dragImage = nil;
    _isDragging = NO;
    [self setHidden:NO];
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

-(void)closeButtonClicked:(NSButton *)sender
{
    [self.delegate insertableViewWantsRemoval:self];
}

-(void)mouseDown:(NSEvent *)theEvent
{
    if (LOG_DRAG_OPS) NSLog(@"%@ - mouseDown",[self class]);
 
    [self.delegate insertableViewReceivedClick:self];
    self.mouseDownEvent = theEvent;
    NSPoint theLocationInWindow = [theEvent locationInWindow];
    NSPoint theMouseDownOffsetFromOrigin = [self convertPoint:theLocationInWindow fromView:nil];
    self.mouseDownOffsetFromOrigin = theMouseDownOffsetFromOrigin;
    [[NSCursor closedHandCursor] push];
}

-(void)mouseDragged:(NSEvent *)theEvent
{
    if (LOG_DRAG_OPS) NSLog(@"%@ - mouseDragged:",[self class]);
    
    NSPoint currentPoint = [theEvent locationInWindow];           // in window coords
    currentPoint = [self convertPoint:currentPoint fromView:nil]; // now in view coords
    
    if ( am_pointsAreClose(self.mouseDownOffsetFromOrigin, currentPoint) )
    {
        _isDragging = NO;
        return;
    }
    
    if (!self.isDragging) {
        _isDragging = YES;
        _dragImage = [self makeImageSnapshot];
    }
    
    NSPoint originPoint = NSMakePoint(0, 0);
    
    // start the drag
    NSPasteboard * pb = [NSPasteboard pasteboardWithName:NSDragPboard];
    [pb clearContents];
    [pb declareTypes:[self readableTypesForPasteBoard:pb] owner:self];
    if ( [pb writeObjects:@[self] ] ) {
        [self dragImage:_dragImage at:originPoint offset:NSZeroSize event:self.mouseDownEvent pasteboard:pb source:self slideBack:YES];
    } else NSAssert(NO, @"Failed to write to pasteboard");
}


-(void)mouseUp:(NSEvent *)theEvent
{
    if (LOG_DRAG_OPS) NSLog(@"%@ - mouseUp",[self class]);
    [self concludeDragging];
}

-(void)mouseEntered:(NSEvent *)theEvent
{
    _mouseOver = YES;
    [self setNeedsDisplay:YES];
}

-(void)mouseExited:(NSEvent *)theEvent
{
    _mouseOver = NO;
    [self setNeedsDisplay:YES];
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
        [self setWantsLayer:YES];
        CABasicAnimation * anim = [self originAnimation];
        [anim setFromValue:[NSValue valueWithPoint:self.frame.origin]];
        [anim setToValue:[NSValue valueWithPoint:newOrigin]];
        [self setAnimations:@{@"frameOrigin": anim}];
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

#pragma mark - Animation -

-(CABasicAnimation *)originAnimation
{
    if (!animateOrigin) {
        animateOrigin = [CABasicAnimation animation];
        CAMediaTimingFunction * timing = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [animateOrigin setTimingFunction:timing];
        [animateOrigin setDuration:0.5f];
    }
    return animateOrigin;
}

@end
