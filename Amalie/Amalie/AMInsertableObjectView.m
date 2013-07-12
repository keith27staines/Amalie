//
//  AMInsertableObjectView.m
//  Amalie
//
//  Created by Keith Staines on 04/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMInsertableObjectView.h"


@implementation AMInsertableObjectView

-(id)initWithPasteboardPropertyList:(id)propertyList ofType:(NSString *)type
{
    return [self initWithFrame:NSMakeRect(0, 0, 100, 50)];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
    }
    
    return self;
}

-(NSInteger)trayIndex
{
    return -1;  // MUST override!
}

-(void)setObjectState:(AMInsertableObjectState)objectState
{
    _objectState = objectState;
}

-(AMInsertableObjectState)objectState
{
    return _objectState;
}

-(BOOL)isOpaque
{
    return (self.backColor.alphaComponent == 0) ? NO : YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    AMTrayItem * item = [self.trayDataSource trayItemAtIndex:self.trayIndex];
    [item.backgroundColor set];
    [NSBezierPath fillRect:dirtyRect];
}

-(NSArray*)writableTypesForPasteboard:(NSPasteboard *)pasteboard
{
    return [self.class readableTypesForPasteboard:pasteboard];
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
    return @[utiString ];
}

+(NSPasteboardReadingOptions)readingOptionsForType:(NSString *)type pasteboard:(NSPasteboard *)pasteboard
{
    return NSPasteboardReadingAsString;
}

-(id)pasteboardPropertyListForType:(NSString *)type
{
    return [self className];
}

@end
