//
//  AMPageView.h
//  Amalie
//
//  Created by Keith Staines on 04/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMAmalieDocument;
@class AMAppController;

#import <Cocoa/Cocoa.h>
#import "AMLibraryDataSource.h"
#import "AMPageViewDelegate.h"


@interface AMPageView : NSView <NSDraggingDestination>

/*!
 A delegate from which we get all document structure and behaviour of items contained within the document.
 */
@property (weak) IBOutlet id<AMPageViewDelegate> delegate;

/*!
 The library data source is a delegate that allows us to load library items into a table
 */
@property (weak) IBOutlet AMAppController * libraryDataSource;

@property (readonly) NSSize pageSize;

-(void)prepareForReload;
-(void)applyUserPreferences;

@end
