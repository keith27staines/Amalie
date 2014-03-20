//
//  AMFontSelectionViewController.h
//  FontList
//
//  Created by Keith Staines on 17/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AMFontSelectionViewController : NSViewController

@property (strong) IBOutlet NSArrayController *arrayController;

@property (weak) IBOutlet NSProgressIndicator *fontLoadProgressIndicator;


@property (readonly) NSMutableArray * fontArray;
@property (copy) NSString * fontFamilyToSelect;
@property (copy, readonly) NSString * selectedFontFamily;
@property (copy) NSString * exampleText;
@property BOOL requireRegularFont;
@property BOOL requireItalicFont;
@property BOOL requireBoldFont;
@property BOOL requireItalicBoldFont;
@property BOOL requireSerifs;
@property CGFloat rowHeight;

@end
