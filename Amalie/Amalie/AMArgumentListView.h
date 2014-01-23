//
//  AMArgumentListView.h
//  Amalie
//
//  Created by Keith Staines on 08/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AMTextView.h"

@protocol AMArgumentListViewDelegate <NSTextFieldDelegate>

-(NSAttributedString*)displayStringForIndex:(NSUInteger)index
                           atScriptingLevel:(NSUInteger)scriptingLevel;
-(NSUInteger)displayStringCount;
-(NSFont*)bracesFontAtScriptingLevel:(NSUInteger)scriptingLevel;

@end

@interface AMArgumentListView : AMTextView

@property (weak) id<AMArgumentListViewDelegate>delegate;
@property BOOL readOnly;
@property NSUInteger scriptingLevel;
@property BOOL showEqualsSign;

-(void)reloadData;

@end
