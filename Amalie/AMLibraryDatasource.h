//
//  AMLibraryDataSource.h
//  Amalie
//
//  Created by Keith Staines on 11/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMLibraryItem;

#import <Foundation/Foundation.h>
#import "AMConstants.h"

@protocol AMLibraryDataSource <NSObject>
-(NSUInteger)libraryItemCount;
-(NSDictionary*)dictionaryOfAllLibraryItems;
-(NSArray*)arrayOfLibraryItems;
-(AMLibraryItem*)libraryItemAtIndex:(NSUInteger)index;
-(AMLibraryItem*)libraryItemWithKey:(NSString*)key;
-(NSString*)keyForType:(AMInsertableType)type;
-(AMInsertableType)typeForKey:(NSString*)key;
@end
