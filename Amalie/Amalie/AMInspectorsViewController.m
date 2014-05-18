//
//  AMInspectorsViewController.m
//  Amalie
//
//  Created by Keith Staines on 18/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMInspectorsViewController.h"
#import "AMDFunctionDef+Methods.h"
#import "AMFunctionInspectorViewController.h"

@interface AMInspectorsViewController ()
{
    __weak                 id _object;
    NSMutableDictionary     * _viewControllers;
}
@property (weak,readwrite) id object;
@property (weak,readonly) NSViewController * currentViewController;
@property (weak,readonly) NSView * currentView;
@end

@implementation AMInspectorsViewController

-(NSString *)nibName {
    return @"AMInspectorsViewController";
}
-(void)presentInspectorForObject:(id)object
{
    self.object = object;
}

-(void)presentInspectorView:(NSView *)view
{
    if (view != self.currentViewController.view) {
        [self clearInspectorView];
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addSubview:view];
    }
}

-(void)endEditing
{
    if (!self.object) {
        return;
    }
    // TODO: tell the object to end editing
}
-(void)clearInspectorView
{
    if (self.currentViewController) {
        [self.currentViewController.view removeFromSuperview];
    }
}
-(id)object
{
    return _object;
}
-(void)setObject:(id)object
{
    if (_object == object) {
        return;
    }
    [self endEditing];
    [self clearInspectorView];
    _object = object;
    NSView * view = self.currentViewController.view;
    [self presentInspectorView:view];
    [self reloadData];
}
-(void)reloadData
{
    if (!self.object) {
        return;
    }
    NSViewController * vc = self.currentViewController;
    vc.representedObject = self.object;
}
-(NSViewController*)currentViewController
{
    NSObject * object = self.object;
    NSString * className = NSStringFromClass([object class]);
    if (!self.viewControllers[className]) {
        if (object.class == [AMDFunctionDef class]) {
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
