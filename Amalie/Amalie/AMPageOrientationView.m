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
    [self setNeedsDisplay:YES];
}

@end
