//
//  AMInspectorsViewController.h
//  Amalie
//
//  Created by Keith Staines on 18/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMAmalieDocument, AMContentViewController, AMDArgumentList, AMDInsertedObject;

#import <Cocoa/Cocoa.h>
#import "AMNameProviding.h"

@interface AMInspectorsViewController : NSViewController

@property (weak) IBOutlet AMAmalieDocument * document;

-(void)presentInspectorForContentViewController:(AMContentViewController*)contentViewController;

-(id<AMNameProviding>)argumentsNameProviderWithArguments:(AMDArgumentList*)argumentList;

@property (weak,readonly) AMDInsertedObject * amdObject;
@property (weak,readonly) AMContentViewController * contentViewController;

-(void)reloadData;

-(void)clearInspector;
@end
