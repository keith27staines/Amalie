//
//  AMDocumentContainerView.h
//  Amalie
//
//  Created by Keith Staines on 13/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AMDocumentView;
@class AMWorksheetView;
@class AMAmalieDocument;
@class AMAppController;

@interface AMDocumentContainerView : NSView
@property (readwrite) IBOutlet AMAmalieDocument * amalieDocument;
@property (readwrite) IBOutlet AMAppController * appController;

@property (readonly) NSScrollView * scrollView;
@property (readonly) AMDocumentView * documentView;

-(void)applyUserPreferences;

@end
