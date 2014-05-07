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
@interface AMExpressionEditorViewController ()
{
    void (^_completionHandler)(void);
}
- (IBAction)close:(id)sender;

@property (strong) IBOutlet AMExpressionNodeController *expressionNodeController;

@property (weak) IBOutlet NSTextField *expressionStringField;

@property id<AMNameProviding>nameProvider;
@property (readwrite, copy) NSString * expressionString;

@end

@implementation AMExpressionEditorViewController

-(NSString *)nibName
{
    return @"AMExpressionEditorViewController";
}
-(void)presentExpressionEditorWithExpressionString:(NSString*)expressionString nameProvider:(id<AMNameProviding>)nameProvider completionHandler:(void (^)(void))completionHandler
{
    self.nameProvider = nameProvider;
    self.expressionString = expressionString;
    _completionHandler = completionHandler;
}
-(void)reloadData
{
    self.expressionStringField.stringValue = self.expressionString;
}
- (IBAction)close:(id)sender {
    [self.view.window endEditingFor:self.expressionStringField];
    _completionHandler();
}
#pragma mark - AMExpressionNodeControllerDelegate -
-(id<AMNameProviding>)expressionNodeControllerWantsNameProvider{
    return self.nameProvider;
}
-(NSString *)expressionNodeControllerRequiresExpressionString:(AMExpressionNodeController *)controller {
    return self.expressionString;
}
//#pragma mark - AMNameProviderDelegate -
//-(CGFloat)baseFontSize {
//    return [self.document baseFontSize];
//}
//-(CGFloat)superscriptingFraction {
//    return [self.document superscriptingFraction];
//}
//-(CGFloat)superscriptOffset {
//    return [self.document superscriptOffset];
//}
//-(AMFontAttributes *)fontAttributesForType:(AMFontType)fontType {
//    return [self.document fontAttributesForType:fontType];
//}
//-(CGFloat)smallestFontSizeFraction {
//    return [self.document smallestFontSizeFraction];
//}
//-(CGFloat)subscriptOffset {
//    return [self.document smallestFontSizeFraction];
//}
@end
