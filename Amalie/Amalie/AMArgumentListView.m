//
//  AMArgumentListView.m
//  Amalie
//
//  Created by Keith Staines on 08/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMArgumentListView.h"

@interface AMArgumentListView()
{

}

@end

@implementation AMArgumentListView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(BOOL)translatesAutoresizingMaskIntoConstraints
{
    return NO;
}

-(BOOL)readOnly
{
    return !self.textField.isEditable;
}

-(void)setReadOnly:(BOOL)readOnly
{
    [self.textField setEditable:!readOnly];
}

-(void)reloadData
{
    NSFont * bracesFont = [self.delegate bracesFont];
    self.leftBrace.stringValue = @"(";
    self.rightBrace.stringValue = @")";
    [self.leftBrace setFont:bracesFont];
    [self.rightBrace setFont:bracesFont];
    [self.textField setFont:bracesFont];
    NSMutableAttributedString * displayString;
    NSAttributedString * comma = [[NSAttributedString alloc] initWithString:@" , " attributes:nil];
    NSUInteger stringCount = self.delegate.displayStringCount;
    
    if (stringCount == 0) {
        displayString = [[NSMutableAttributedString alloc] initWithString:@" " attributes:nil];
    } else {
        displayString = [[NSMutableAttributedString alloc] init];
    }
    
    for (NSUInteger i = 0; i < stringCount; i++) {
        [displayString appendAttributedString:[self.delegate displayStringForIndex:i]];
        
        if (i < stringCount - 1) {
            [displayString appendAttributedString:comma];
        }
    }
    self.textField.attributedStringValue = displayString;
    
    if (self.autoFitContent) {
        [self.textField setFrameSize:self.textField.fittingSize];
    }

}

-(void)awakeFromNib
{
    self.readOnly = YES;
    self.autoFitContent = YES;
    self.textField.delegate = self.delegate;
    [self reloadData];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
}



@end
