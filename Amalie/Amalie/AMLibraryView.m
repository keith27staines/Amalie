//
//  AMLibraryView.m
//  Amalie
//
//  Created by Keith Staines on 31/01/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMLibraryView.h"
#import "AMConstants.h"

@implementation AMLibraryView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)awakeFromNib
{
    // Constrain width to be between minimum and maximimum allowed values
    [self.tableView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:kAMLibraryWidth]];

    // setup the table to be a drag source
    [self.tableView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:YES];
    [self.tableView setDraggingSourceOperationMask:NSDragOperationNone forLocal:NO];
    [self.tableView setVerticalMotionCanBeginDrag:YES];
    [self.tableView reloadData];
}
-(void)drawRect:(NSRect)dirtyRect
{
[[NSColor whiteColor] set];
NSRectFill(self.bounds);
}

-(BOOL)isFlipped
{
    return YES;
}

@end
