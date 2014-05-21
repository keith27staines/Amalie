//
//  AMInspectorViewController.h
//  Amalie
//
//  Created by Keith Staines on 19/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMInspectorsViewController, AMInspectorView, AMDInsertedObject;

#import <Cocoa/Cocoa.h>

@interface AMInspectorViewController : NSViewController

@property (weak) AMInspectorsViewController * delegate;
-(AMDInsertedObject*)amdObject;
-(void)reloadData;
-(AMInspectorView*)inspectorView;
-(void)dataWasUpdated;
@end
