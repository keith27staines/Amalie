//
//  AMDDocumentSettings.h
//  Amalie
//
//  Created by Keith Staines on 26/02/2014.
//  Copyright (c) 2014 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AMDDocumentSettings : NSManagedObject

@property (nonatomic, retain) NSData * pageSetup;

@end
