//
//  AMAppController.h
//  Amalie
//
//  Created by Keith Staines on 07/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMTrayDatasourceProtocol.h"

@class AMPreferencesWindowController;
@class AMPreferences;

@interface AMAppController : NSObject <AMTrayDatasourceProtocol>

- (IBAction)showPreferencesPanel:(id)sender;






@end
