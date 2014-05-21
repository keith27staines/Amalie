//
//  AMInspectorViewController.m
//  Amalie
//
//  Created by Keith Staines on 19/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import "AMInspectorViewController.h"
#import "AMInspectorsViewController.h"
#import "AMInspectorView.h"
#import "AMDInsertedObject.h"
#import "AMContentViewController.h"

@interface AMInspectorViewController ()

@property (readonly) AMInspectorView * inspectorView;
@end

@implementation AMInspectorViewController

-(AMDInsertedObject*)amdObject
{
    return [self.delegate amdObject];
}
-(void)dataWasUpdated
{
    [self.delegate.contentViewController reloadData];
}
-(void)reloadData {
    [self.inspectorView reloadData];
}

-(AMInspectorView*)inspectorView
{
    return (AMInspectorView*)self.view;
}
@end
