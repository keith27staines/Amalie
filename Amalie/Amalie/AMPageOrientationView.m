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
    NSGraphicsContext * context = [NSGraphicsContext currentContext];
    [context saveGraphicsState];
    
    [[NSColor blackColor] set];
    [NSBezierPath strokeRect:self.bounds];
    
    CGFloat size = [NSFont systemFontSize];
    NSFont * font = [NSFont systemFontOfSize:size];
    NSDictionary * attributes = @{NSFontAttributeName: font};
    [_title drawAtPoint:NSZeroPoint withAttributes:attributes];
    
    // Draw paper in white with black border
    [[NSColor whiteColor] set];
    NSRectFill(_paperRect);
    [[NSColor blackColor] set];
    [NSBezierPath strokeRect:_paperRect];

    // Draw margins in mid-blue
    [[NSColor colorWithCalibratedRed:0 green:0.7 blue:1 alpha:1] set];
    NSRect marginsRect = NSMakeRect(_paperRect.origin.x+_margins.left, _paperRect.origin.y + _margins.top, _paperRect.size.width - _margins.left - _margins.right, _paperRect.size.height - _margins.top - _margins.bottom);
    
    // Draw top margin
    [NSBezierPath strokeLineFromPoint:NSMakePoint(_paperRect.origin.x, marginsRect.origin.y) toPoint:NSMakePoint(NSMaxX(_paperRect), marginsRect.origin.y)];
    
    // Draw bottom margin
    [NSBezierPath strokeLineFromPoint:NSMakePoint(_paperRect.origin.x, NSMaxY(marginsRect)) toPoint:NSMakePoint(NSMaxX(_paperRect), NSMaxY(marginsRect))];
    
    // Draw left margin
    [NSBezierPath strokeLineFromPoint:NSMakePoint(marginsRect.origin.x, _paperRect.origin.y) toPoint:NSMakePoint(marginsRect.origin.x, NSMaxY(_paperRect))];

    // Draw right margin
    [NSBezierPath strokeLineFromPoint:NSMakePoint(NSMaxX(marginsRect), _paperRect.origin.y) toPoint:NSMakePoint(NSMaxX(marginsRect), NSMaxY(_paperRect))];
    
    // Draw page dimensions
    
    NSAttributedString * dimensionText;
    NSSize textSize;
    NSPoint textOrigin;
    
    dimensionText = [[NSAttributedString alloc] initWithString:_widthDescription attributes:attributes];
    textSize = [dimensionText size];
    textOrigin = NSMakePoint(_paperRect.origin.x+_paperRect.size.width/2.0, NSMaxY(_paperRect)+textSize.height/2.0);
    
    [self drawText:dimensionText withBasePoint:textOrigin andAngle:0];
    
    dimensionText = [[NSAttributedString alloc] initWithString:_heightDescription attributes:attributes];
    textSize = [dimensionText size];
    CGFloat leading = [font descender];
    textOrigin = NSMakePoint(_paperRect.origin.x-(textSize.height )/2.0 + leading, _paperRect.origin.y +  _paperRect.size.height/2.0);
    [self drawText:dimensionText withBasePoint:textOrigin andAngle:-90];
    
    [context restoreGraphicsState];
}

-(void)drawText:(NSAttributedString*)text
    withBasePoint:(CGPoint)basePoint
         andAngle:(CGFloat)angle
{
    
    NSGraphicsContext * context = [NSGraphicsContext currentContext];
    [context saveGraphicsState];
    
    NSSize  textSize    =   [text size];
    
    NSAffineTransform * t   =   [NSAffineTransform transform];
    [t translateXBy:basePoint.x yBy:basePoint.y];
    
    NSAffineTransform * r = [NSAffineTransform transform];
    [r rotateByDegrees:angle];
    
    [t concat];
    [r concat];
    
    [text drawAtPoint:NSMakePoint(-1 * textSize.width / 2.0, -1 * textSize.height / 2.0)];
    [context restoreGraphicsState];
}

-(void)viewDidMoveToSuperview
{
    [self reloadData];
}

-(void)reloadData
{
    _title = [self.dataSource paperDescription];
    _paperName = [self.dataSource paperName];
    _orientation = [self.dataSource paperOrientation];
    _paperSize = [self.dataSource paperSize];
    _margins = [self.dataSource paperMargins];
    if (_orientation == AMPaperOrientationPortrait) {
        _widthDescription  = [self.dataSource paperWidthDescription];
        _heightDescription = [self.dataSource paperHeightDescription];
    } else {
        CGFloat swap = _paperSize.height;
        _paperSize.height = _paperSize.width;
        _paperSize.width = swap;
        _widthDescription  = [self.dataSource paperHeightDescription];
        _heightDescription = [self.dataSource paperWidthDescription];
    }
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
