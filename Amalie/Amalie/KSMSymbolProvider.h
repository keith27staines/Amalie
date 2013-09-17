//
//  KSMSymbolProvider.h
//  Amalie
//
//  Created by Keith Staines on 17/09/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSMSymbolProvider : NSObject

+(id)sharedSymbolProvider;

-(NSString*)symbolForString:(NSString*)string;

@end
