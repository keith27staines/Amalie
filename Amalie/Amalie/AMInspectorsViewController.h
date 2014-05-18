//
//  AMInspectorsViewController.h
//  Amalie
//
//  Created by Keith Staines on 18/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

@class AMAmalieDocument;

#import <Cocoa/Cocoa.h>

@interface AMInspectorsViewController : NSViewController

@property (weak) IBOutlet AMAmalieDocument * document;

-(void)presentInspectorForObject:(id)object;
-(void)reloadData;
@property (weak,readonly) id object;
@end
