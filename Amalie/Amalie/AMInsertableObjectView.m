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
        _baseColor = [NSColor colorWithCalibratedRed:0.8 green:0.6 blue:0.6 alpha:1.0];
        
    }
    
    return self;
}

-(void)setInsertionState:(AMInsertableObjectState)insertionState
{
    _insertionState = insertionState;
}

-(AMInsertableObjectState)insertionState
{
    return _insertionState;
}


-(BOOL)isOpaque
{
    return (self.backColor.alphaComponent == 0) ? NO : YES;
}

-(NSColor*)backColor
{
    switch (self.insertionState) {
        case AMObjectInTray:
        {
            return [NSColor colorWithCalibratedRed:1.0
                                             green:0.8
                                              blue:0.8
                                             alpha:1.0];
            break;
        }
        case AMObjectSelectedInTray:
        {
            return [NSColor colorWithCalibratedRed:0.9
                                                        green:0.7
                                                         blue:0.7
                                                        alpha:1.0];
            break;
        }
        case AMObjectMovingInTray:
        {
            return [NSColor colorWithCalibratedRed:1.0
                                                        green:0.8
                                                         blue:0.8
                                                        alpha:0.5];
            break;
        }
        case AMObjectMovingOutsideOfTray:
        {
            return [NSColor colorWithCalibratedRed:1.0
                                                        green:1.0
                                                         blue:1.0
                                                        alpha:0.5];
            break;
        }
        case AMObjectInsertable:
        {
            return [NSColor colorWithCalibratedRed:1.0
                                                        green:0.8
                                                         blue:0.8
                                                        alpha:0.5];
            
            break;
        }
        case AMObjectInsertedCollapsed:
        {
            break;
        }
        case AMObjectInsertedForReading:
        {
            break;
        }
        case AMObjectInsertedForInpsecting:
        {
            break;
        }
        case AMObjectInsertedForEditing:
        {
            break;
        }
        case AMObjectInsertedForEditingAdvanced:
        {
            break;
        }
            
        default:
            break;
    }
    return nil;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor redColor] set];
    [NSBezierPath fillRect:dirtyRect];
    
    
    // Drawing code here.
//    switch (self.insertionState) {
//        case AMObjectInTray:
//        {
//            break;
//        }
//        case AMObjectMovingInTray:
//        {
//            break;
//        }
//        case AMObjectMovingOutsideOfTray:
//        {
//            break;
//        }
//        case AMObjectInsertable:
//        {
//            break;
//        }
//        case AMObjectInsertedCollapsed:
//        {
//            break;
//        }
//        case AMObjectInsertedForReading:
//        {
//            break;
//        }
//        case AMObjectInsertedForInpsecting:
//        {
//            break;
//        }
//        case AMObjectInsertedForEditing:
//        {
//            break;
//        }
//        case AMObjectInsertedForEditingAdvanced:
//        {
//            break;
//        }
//            
//        default:
//            break;
//    }
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
