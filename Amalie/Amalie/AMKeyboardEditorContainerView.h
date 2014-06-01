//
//  AMKeyboardEditorContainerView.h
//  Amalie
//
//  Created by Keith Staines on 31/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AMKeyboardEditorContainerView : NSView

- (void)loadKeyboardSelectorPopup;



@property NSMutableArray * dynamicallyAddedConstraints;

@end
