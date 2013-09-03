//
//  AMFunctionContentViewController.h
//  Amalie
//
//  Created by Keith Staines on 03/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMExpressionNodeView;
@class AMEquationContentView;
@class AMNameView;

#import "AMContentViewController.h"

@interface AMFunctionContentViewController : AMContentViewController
{
    
    __weak NSTextField *_nameField;
    __weak NSTextField *_expressionStringView;
}

@property (weak) IBOutlet AMNameView *nameView;

@property (weak) IBOutlet NSTextField *expressionStringView;

@property (weak) IBOutlet AMExpressionNodeView * expressionView;

@property (strong) IBOutlet AMEquationContentView *equationView;

- (IBAction)nameAction:(AMNameView *)sender;

- (IBAction)expressionStringWasEdited:(NSTextField *)sender;




@end
