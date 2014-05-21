//
//  AMInspectorsViewController.m
//  Amalie
//
//  Created by Keith Staines on 18/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMInspectorsViewController.h"
#import "AMAmalieDocument.h"
#import "AMInspectorsView.h"
#import "AMInspectorView.h"
#import "AMContentViewController.h"
#import "AMFunctionContentViewController.h"
#import "AMInspectorViewController.h"
#import "AMFunctionInspectorViewController.h"
#import "AMNameProviding.h"
#import "AMPersistedObjectWithArgumentsNameProvider.h"

@interface AMInspectorsViewController ()
{
    __weak AMContentViewController * _contentViewController;
    NSMutableDictionary     * _viewControllers;
}
@property (weak,readwrite) AMContentViewController  * contentViewController;
@property (weak,readonly) AMInspectorViewController * inspectorViewController;
@property (readonly) AMInspectorsView * inspectorsView;
@property (weak,readonly) NSView * currentView;
@end

@implementation AMInspectorsViewController

-(NSString *)nibName {
    return @"AMInspectorsViewController";
}
-(void)presentInspectorForContentViewController:(AMContentViewController*)contentViewController;
{
    if (contentViewController) {
        self.contentViewController = contentViewController;
    } else {
        [self clearInspector];
    }
}

-(void)presentInspectorView:(AMInspectorView *)inspectorView
{
    if (inspectorView) {
        [self.inspectorsView presentInspector:inspectorView];
    } else {
        [self clearInspector];
    }
}
-(id<AMNameProviding>)argumentsNameProviderWithArguments:(AMDArgumentList*)argumentList
{
    return [self.document argumentsNameProviderWithArguments:argumentList];
}

-(void)endEditing
{
    if (!self.inspectorViewController) {
        return;
    }
    // TODO: tell the object to end editing
}
-(void)clearInspector
{
    [self.inspectorsView clearInspector];
}
-(AMInspectorsView*)inspectorsView
{
    return ((AMInspectorsView*)self.view);
}
-(AMContentViewController*)contentViewController
{
    return _contentViewController;
}
-(void)setContentViewController:(AMContentViewController*)contentViewController
{
    if (_contentViewController == contentViewController) {
        return;
    }
    [self endController];
    [self beginController:contentViewController];
}
-(void)endController
{
    if (_contentViewController) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AMNotificationExpressionStringWasEdited object:self.contentViewController];
    }
}
-(void)beginController:(AMContentViewController*)contentViewController
{
    _contentViewController = contentViewController;
    AMInspectorView * view = self.inspectorViewController.inspectorView;
    [self presentInspectorView:view];
    [self reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:AMNotificationExpressionStringWasEdited object:self.contentViewController];
}
-(AMDInsertedObject *)amdObject
{
    return [self.contentViewController amdInsertedObject];
}
-(void)reloadData
{
    if (!self.contentViewController) {
        return;
    }
    AMInspectorViewController * inspector = self.inspectorViewController;
    inspector.delegate = self;
    inspector.representedObject = self.contentViewController;
    [inspector reloadData];
}
-(AMInspectorViewController*)inspectorViewController
{
    NSObject * object = self.contentViewController;
    NSString * className = NSStringFromClass([object class]);
    if (!self.viewControllers[className]) {
        if (object.class == [AMFunctionContentViewController class]) {
            self.viewControllers[className] = [[AMFunctionInspectorViewController alloc] init];
        }
    }
    return self.viewControllers[className];
}
-(NSMutableDictionary*)viewControllers
{
    if (!_viewControllers) {
        _viewControllers = [NSMutableDictionary dictionary];
    }
    return _viewControllers;
}
@end
