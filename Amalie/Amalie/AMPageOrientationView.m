//
//  AMPageOrientationView.m
//  Amalie
//
//  Created by Keith Staines on 20/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMPageOrientationView.h"

@interface AMPageOrientationView()
{
    NSString * _title;
    NSString * _paperName;
    NSSize _paperSize;
    AMMargins _margins;
    AMPaperOrientation _orientation;
    AMMeasurementUnits _measurementUnits;
    NSString * _widthDescription;
    NSString * _heightDescription;
    NSRect _paperRect;
}
@property (copy) NSString * paperName;
@property NSSize paperSize;
@property AMMargins margins;
@property AMPaperOrientation orientation;
@property AMMeasurementUnits measurementUnits;
@end

@implementation AMPageOrientationView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    
        
    }
    return self;
}
-(BOOL)isFlipped
{
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor colorWithCalibratedRed:0.8 green:0.8 blue:0.8 alpha:1] set];
    NSRectFill(self.bounds);
    CGFloat size = [NSFont systemFontSize];
    NSFont * font = [NSFont systemFontOfSize:size];
    [_title drawAtPoint:NSZeroPoint withAttributes:@{NSFontAttributeName: font}];
    [[NSColor whiteColor] set];
    NSRectFill(_paperRect);
    NSRect marginsRect = NSMakeRect(_paperRect.origin.x+_margins.left, _paperRect.origin.y + _margins.top, _paperRect.size.width - _margins.left - _margins.right, _paperRect.size.height - _margins.top - _margins.bottom);
    [[NSColor blueColor] set];
    [NSBezierPath strokeRect:marginsRect];
}
-(void)viewDidMoveToSuperview
{
    [self reloadData];
}

-(void)reloadData
{
    _title = [self.datasource paperDescription];
    _paperName = [self.datasource paperName];
    _orientation = [self.datasource paperOrientation];
    _paperSize = [self.datasource paperSize];
    _margins = [self.datasource paperMargins];
    if (_orientation == AMPaperOrientationLandscape) {
        CGFloat swap = _paperSize.height;
        _paperSize.height = _paperSize.width;
        _paperSize.width = swap;
    }
    _widthDescription  = [self.datasource paperWidthDescription];
    _heightDescription = [self.datasource paperHeightDescription];
    CGFloat bw = self.bounds.size.width;
    CGFloat bh = self.bounds.size.height;
    CGFloat bar = bw / bh;

    CGFloat pw = _paperSize.width;
    CGFloat ph = _paperSize.height;
    CGFloat par = pw / ph;
    CGFloat sf;
    if (par > bar) {
        // size of paper visual is limited by width of container
        sf = 0.7 * bw / pw;
        pw = 0.7 * bw;
        ph = pw / par;
    } else {
        // size of paper visual is limited by height of container
        sf = 0.7 * bh / ph;
        ph = 0.7 * bh;
        pw = ph * par;
    }
    _paperRect = NSMakeRect((bw-pw)/2.0, (bh-ph)/2.0, pw, ph);
    _margins.top *= sf;
    _margins.bottom *= sf;
    _margins.left *= sf;
    _margins.right *= sf;
    [self setNeedsDisplay:YES];
}

@end
