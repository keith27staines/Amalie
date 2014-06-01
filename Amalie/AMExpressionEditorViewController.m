//
//  AMExpressionEditorViewController.m
//  Amalie
//
//  Created by Keith Staines on 06/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMExpressionEditorViewController.h"
#import "AMDExpression+Methods.h"
#import "AMAmalieDocument.h"
#import "AMExpressionNodeController.h"
#import "AMPersistedObjectWithArgumentsNameProvider.h"
#import "AMExpressionNodeContainerView.h"

@interface AMExpressionEditorViewController ()
{

}

@property (weak) IBOutlet AMExpressionNodeContainerView *expressionNodeContainerView;

@property (strong) IBOutlet AMExpressionNodeController *expressionNodeController;

@property (weak) IBOutlet NSTextField *expressionStringField;

@property (readwrite, copy) NSString * expressionString;
@end

@implementation AMExpressionEditorViewController

-(NSString *)nibName
{
    return @"AMExpressionEditorViewController";
}
-(void)presentExpressionEditorWithExpressionString:(NSString*)expressionString nameProvider:(id<AMNameProviding>)nameProvider completionHandler:(void (^)(void))completionHandler
{
    [self view]; // ensure view is loaded so all outlets are connected
    self.expressionNodeController.delegate = self;
    self.nameProvider = nameProvider;
    self.expressionString = expressionString;
    self.completionHandler = completionHandler;
    [self reloadData];
}
-(void)reloadData
{
    self.expressionStringField.stringValue = self.expressionString;
    [self.expressionNodeController setExpressionString:self.expressionString];
    self.expressionNodeContainerView.expressionNodeView = self.expressionNodeController.expressionNodeView;
}
-(void)updateWithString:(NSString*)string
{
    self.expressionString = string;
    [self reloadData];
}

#pragma mark - NSTextFieldDelegate -
-(void)controlTextDidBeginEditing:(NSNotification *)obj
{
    
}
-(void)controlTextDidEndEditing:(NSNotification *)obj
{
    NSTextField * tf = obj.object;
    NSString * string = tf.stringValue;
    [self updateWithString:string];    
}
-(void)controlTextDidChange:(NSNotification *)obj
{
}
#pragma mark - AMExpressionNodeControllerDelegate -
-(id<AMNameProviding>)expressionNodeControllerWantsNameProvider:(AMExpressionNodeController*)controller
{
    return self.nameProvider;
}
-(NSString *)expressionNodeControllerRequiresExpressionString:(AMExpressionNodeController *)controller {
    return self.expressionString;
}
@end
