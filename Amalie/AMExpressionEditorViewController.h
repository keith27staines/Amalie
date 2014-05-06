//
//  AMExpressionEditorViewController.h
//  Amalie
//
//  Created by Keith Staines on 06/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMDExpression, AMAmalieDocument;

#import <Cocoa/Cocoa.h>

@interface AMExpressionEditorViewController : NSViewController

@property (weak) AMDExpression * expression;
@property (weak) AMAmalieDocument * document;
- (IBAction)close:(id)sender;

@property (weak) IBOutlet NSTextField *expressionStringField;

-(void)reloadData;

@end
