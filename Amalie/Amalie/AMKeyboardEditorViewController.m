//
//  AMKeyboardEditorViewController.m
//  Amalie
//
//  Created by Keith Staines on 01/06/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMKeyboardEditorViewController.h"

@interface AMKeyboardEditorViewController()
{
}

@end

@implementation AMKeyboardEditorViewController



- (IBAction)close:(id)sender {
    [self endEditing];
    self.completionHandler();
}

-(void)endEditing
{
    if ([self.view.window makeFirstResponder:self.view.window]) {
        /* All fields are now valid; it’s safe to use fieldEditor:forObject:
         to claim the field editor. */
    }
    else {
        /* Force first responder to resign. */
        [self.view.window endEditingFor:nil];
    }
}

-(void)reloadData
{
    
}

@end
