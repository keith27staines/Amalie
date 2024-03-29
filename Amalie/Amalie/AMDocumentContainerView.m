//
//  AMDocumentContainerView.m
//  Amalie
//
//  Created by Keith Staines on 13/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMDocumentContainerView.h"
#import "AMDocumentView.h"
#import "AMPageView.h"
#import "AMConstants.h"

@interface AMDocumentContainerView()
{
    NSScrollView   * _scrollView;
    AMDocumentView * _documentView;
}

@end

@implementation AMDocumentContainerView

-(BOOL)isFlipped
{
    return YES;
}
-(void)applyUserPreferences
{
    [self.documentView applyUserPreferences];
}
-(NSScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[NSScrollView alloc] init];
        [_scrollView setDocumentView:self.documentView];
        [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_scrollView setHasHorizontalScroller:YES];
        [_scrollView setHasVerticalScroller:YES];
        [_scrollView setBackgroundColor:self.documentView.backgroundColor];
        [_scrollView setDrawsBackground:YES];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}
-(AMDocumentView*)documentView
{
    if (!_documentView) {
        _documentView = [[AMDocumentView alloc] initWithAppController:self.appController amalieDocument:self.amalieDocument];
        [_documentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_documentView setNeedsUpdateConstraints:YES];
        [_documentView setNeedsDisplay:YES];
    }
    return _documentView;
}

-(void)updateConstraints
{
    [super updateConstraints];
    
    NSScrollView * scrollView = self.scrollView;
    NSClipView * clipView = scrollView.contentView;
    AMDocumentView * documentView = self.documentView;
    NSView * documentContainer = self;
    
    NSDictionary * views = NSDictionaryOfVariableBindings(documentContainer,scrollView,clipView,documentView);
    NSArray * constraints;
    
    // We are the document container, which contains the scroll view, which contains a clip view, which contains the document background view, which contains the page views).

    // position scroll view within the container (the container being us). The scroll view must fill its container entirely.
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:views];
    [self addConstraints:constraints];
    
    // Position the document view within the scroll view
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[documentView(>=clipView)]" options:0 metrics:nil views:views];
    [clipView addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[documentView(>=clipView)]" options:0 metrics:nil views:views];
    [clipView addConstraints:constraints];
    
    NSDictionary * metrics = @{@"minDocWidth": @(kAMMinWidthDocumentContainerView)};
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[documentContainer(>=minDocWidth)]" options:0 metrics:metrics views:views];
    [self addConstraints:constraints];
    
    [clipView setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
    [clipView setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationVertical];
}











@end
