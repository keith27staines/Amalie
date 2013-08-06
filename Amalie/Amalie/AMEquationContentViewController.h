//
//  AMEquationContentViewController.h
//  Amalie
//
//  Created by Keith Staines on 03/08/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMInteriorExpressionView;

#import "AMContentViewController.h"

@interface AMEquationContentViewController : AMContentViewController
{
    
    __weak NSTextField *_name;
    __weak NSTextField *_expressionString;
}

@property (weak) IBOutlet NSTextField *name;

@property (weak) IBOutlet NSTextField *expressionString;

@property (weak) IBOutlet AMInteriorExpressionView * expressionView;

- (IBAction)nameWasEdited:(NSTextField *)sender;

- (IBAction)expressionStringWasEdited:(NSTextField *)sender;







@end
