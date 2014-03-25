//
//  AMDocumentView.m
//  Amalie
//
//  Created by Keith Staines on 06/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMDocumentView.h"
#import "AMWorksheetView.h"
#import "AMAppController.h"
#import "AMAmalieDocument.h"

@interface AMDocumentView()
{
    __weak AMAppController  * _appController;
    __weak AMAmalieDocument * _amalieDocument;
    NSMutableArray * _worksheets;
}
@end

@implementation AMDocumentView

- (id)initWithAppController:(AMAppController*)appController amalieDocument:(AMAmalieDocument*)amalieDocument;
{
    self = [super init];
    if (self) {
        _amalieDocument = amalieDocument;
        _appController = appController;
        _backgroundColor = [NSColor colorWithCalibratedRed:0.65 green:0.72 blue:0.51 alpha:1];
        [self addWorksheetView];
    }
    return self;
}
- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor colorWithCalibratedRed:0.65 green:0.72 blue:0.51 alpha:1] set];
    NSRectFill(dirtyRect);
}
-(BOOL)isOpaque
{
    return NO;
}
-(BOOL)isFlipped
{
    return YES;
}
-(NSMutableArray *)worksheets
{
    if (!_worksheets) {
        _worksheets = [NSMutableArray array];
    }
    return _worksheets;
}
-(AMWorksheetView*)addWorksheetView
{
    AMWorksheetView * worksheet = [[AMWorksheetView alloc] init];
    self.amalieDocument.worksheetView = worksheet;
    worksheet.delegate = self.amalieDocument;
    worksheet.libraryDataSource = self.appController;
    [worksheet setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:worksheet];
    [self.worksheets addObject:worksheet];
    [worksheet setNeedsUpdateConstraints:YES];
    [worksheet setNeedsDisplay:YES];
    [self setNeedsUpdateConstraints:YES];
    [self setNeedsDisplay:YES];
    return worksheet;
}
-(void)updateConstraints
{
    [super updateConstraints];
    [self removeConstraints:self.constraints];
    NSArray * constraints;
    NSDictionary * views;
    AMWorksheetView * previous;
    for (AMWorksheetView * worksheet in self.worksheets) {
        if (!previous) {
            views = NSDictionaryOfVariableBindings(worksheet);
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[worksheet]" options:0 metrics:nil views:views];
            [self addConstraints:constraints];
        } else {
            views = NSDictionaryOfVariableBindings(previous,worksheet);
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[previous]-5-[worksheet]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views];
            [self addConstraints:constraints];
        }
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[worksheet]-(>=0)-|" options:0 metrics:nil views:views];
        [self addConstraints:constraints];
        previous = worksheet;
    }
    views = NSDictionaryOfVariableBindings(previous);
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[previous]-(>=0)-|" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    NSLayoutConstraint * constraint;
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:previous attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self addConstraint:constraint];
}

@end
