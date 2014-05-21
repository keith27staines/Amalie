//
//  AMInspectorsView.m
//  Amalie
//
//  Created by Keith Staines on 18/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMInspectorsView.h"
#import "AMInspectorView.h"
@interface AMInspectorsView()
{
    AMInspectorView * _inspectorView;
}
@property (readonly) AMInspectorView * inspectorView;
@end

@implementation AMInspectorsView

-(BOOL)isFlipped {
    return YES;
}
-(BOOL)isOpaque {
    return YES;
}
- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    [[NSColor colorWithCalibratedRed:0.9 green:0.9 blue:0.9 alpha:1.0] set];
    NSRectFill(self.bounds);
}

-(void)presentInspector:(AMInspectorView*)inspectorView
{
    _inspectorView = inspectorView;
    if (!_inspectorView) {
        [self clearInspector];
        return;
    }
    NSView * header = self.headerView;
    [inspectorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:inspectorView];
    NSDictionary * views = NSDictionaryOfVariableBindings(inspectorView, header);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[inspectorView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[header][inspectorView]|" options:0 metrics:nil views:views]];
    [inspectorView setNeedsDisplay:YES];
}
-(void)clearInspector {
    if (self.inspectorView) {
        [self.inspectorView removeFromSuperview];
        [self setNeedsDisplay:YES];
    }
}

@end
