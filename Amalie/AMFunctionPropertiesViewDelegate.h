//
//  AMFunctionPropertiesViewDelegate.h
//  Amalie
//
//  Created by Keith Staines on 01/05/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMDFunctionDef+Methods.h"

@protocol AMFunctionPropertiesViewDelegate <NSTableViewDelegate,NSTableViewDataSource,NSTextFieldDelegate>

-(void)setupValuePopup:(NSPopUpButton*)popup;
-(AMDFunctionDef*)functionDef;
@end

