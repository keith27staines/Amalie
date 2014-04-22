//
//  AMDocumentView.h
//  Amalie
//
//  Created by Keith Staines on 06/10/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMAppController;
@class AMAmalieDocument;
@class AMPageView;

#import <Cocoa/Cocoa.h>

@interface AMDocumentView : NSView

@property (weak,readonly) AMAmalieDocument * amalieDocument;
@property (weak,readonly) AMAppController * appController;
@property (readonly) NSMutableArray * pageViews;
@property NSColor * backgroundColor;
- (id)initWithAppController:(AMAppController*)appController amalieDocument:(AMAmalieDocument*)amalieDocument;
-(void)reloadData;
-(void)applyUserPreferences;
-(AMPageView*)addPageView;

@end

