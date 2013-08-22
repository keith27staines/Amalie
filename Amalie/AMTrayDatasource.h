//
//  AMTrayDatasource.h
//  Amalie
//
//  Created by Keith Staines on 11/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMTrayItem;

#import <Foundation/Foundation.h>
#import "AMConstants.h"

@protocol AMTrayDatasource <NSObject>
-(NSUInteger)trayItemCount;
-(NSDictionary*)dictionaryOfAllTrayItems;
-(NSArray*)arrayOfAllTrayItems;
-(AMTrayItem*)trayItemAtIndex:(NSUInteger)index;
-(AMTrayItem*)trayItemWithKey:(NSString*)key;
-(NSString*)keyForType:(AMInsertableType)type;
-(AMInsertableType)typeForKey:(NSString*)key;
@end
