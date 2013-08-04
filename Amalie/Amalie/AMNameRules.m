//
//  AMNameRules.m
//  Amalie
//
//  Created by Keith Staines on 23/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMNameRules.h"

@implementation AMNameRules

-(BOOL)checkName:(NSString*)proposedName
         forType:(AMInsertableType)type
           error:(NSError**)error
{
    return YES;
}

-(NSAttributedString*)suggestNameForType:(AMInsertableType)type
{
    static NSUInteger i;
    i++;
    NSString * str = [NSString stringWithFormat:@"K%ld",i];
    return [[NSAttributedString alloc] initWithString:str attributes:nil];
}

@end
