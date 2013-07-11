//
//  AMAppController.h
//  Amalie
//
//  Created by Keith Staines on 07/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMPreferencesWindowController;
@class AMPreferences;

@protocol AMAppController <NSObject>
-(NSUInteger)trayRowCount;
-(NSDictionary*)dictionaryOfTrayRows;
-(NSArray*)arrayOfTrayRows;
-(NSImage*)iconForTrayItemWithName:(NSString*)trayItemKey;
@end


@interface AMAppController : NSObject <AMAppController>

- (IBAction)showPreferencesPanel:(id)sender;

+(NSImage*)iconForTrayItemWithName:(NSString*)trayItemKey;
+(NSUInteger)trayRowCount;
+(NSDictionary*)dictionaryOfTrayRows;
+(NSArray*)arrayOfTrayRows;




@end
