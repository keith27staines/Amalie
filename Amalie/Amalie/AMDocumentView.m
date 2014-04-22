//
//  AMDocumentView.m
//  Amalie
//
//  Created by Keith Staines on 06/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMDocumentView.h"
#import "AMPageView.h"
#import "AMAppController.h"
#import "AMAmalieDocument.h"
#import "AMPersistentDocumentSettings.h"
#import "AMColorSettings.h"

@interface AMDocumentView()
{
    __weak AMAppController  * _appController;
    __weak AMAmalieDocument * _amalieDocument;
    NSMutableArray * _pageViews;
}
@end

@implementation AMDocumentView

- (id)initWithAppController:(AMAppController*)appController amalieDocument:(AMAmalieDocument*)amalieDocument;
{
    self = [super init];
    if (self) {
        _amalieDocument = amalieDocument;
        _appController = appController;
        [self applyUserPreferences];
        [self reloadData];
    }
    return self;
}
- (void)drawRect:(NSRect)dirtyRect
{
    [_backgroundColor set];
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
-(NSMutableArray *)pageViews
{
    if (!_pageViews) {
        _pageViews = [NSMutableArray array];
    }
    return _pageViews;
}
-(void)applyUserPreferences
{
    _backgroundColor =  _amalieDocument.documentSettings.colorSettings.backColorForDocumentBackground;
    for ( AMPageView* view in self.pageViews) {
        [view applyUserPreferences];
    }
    [self setNeedsDisplay:YES];
}
-(void)reloadData
{
    if (self.pageViews.count == 0) {
        [self addPageView];
    }
    [self setNeedsDisplay:YES];
}
-(AMPageView*)addPageView
{
    AMPageView * pageView = [[AMPageView alloc] init];
    self.amalieDocument.pageView = pageView;
    pageView.delegate = self.amalieDocument;
    pageView.libraryDataSource = self.appController;
    [pageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:pageView];
    [self.pageViews addObject:pageView];
    [pageView applyUserPreferences];
    [pageView setNeedsUpdateConstraints:YES];
    [pageView setNeedsDisplay:YES];
    [self setNeedsUpdateConstraints:YES];
    [self setNeedsDisplay:YES];
    return pageView;
}
-(void)updateConstraints
{
    [super updateConstraints];
    [self removeConstraints:self.constraints];
    NSArray * constraints;
    NSDictionary * views;
    AMPageView * previous;
    for (AMPageView * pageView in self.pageViews) {
        if (!previous) {
            views = NSDictionaryOfVariableBindings(pageView);
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[pageView]" options:0 metrics:nil views:views];
            [self addConstraints:constraints];
        } else {
            views = NSDictionaryOfVariableBindings(previous,pageView);
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[previous]-5-[pageView]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views];
            [self addConstraints:constraints];
        }
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[pageView]-(>=0)-|" options:0 metrics:nil views:views];
        [self addConstraints:constraints];
        previous = pageView;
    }
    views = NSDictionaryOfVariableBindings(previous);
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[previous]-(>=0)-|" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    NSLayoutConstraint * constraint;
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:previous attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self addConstraint:constraint];
}

@end
