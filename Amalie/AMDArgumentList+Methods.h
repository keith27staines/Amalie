//
//  AMDArgumentList+Methods.h
//  Amalie
//
//  Created by Keith Staines on 04/11/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

@class AMDArgument;

#import "AMDArgumentList.h"

@interface AMDArgumentList (Methods)

+(AMDArgumentList*)makeArgumentListUsing:(NSManagedObjectContext*)moc;

-(AMDArgument*)argumentAtIndex:(NSUInteger)index;
-(AMDArgument*)addArgumentAtIndex:(NSInteger)index;
-(BOOL)removeArgumentAtIndex:(NSUInteger)index;

@end
