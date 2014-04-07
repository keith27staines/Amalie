//
//  AMDDocumentSettings.h
//  Amalie
//
//  Created by Keith Staines on 13/03/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AMDFontAttributes;

@interface AMDDocumentSettings : NSManagedObject

@property (nonatomic, retain) NSData * colorSettingsData;
@property (nonatomic, retain) NSData * fontSettingsData;
@property (nonatomic, retain) NSData * pageSettingsData;
@property (nonatomic, retain) NSData * mathStyleSettingsData;

@end
