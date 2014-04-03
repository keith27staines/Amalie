//
//  AMPageSettings.h
//  Amalie
//
//  Created by Keith Staines on 02/04/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMPageSettings : NSObject
+(id)settingsWithUserDefaults;
+(id)settingsWithFactoryDefaults;
@end
