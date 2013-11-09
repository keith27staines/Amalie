//
//  AMArgumentListView.h
//  Amalie
//
//  Created by Keith Staines on 08/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMDArgumentList;

#import <Cocoa/Cocoa.h>

@protocol AMArgumentListViewDelegate <NSTextFieldDelegate>

-(NSAttributedString*)displayStringForIndex:(NSUInteger)index;
-(NSUInteger)displayStringCount;

@end

@interface AMArgumentListView : NSView

@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSTextField  *rightBrace;
@property (weak) IBOutlet NSTextField  *leftBrace;
@property (weak) IBOutlet NSLayoutConstraint *csvWidthConstraint;

@property (weak) id<AMArgumentListViewDelegate>delegate;
@property BOOL readOnly;
@property BOOL autoFitContent;

-(void)reloadData;

@end
