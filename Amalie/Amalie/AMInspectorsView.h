//
//  AMInspectorsView.h
//  Amalie
//
//  Created by Keith Staines on 18/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMInspectorView;

#import <Cocoa/Cocoa.h>

@interface AMInspectorsView : NSView

@property (weak) IBOutlet NSView *headerView;


-(void)presentInspector:(AMInspectorView*)inspectorView;

-(void)clearInspector;
@end
