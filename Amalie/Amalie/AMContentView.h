//
//  AMContentView.h
//  Amalie
//
//  Created by Keith Staines on 23/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class KSMExpression;

#import <Cocoa/Cocoa.h>
#import "AMInsertableViewDelegate.h"
#import "AMInsertableViewDataSource.h"

@interface AMContentView : NSView

@property (weak) KSMExpression * expression;
@property (weak) id<AMInsertableViewDelegate>delegate;
@property (weak) id<AMInsertableViewDataSource>datasource;

@end

