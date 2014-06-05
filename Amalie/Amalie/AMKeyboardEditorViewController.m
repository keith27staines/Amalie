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
    NSString * _stringValue;
    __weak id _context;
}
@property (weak,readwrite) id context;
@end

@implementation AMKeyboardEditorViewController

-(NSString *)stringValue {
    return [_stringValue copy];
}
-(void)setStringValue:(NSString *)stringValue {
    _stringValue = [stringValue copy];
    [self reloadData];
}
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
-(void)presentEditorWithString:(NSString*)string nameProvider:(id<AMNameProviding>)nameProvider context:(id)context completionHandler:(void (^)(void))completionHandler;
{
    [self view]; // ensure view is loaded so all outlets are connected
    //self.expressionNodeController.delegate = self;
    self.nameProvider = nameProvider;
    self.stringValue = [string copy];
    self.completionHandler = completionHandler;
    self.context = context;
    [self reloadData];
}
-(void)reloadData
{
    
}

@end
