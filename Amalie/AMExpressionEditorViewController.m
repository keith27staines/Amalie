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


@end

@implementation AMExpressionEditorViewController

-(NSString *)nibName
{
    return @"AMExpressionEditorViewController";
}
-(void)presentEditorWithString:(NSString *)string nameProvider:(id<AMNameProviding>)nameProvider context:(id)context completionHandler:(void (^)(void))completionHandler
{
    self.expressionNodeController.delegate = self;
    [super presentEditorWithString:string nameProvider:nameProvider context:context completionHandler:completionHandler];
}
-(void)reloadData
{
    self.expressionStringField.stringValue = self.stringValue;
    [self.expressionNodeController setExpressionString:self.stringValue];
    self.expressionNodeContainerView.expressionNodeView = self.expressionNodeController.expressionNodeView;
}

#pragma mark - NSTextFieldDelegate -
-(void)controlTextDidBeginEditing:(NSNotification *)obj
{
    
}
-(void)controlTextDidEndEditing:(NSNotification *)obj
{
    NSTextField * tf = obj.object;
    self.stringValue = tf.stringValue;
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
    return self.stringValue;
}
@end
