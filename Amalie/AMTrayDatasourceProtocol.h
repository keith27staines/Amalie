//
//  AMTrayDatasourceProtocol.h
//  Amalie
//
//  Created by Keith Staines on 11/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AMTrayItem;

@protocol AMTrayDatasourceProtocol <NSObject>
-(NSUInteger)trayItemCount;
-(NSDictionary*)dictionaryOfAllTrayItems;
-(NSArray*)arrayOfAllTrayItems;
-(AMTrayItem*)trayItemAtIndex:(NSUInteger)index;
@end
