//
//  AMContentView.h
//  Amalie
//
//  Created by Keith Staines on 23/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class KSMExpression;

#import <Cocoa/Cocoa.h>
#import "AMGroupedView.h"
#import "AMContentViewDataSource.h"

@interface AMContentView : AMGroupedView

@property (weak) IBOutlet id<AMContentViewDataSource>datasource;

/*!
 Subclasses should override the default implementation which does nothing. This method is called when the content view is first added, and is a good opportunity to load the view with appropriate data if necessary
 */
-(void)populate;

@end

