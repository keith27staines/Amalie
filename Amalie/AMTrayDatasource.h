//
//  AMTrayDataSource.h
//  Amalie
//
//  Created by Keith Staines on 11/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMLibraryItem;

#import <Foundation/Foundation.h>
#import "AMConstants.h"

@protocol AMTrayDataSource <NSObject>
-(NSUInteger)trayItemCount;
-(NSDictionary*)dictionaryOfAllLibraryItems;
-(NSArray*)arrayOfAllTrayItems;
-(AMLibraryItem*)trayItemAtIndex:(NSUInteger)index;
-(AMLibraryItem*)trayItemWithKey:(NSString*)key;
-(NSString*)keyForType:(AMInsertableType)type;
-(AMInsertableType)typeForKey:(NSString*)key;
@end
