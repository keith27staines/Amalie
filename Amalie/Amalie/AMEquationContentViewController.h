//
//  AMEquationContentViewController.h
//  Amalie
//
//  Created by Keith Staines on 03/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMExpressionNodeView;

#import "AMContentViewController.h"

@interface AMEquationContentViewController : AMContentViewController
{
    
    __weak NSTextField *_nameField;
    __weak NSTextField *_expressionString;
}

@property (weak) IBOutlet NSTextField *nameField;

@property (weak) IBOutlet NSTextField *expressionString;

@property (weak) IBOutlet AMExpressionNodeView * expressionView;

- (IBAction)nameWasEdited:(NSTextField *)sender;

- (IBAction)expressionStringWasEdited:(NSTextField *)sender;







@end
