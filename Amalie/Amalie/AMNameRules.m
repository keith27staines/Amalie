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
    NSString * firstLetter = @"K";
    NSString * followingString = [NSString stringWithFormat:@"%ld",i];
    NSDictionary * subscriptAttributes = @{NSSuperscriptAttributeName: @-6};
    NSAttributedString * subscript;
    subscript = [[NSAttributedString alloc] initWithString:(NSString *)followingString attributes:subscriptAttributes];
    NSMutableAttributedString * ms = [[NSMutableAttributedString alloc] initWithString:firstLetter attributes:nil];
    [ms appendAttributedString:subscript];
    return [ms copy];
}

@end
